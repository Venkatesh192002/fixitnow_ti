import 'package:auscurator/machine_iot/screens/NotificationScreen.dart';
import 'package:auscurator/provider/layout_provider.dart';
import 'package:auscurator/repository/layout_repository.dart';
import 'package:auscurator/screens/assets/screen/Assets.dart';
import 'package:auscurator/screens/breakdown/screen/breakdown1.dart';
import 'package:auscurator/screens/dashboard/screen/Dashboard.dart';
import 'package:auscurator/screens/dialog.dart/logout_dialog.dart';
import 'package:auscurator/screens/pm/screen/PM.dart';
import 'package:auscurator/screens/status/screen/Status.dart';
import 'package:auscurator/screens/widgets_common/appbar.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/widgets/context_extension.dart';
import 'package:auscurator/widgets/dialogs.dart';
import 'package:auscurator/widgets/networkimagecus.dart';
import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:auscurator/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final List<Widget> _screens = [
    const Dashboard(),
    const Assets(),
    const Breakdown1(), // Breakdown screen
    const Status(),
    const PM(),
  ];

  DateTime? lastBackPressTime;

  @override
  void initState() {
    super.initState();
    // Set initial screen to Breakdown1 after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LayoutRepository().changeScreen(2, context); // Navigate to Breakdown1
    });
  }

  Future<bool> onWillPop() async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return Future.value(false);
    }

    final now = DateTime.now();
    if (lastBackPressTime == null ||
        now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
      lastBackPressTime = now;
      LayoutRepository().changeScreen(2, context); // Stay on Breakdown1
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProvider>(
      builder: (context, layout, _) {
        return WillPopScope(
          onWillPop: onWillPop,
          child: Scaffold(
            appBar: layout.pageIndex == 1
                ? CommonAppBar(title: "Assets")
                : layout.pageIndex == 2
                    ? null // No AppBar for Breakdown1
                    : layout.pageIndex != 0
                        ? null
                        : CommonAppBar(
                            title: "DashBoard",
                            action: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                      Icons.notifications_active_outlined),
                                  color: Colors.white,
                                  onPressed: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationScreen(),
                                      ),
                                    )
                                  },
                                ),
                              ],
                            ),
                            leading: IconButton(
                              icon: const Icon(Icons.power_settings_new),
                              color: Colors.white,
                              onPressed: () =>
                                  commonDialog(context, LogoutDialog()),
                            ),
                          ),
            backgroundColor: const Color(0xF5F5F5F5),
            body: _screens[layout.pageIndex],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_outlined),
                    activeIcon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.build_outlined),
                    activeIcon: Icon(Icons.build),
                    label: 'Assets',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.warning_amber_outlined),
                    activeIcon: Icon(Icons.warning),
                    label: 'Breakdown',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.group_outlined),
                    activeIcon: Icon(Icons.group),
                    label: 'Status',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.schedule_outlined),
                    activeIcon: Icon(Icons.schedule),
                    label: 'PM',
                  ),
                ],
                currentIndex: layout.pageIndex,
                selectedItemColor: Palette.primary,
                unselectedItemColor: Colors.grey.shade500,
                selectedFontSize: 14,
                unselectedFontSize: 12,
                elevation: 0,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                onTap: (index) {
                  LayoutRepository().changeScreen(index, context);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}


class ProfileDialog extends StatefulWidget {
  const ProfileDialog({super.key});

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  Future<String?> empNameFuture = SharedUtil().getEmployeeName1;
  Future<String?> empImageFuture = SharedUtil().getImage1;

  void refreshEmployeeData() {
    setState(() {
      empNameFuture = SharedUtil().getEmployeeName1;
      empImageFuture = SharedUtil().getImage1;
    });
  }

  @override
  void initState() {
    refreshEmployeeData();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox.shrink(),
            TextCustom(
              "Profile",
              size: 18,
              fontWeight: FontWeight.w600,
            ),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
              ),
            )
          ],
        ),
        HeightHalf(),
        FutureBuilder<String?>(
          future: empImageFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2);
            } else if (snapshot.hasError ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return Icon(Icons.person, color: Colors.grey);
            } else {
              return Container(
                width: context.widthFull(),
                height: context.heightHalf(),
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: NetworkImageCustom(
                  logo: snapshot.data!,
                  fit: BoxFit.cover,
                ),
              );
            }
          },
        ),
        HeightHalf(),
        FutureBuilder<String?>(
          future: empNameFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2);
            } else if (snapshot.hasError ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return TextCustom(
                "",
                size: 14,
                maxLines: 1,
                color: Palette.pureWhite,
                fontWeight: FontWeight.bold,
              );
            } else {
              return TextCustom(
                "Emp Name: ${snapshot.data!}",
                size: 16,
                fontWeight: FontWeight.bold,
              );
            }
          },
        ),
      ],
    );
  }
}
