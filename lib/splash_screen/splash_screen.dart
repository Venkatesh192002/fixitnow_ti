
import 'package:auscurator/bottom_navigation/bottomnavscreen.dart';
import 'package:auscurator/login_screen.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../api_service_myconcept/keys.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController supplierAnimationController;
  late Animation<RelativeRect> supplierAnimation;
  late AnimationController animationController;
  late Animation<RelativeRect> positionAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    supplierAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    positionAnimation = RelativeRectTween(
      begin: const RelativeRect.fromLTRB(-600, 0, 0, 50),
      end: const RelativeRect.fromLTRB(0, 0, 0, 50),
    ).animate(animationController);

    supplierAnimation = RelativeRectTween(
      begin: const RelativeRect.fromLTRB(0, 0, -500, 0),
      end: const RelativeRect.fromLTRB(0, 0, 0, 0),
    ).animate(supplierAnimationController);

    animationController.forward();
    supplierAnimationController.forward();
    _checkLoginStatus();
    clearCacheIfFirstTime();
    setState(() {});
  }

  Future<void> clearCacheIfFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (isFirstRun) {
      // Clear the cache only during the first run
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true); // Deletes the cache directory
        print('Cache cleared on first install.');
      }

      // Mark as not the first run anymore
      await prefs.setBool('isFirstRun', false);
    } else {
      logger.i('Not the first install. Cache not cleared.');
    }
  }

  Future<void> _checkLoginStatus() async {
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          String isUserLoggedIn = SharedUtil().getIsUserLogin ?? '';
          logger.e(isUserLoggedIn);
          print('login -> $isUserLoggedIn');
          if (isUserLoggedIn == "") {
            // If the user is not logged in, navigate to LoginScreen

            // If the user is not logged in, navigate to LoginScreen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BottomNavScreen(),
              ),
            );
          }
        });
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    animationController.dispose();
    supplierAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            SizedBox(height: size.height * 0.30),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  SizedBox(
                    width: size.width * 0.40,
                    height: size.height * 0.40,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: Image.asset(
                        'images/fixitnow_logo1.png',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.20),
          ],
        ),
      ),
    );
  }
}
