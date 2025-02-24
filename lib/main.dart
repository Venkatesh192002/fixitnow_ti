import 'dart:async';
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/bottom_navigation/cubit/bottom_navigation_cubit.dart';
import 'package:auscurator/db/sqlite.dart';
import 'package:auscurator/firebase_options.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/save_spinner_bloc/bloc/save_button_bloc.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:auscurator/model/notification_model.dart';
import 'package:provider/provider.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auscurator/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:restart_app/restart_app.dart';
import 'package:auscurator/splash_screen/splash_screen.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:upgrader/upgrader.dart';

GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

// create notification channel
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('custom_sound'),
    playSound: true,
    showBadge: true,
    enableVibration: true);

// flutter local notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//firebase background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //await Firebase.initializeApp();
  final dateTime = DateTime.now();
  final formatter = DateFormat("dd-MM-yyyy hh:mm:ss");
  final formattedDateTime = formatter.format(dateTime);

  Sqlite().createItem(
    NotificationModel(message.notification!.title.toString(),
        message.notification!.body.toString(), formattedDateTime.toString()),
  );
}


Future<void> checkForUpdates() async {
  InAppUpdate.checkForUpdate().then((info) {
    if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      InAppUpdate.performImmediateUpdate()
          .catchError((e) => print("Update Error: $e"));
    }
  }).catchError((e) => print("Update Check Error: $e"));
}


checkConnection(BuildContext context) async {
  await Connectivity().checkConnectivity().then((value) {
    // logger.i("Connectivity status: $value");
    if (value == ConnectivityResult.none) {
      logger.w("No network connection detected.");
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/no_wifi.png',
                  width: 35,
                  height: 35,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Network issue",
                  style: TextStyle(
                    fontFamily: "Mulish",
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            content: const Text(
              "Activate network connectivity and initiate a device reboot for optimal functionality.",
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  logger.i("User clicked Restart.");
                  Restart.restartApp();
                },
                child: const Text("Restart!"),
              )
            ],
          );
        },
      );
    } else {}
  });
}

Future<void> main() async {
  final widgetBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);

  // Creating shared pref
  await SharedUtil().init();

  // Check if Firebase is already initialized before initializing it
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print("Firebase is already initialized");
  }

  await checkForUpdates();

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // Firebase local notification plugin
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Firebase messaging
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
  const setting = InitializationSettings(android: androidSetting);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print("onMessageReceive: StoreSqlite");

  // Format DateTime
  final dateTime = DateTime.now();
  final formatter = DateFormat("dd-MM-yyyy hh:mm:ss");
  final formattedDateTime = formatter.format(dateTime);

  // Store in Local Database
  Sqlite().createItem(
    NotificationModel(
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
      formattedDateTime,
    ),
  );

  try {
    RemoteNotification? notification = message.notification;
    // AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      // Android Notification Details
       AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        channel.id,
        channel.name,
        color: Colors.blue,
        sound: RawResourceAndroidNotificationSound('custom_sound'),
        playSound: true,
        icon: '@mipmap/ic_launcher', // Corrected icon reference
        styleInformation: BigTextStyleInformation(''),
      );

      // iOS Notification Details
      const DarwinNotificationDetails iosPlatformChannelSpecifics =
          DarwinNotificationDetails(
        sound: 'custom_sound.caf', // Ensure custom_sound.caf exists in iOS bundle
      );

      // Final Notification Details
       NotificationDetails notificationDetails = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      // Show Notification
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
      );
    }
  } catch (e) {
    print("Firebase error: $e");
  }

  print("Foreground message invoked");
});


  FirebaseMessaging.instance.onTokenRefresh.listen((event) {
    print("refreshed Token:$event");
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  flutterLocalNotificationsPlugin.initialize(setting);

  runApp(
    ProviderScope(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SaveButtonBloc>(
            create: (context) => SaveButtonBloc(),
          ),
          BlocProvider<BottomNavigationCubit>(
            create: (context) => BottomNavigationCubit(),
          ),
        ],
        child: MultiProvider(
          providers: providersAll,
          child: MaterialApp(
            navigatorKey: navigationKey,
            key: mainKey,
            routes: {"/login": (ctx) => const LoginScreen()},
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(30, 152, 165, 1),
              ),
              textTheme: TextTheme(
                titleMedium: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
            home: UpgradeAlert(
              showIgnore: true,
              showLater: true,
              child: const SplashScreen(), // Show upgrade prompt on the splash screen
            ),
          ),
        ),
      ),
    ),
  );

  initSplash();
}

void initSplash() {
  FlutterNativeSplash.remove();
}

// import 'dart:async';
// import 'package:auscurator/api_service_myconcept/keys.dart';
// import 'package:auscurator/bottom_navigation/cubit/bottom_navigation_cubit.dart';
// import 'package:auscurator/db/sqlite.dart';
// import 'package:auscurator/machine_iot/section_bottom_sheet/widget/save_spinner_bloc/bloc/save_button_bloc.dart';
// import 'package:auscurator/provider/all_provider.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:auscurator/model/notification_model.dart';
// import 'package:provider/provider.dart';
// import 'package:auscurator/util/shared_util.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:auscurator/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart';
// import 'package:restart_app/restart_app.dart';
// import 'package:auscurator/splash_screen/splash_screen.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

// GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

// // create notification channel
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     importance: Importance.high,
//     sound: RawResourceAndroidNotificationSound('custom_sound'),
//     playSound: true,
//     showBadge: true,
//     enableVibration: true);

// // flutter local notification
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// //firebase background message handler
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   //await Firebase.initializeApp();
//   final dateTime = DateTime.now();
//   final formatter = DateFormat("dd-MM-yyyy hh:mm:ss");
//   final formattedDateTime = formatter.format(dateTime);

//   Sqlite().createItem(
//     NotificationModel(message.notification!.title.toString(),
//         message.notification!.body.toString(), formattedDateTime.toString()),
//   );
// }

// checkConnection(BuildContext context) async {
//   await Connectivity().checkConnectivity().then((value) {
//     print("$value ${ConnectivityResult.none}");
//     if (value == ConnectivityResult.none) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDialog(
//             backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//             title: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'images/no_wifi.png',
//                   width: 35,
//                   height: 35,
//                   fit: BoxFit.fitHeight,
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 const Text(
//                   "Network issue",
//                   style: TextStyle(
//                     fontFamily: "Mulish",
//                     color: Color.fromARGB(255, 254, 31, 15),
//                   ),
//                 ),
//               ],
//             ),
//             content: const Text(
//                 "Activate network connectivity and initiate a device reboot for optimal functionality."),
//             actions: [
//               ElevatedButton(
//                 onPressed: () {
//                   Restart.restartApp();
//                 },
//                 child: const Text("Restart!"),
//               )
//             ],
//           );
//         },
//       );
//     }
//   });
// }

// Future<void> main() async {
//   // confirm widget build completion
//   final widgetBinding = WidgetsFlutterBinding.ensureInitialized();

//   FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);

//   // Creating shared pref
//   await SharedUtil().init();

//   // Check if Firebase is already initialized before initializing it
//   try {
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//           apiKey: "AIzaSyCJ81F_IwDjJeKom54S2iNwgo5180bJk3M",
//           authDomain: "auscuratorti.firebaseapp.com",
//           projectId: "auscuratorti",
//           storageBucket: "auscuratorti.appspot.com",
//           messagingSenderId: "120583001583",
//           appId: "1:120583001583:ios:79c4dcc1bb0c3f09a0121a"),
//     );
//   } catch (e) {
//     print("Firebase is already initialized");
//   }

//   await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     announcement: true,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );

//   // Firebase local notification plugin
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   // Firebase messaging
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );

//   const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
//   const setting = InitializationSettings(android: androidSetting);

//   FirebaseMessaging.onMessage.listen(
//     (RemoteMessage message) {
//       print("onMessageReceive:StoreSqlite");

//       final dateTime = DateTime.now();
//       final formatter = DateFormat("dd-MM-yyyy hh:mm:ss");
//       final formattedDateTime = formatter.format(dateTime);

//       Sqlite().createItem(
//         NotificationModel(
//             message.notification!.title.toString(),
//             message.notification!.body.toString(),
//             formattedDateTime.toString()),
//       );
//       try {
//         RemoteNotification? notification = message.notification;
//         // AppleNotification? apple = message.notification?.apple;
//         AndroidNotification? android = message.notification?.android;
//         if (notification != null && android != null) {
//           flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 color: Colors.blue,
//                 sound:
//                     const RawResourceAndroidNotificationSound('custom_sound'),
//                 playSound: true,
//                 icon: '@mipmap/ic_launcher', // Corrected icon reference
//                 styleInformation: const BigTextStyleInformation(''),
//               ),
//             ),
//           );
//         }
//       } catch (e) {
//         print("firebase error:$e");
//       }
//       print("foreground message invoked");
//     },
//   );

//   FirebaseMessaging.instance.onTokenRefresh.listen((event) {
//     print("refreshed Token:$event");
//   });

//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   flutterLocalNotificationsPlugin.initialize(setting);

//   runApp(
//     ProviderScope(
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider<SaveButtonBloc>(
//             create: (context) => SaveButtonBloc(),
//           ),
//           BlocProvider<BottomNavigationCubit>(
//             create: (context) => BottomNavigationCubit(),
//           )
//         ],
//         child: MultiProvider(
//           providers: providersAll,
//           child: MaterialApp(
//             navigatorKey: navigationKey,
//             routes: {"/login": (ctx) => const LoginScreen()},
//             debugShowCheckedModeBanner: false,
//             key: mainKey,
//             theme: ThemeData(
//               useMaterial3: true,
//               colorScheme: ColorScheme.fromSeed(
//                 onPrimary: const Color.fromRGBO(21, 147, 159, 1),
//                 seedColor: const Color.fromRGBO(30, 152, 165, 1),
//                 // background: const Color.fromARGB(157, 127, 230, 241),
//                 brightness: Brightness.light,
//               ),
//               textTheme: TextTheme(
//                 titleMedium: GoogleFonts.poppins(
//                   fontWeight: FontWeight.w500,
//                   fontStyle: FontStyle.normal,
//                 ),
//               ),
//             ),
//             home: const SplashScreen(),
//           ),
//         ),
//       ),
//     ),
//   );
//   initSplash();
// }

// void initSplash() {
//   FlutterNativeSplash.remove();
// }
