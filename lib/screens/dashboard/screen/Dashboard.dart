// ignore_for_file: unused_field,
import 'package:animate_do/animate_do.dart';
import 'package:auscurator/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auscurator/model/BreakdownTicketCountsModel.dart';
import 'package:auscurator/model/CategoryBasedModel.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:auscurator/provider/dashboard_provider.dart';
import 'package:auscurator/provider/layout_provider.dart';
import 'package:auscurator/repository/asset_repository.dart';
import 'package:auscurator/repository/dashboard_repository.dart';
import 'package:auscurator/screens/dashboard/widgets/stacked_breakdown_details.dart';
import 'package:auscurator/screens/dashboard/widgets/stacked_charts.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/widgets/networkimagecus.dart';
import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:auscurator/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String open_counts = '';
  String assign_counts = '';
  String progress_counts = '';
  String completed_counts = '';
  double mttr = 0.0;
  double mtbf = 0.0;
  String downtime = '';
  List<CategoryBreakdownReportLists> categoryList = [];
  DateTime? _fromDate;
  DateTime? _toDate;

  int _selectedIndex = 0;
  final bool _showTexts = true;
  String is_mttr = '';
  String is_down_time = '';
  final bool _isFirstLoad = true;
  String _statusName = 'date';
  String from = "";
  String to = "";

  void _onToggleChanged(int? index) {
    if (index != null) {
      setState(() {
        _selectedIndex = index;
        switch (_selectedIndex) {
          case 0:
            _statusName = "date";
            from = DateFormat('dd-MM-yyyy').format(DateTime.now());
            to = "";
            _fetchBreakdownTicketCounts();

            break;
          case 1:
            _statusName = "date";
            from = DateFormat('dd-MM-yyyy')
                .format(DateTime.now().subtract(const Duration(days: 1)));
            to = "";
            _fetchBreakdownTicketCounts();

            break;
          case 2:
            _statusName = "from_to";
            // from = DateFormat('dd-MM-yyyy')
            //     .format(DateTime.now().subtract(const Duration(days: 7)));
            final startOfWeek =
                DateTime.now().subtract(Duration(days: DateTime.now().weekday));
            from = DateFormat('dd-MM-yyyy').format(startOfWeek);
            to = DateFormat('dd-MM-yyyy').format(DateTime.now());
            _fetchBreakdownTicketCounts();
            break;
          case 3:
            _statusName = "from_to";
            from = DateFormat('dd-MM-yyyy')
                .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
            to = DateFormat('dd-MM-yyyy').format(DateTime.now());
            _fetchBreakdownTicketCounts();
            break;
          case 4:
            _statusName = "from_to";
            from = DateFormat('dd-MM-yyyy')
                .format(DateTime(DateTime.now().year, 1, 1));
            to = DateFormat('dd-MM-yyyy').format(DateTime.now());
            _fetchBreakdownTicketCounts();
            break;
          case 5:
            _statusName = "from_to";
            from = DateFormat('dd-MM-yyyy')
                .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
            to = DateFormat('dd-MM-yyyy').format(DateTime.now());
            _fetchBreakdownTicketCounts();
            break;
          default:
            _statusName = "date";
        }
      });
      // Call API after the selection has changed
      _fetchBreakdownTicketCounts();
    }
  }

  final employeename = SharedUtil().getEmployeeName;
  final employeeType = SharedUtil().getEmployeeType;
  final token = SharedUtil().getToken;

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshEmployeeData();
      _fetchDepartmentListDirectly();
      _fetchBreakdownTicketCounts();
      refreshEmployeeData();
      if (employeeType == "Engineer") {
        AssetRepository().getAssetEngineerIds(context);
      }
      if (employeeType == "Head/Engineer" ||
          employeeType == "Department Head") {
        AssetRepository().getAssetHeadEngineerIds(context);
      }
    });
    checkConnection(context);
    from = DateFormat('dd-MM-yyyy').format(DateTime.now());
    to = "";
    print('init status-> $employeename');
    print('init from-> $from, to-> $to');
    setState(() {});
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   // if (_isFirstLoad) {
  //   //   // Fetch the ticket counts after dependencies are loaded
  //   //   from = DateFormat('dd-MM-yyyy').format(DateTime.now());
  //   //   to = "";
  //   //   _fetchDepartmentListDirectly();
  //   //   _fetchBreakdownTicketCounts();
  //   //   _isFirstLoad = false;
  //   // }
  //   if (_isFirstLoad) {
  //     Future.delayed(Duration(seconds: 1), () {
  //       from = DateFormat('dd-MM-yyyy').format(DateTime.now());
  //       to = "";
  //       _fetchDepartmentListDirectly();
  //       _fetchBreakdownTicketCounts();
  //       _isFirstLoad = false;
  //     });
  //   }
  // }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.light(
              primary: const Color.fromRGBO(21, 147, 159, 1),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textTheme: TextTheme(
              titleMedium: TextStyle(
                fontFamily: "Mulish",
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != (isFromDate ? _fromDate : _toDate)) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
          from = DateFormat('dd-MM-yyyy').format(picked);
          print("From date selected: $from");
        } else {
          _toDate = picked;
          to = DateFormat('dd-MM-yyyy').format(picked);
          print("To date selected: $to");
        }
        if (from.isNotEmpty && to.isNotEmpty) {
          print("Calling API with From: $from, To: $to");
          _fetchBreakdownTicketCounts();
        } else {
          print("Dates are not valid: From=$from, To=$to");
        }
      });
    } else {
      print("Date not picked or the same as existing");
    }
  }

  Future<void> _fetchDepartmentListDirectly() async {
    try {
      DashboardRepository().departmentLists(context).then((value) async {
        if (dashboardProvider.departmentListData?.departmentLists != null &&
            dashboardProvider.departmentListData!.departmentLists!.isNotEmpty) {
          var countData =
              dashboardProvider.departmentListData!.departmentLists![0];

          // Log the retrieved values for debugging
          print('is_downtime: ${countData.isDowntime}');
          print('is_multiple: ${countData.isMultiple}');
          is_mttr = countData.isMttr.toString();
          is_down_time = countData.isDowntime.toString();
          final sharedUtil = SharedUtil();

          await sharedUtil.setisMttr(countData.isMttr.toString());

          await sharedUtil.setisDowntime(countData.isDowntime.toString());
          await sharedUtil.setisMultiple(countData.isMultiple.toString());
          // Save values to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('is_mttr', countData.isMttr!);
          prefs.setString('is_downtime', countData.isDowntime!);
          prefs.setString('is_multiple', countData.isMultiple!);

          print('Saved data to SharedPreferences');
        }
      });
    } catch (e) {
      // Handle error
      print("Error fetching data: $e");
    }
  }

  Future<void> _fetchBreakdownTicketCounts() async {
    try {
      DashboardRepository()
          .dashboardTicketCounts(context,
              from_date: from.toString(),
              to_date: to.toString(),
              status: _statusName)
          .then((value) {
        if (dashboardProvider.breakdownTicketCountData?.breakdownReportLists !=
                null &&
            dashboardProvider
                .breakdownTicketCountData!.breakdownReportLists!.isNotEmpty) {
          var countData = dashboardProvider
              .breakdownTicketCountData!.breakdownReportLists![0];
          // Update the state variables and UI
          setState(() {
            open_counts = countData.open.toString();
            assign_counts = countData.assign.toString();
            progress_counts = countData.inProgressTickets.toString();
            completed_counts = countData.completed.toString();
            mttr = countData.mttr!;
            mtbf = countData.mtbf!;
            downtime = countData.sumOfDowntime.toString();
          });
        }
      });
      DashboardRepository().openCompleted(context,
          from_date: from, to_date: to, status: _statusName);
      DashboardRepository().categoryBased(context,
          from_date: from, to_date: to, status: _statusName);

      // Log the API response
    } catch (e) {
      // Handle error
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LayoutProvider, DashboardProvider>(
      builder: (context, layout, dash, _) {
        return ListView(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              color: Colors.white,
              child: Row(
                children: [
                  layout.loginData?.data?[0].employeeImageUrl == null
                      ? FutureBuilder<String?>(
                          future: empImageFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2);
                            } else if (snapshot.hasError ||
                                snapshot.data == null ||
                                snapshot.data!.isEmpty) {
                              return Container(
                                width: 30,
                                height: 30,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    shape: BoxShape.circle),
                                child: Icon(Icons.person, color: Colors.grey),
                              );
                            } else {
                              return Container(
                                width: 50,
                                height: 50,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12)),
                                child: NetworkImageCustom(
                                  logo: "${snapshot.data ?? ""}",
                                  fit: BoxFit.cover,
                                ),
                              );
                            }
                          },
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12)),
                          child: NetworkImageCustom(
                            logo:
                                "${layout.loginData?.data?[0].employeeImageUrl}",
                            fit: BoxFit.cover,
                          ),
                        ),
                  WidthHalf(),
                  layout.loginData?.data?[0].employeeName == null
                      ? FutureBuilder<String?>(
                          future: empNameFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2);
                            } else if (snapshot.hasError ||
                                snapshot.data == null ||
                                snapshot.data!.isEmpty) {
                              return TextCustom(
                                "",
                                size: 14,
                                maxLines: 1,
                                color: Palette.dark,
                                fontWeight: FontWeight.bold,
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom("Welcome",
                                      color: Palette.primary,
                                      size: 18,
                                      fontWeight: FontWeight.bold),
                                  SizedBox(height: 4),
                                  TextCustom(
                                    snapshot.data!,
                                    size: 14,
                                    maxLines: 1,
                                    color: Palette.dark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              );
                            }
                          },
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom("Welcome",
                                color: Palette.primary,
                                size: 18,
                                fontWeight: FontWeight.bold),
                            SizedBox(height: 4),
                            TextCustom(
                              "${layout.loginData?.data?[0].employeeName}",
                              size: 14,
                              maxLines: 1,
                              color: Palette.dark,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                ],
              ),
            ),
            CustomScrollView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverPersistentHeaderDelegate(
                    minHeight: 50.0,
                    maxHeight: 70.0,
                    child: FadeInDown(
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Add welcome message here (if needed)
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         'Hello, ${employeename}', // Display employee name
                            //         style: TextStyle(fontFamily: "Mulish",
                            //           fontSize: 20,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //       Text(
                            //         'Welcome to FixitNow',
                            //         style: TextStyle(fontFamily: "Mulish",
                            //           fontSize: 16,
                            //           fontWeight: FontWeight.bold,
                            //           color: Colors.grey,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Expanded(
                              child: CupertinoSlidingSegmentedControl<int>(
                                padding: EdgeInsets.all(8),
                                proportionalWidth: true,
                                groupValue: _selectedIndex,
                                children: {
                                  0: Text(
                                    'Today',
                                    style: TextStyle(
                                      fontFamily: "Mulish",
                                      color: _selectedIndex == 0
                                          ? Colors.white
                                          : Colors.black, // White if selected
                                    ),
                                  ),
                                  1: Text(
                                    'Previous Day',
                                    style: TextStyle(
                                      fontFamily: "Mulish",
                                      color: _selectedIndex == 1
                                          ? Colors.white
                                          : Colors.black, // White if selected
                                    ),
                                  ),
                                  2: Text(
                                    'Week',
                                    style: TextStyle(
                                      fontFamily: "Mulish",
                                      color: _selectedIndex == 2
                                          ? Colors.white
                                          : Colors.black, // White if selected
                                    ),
                                  ),
                                  3: Text(
                                    'Month',
                                    style: TextStyle(
                                      fontFamily: "Mulish",
                                      color: _selectedIndex == 3
                                          ? Colors.white
                                          : Colors.black, // White if selected
                                    ),
                                  ),
                                  4: Text(
                                    'Year',
                                    style: TextStyle(
                                      fontFamily: "Mulish",
                                      color: _selectedIndex == 4
                                          ? Colors.white
                                          : Colors.black, // White if selected
                                    ),
                                  ),
                                  5: Text(
                                    'Custom',
                                    style: TextStyle(
                                      fontFamily: "Mulish",
                                      color: _selectedIndex == 5
                                          ? Colors.white
                                          : Colors.black, // White if selected
                                    ),
                                  ),
                                },
                                thumbColor: const Color(0xFF018786),
                                onValueChanged: _onToggleChanged,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildTabContent(),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabContent() {
    switch (_selectedIndex) {
      case 0:
        return Column(
          children: [
            StackedBreakdownDetails(),
            StackedColumnChart(),
            if (is_mttr == "yes" || is_down_time == "yes") _buildMttr(),
            StackedColumnChart1(),
          ],
        );
      case 1:
        return Column(
          children: [
            StackedBreakdownDetails(),
            StackedColumnChart(),
            if (is_mttr == "yes" || is_down_time == "yes") _buildMttr(),
            StackedColumnChart1(),
          ],
        );
      case 2:
        return Column(
          children: [
            StackedBreakdownDetails(),
            StackedColumnChart(),
            if (is_mttr == "yes" || is_down_time == "yes") _buildMttr(),
            StackedColumnChart1(),
          ],
        );
      case 3:
        return Column(
          children: [
            StackedBreakdownDetails(),
            StackedColumnChart(),
            if (is_mttr == "yes" || is_down_time == "yes") _buildMttr(),
            StackedColumnChart1(),
          ],
        );
      case 4:
        return Column(
          children: [
            StackedBreakdownDetails(),
            StackedColumnChart(),
            if (is_mttr == "yes" || is_down_time == "yes") _buildMttr(),
            StackedColumnChart1(),
          ],
        );
      case 5:
        return Column(
          children: [
            // HeightFull(),
            // From/To Date Picker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Palette.primary),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            _fromDate != null
                                ? '${DateFormat('dd-MM-yyyy').format(_fromDate!)}'
                                : '${DateFormat('dd-MM-yyyy').format(DateTime(DateTime.now().year, DateTime.now().month, 1))}',
                            style: const TextStyle(
                              fontFamily: "Mulish",
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              // backgroundColor:
                              //     Color.fromRGBO(30, 152, 165, 1)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24.0),
                  GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Palette.primary),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            _toDate != null
                                ? '${DateFormat('dd-MM-yyyy').format(_toDate!)}'
                                : '${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Mulish",
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            HeightFull(),

            StackedBreakdownDetails(),
            StackedColumnChart(),
            if (is_mttr == "yes" || is_down_time == "yes") _buildMttr(),
            StackedColumnChart1(),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMttr() {
    return Consumer<DashboardProvider>(
      builder: (context, value, child) {
        BreakdownCountReportLists countData =
            (value.breakdownTicketCountData?.breakdownReportLists?.isNotEmpty ??
                    false)
                ? value.breakdownTicketCountData!.breakdownReportLists![0]
                : BreakdownCountReportLists(); // Provide a default instance

        return Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: FadeInLeft(
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              "MTTR",
                              style: TextStyle(
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Color(0xFF018786),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${convertSecondsToHHMM(countData.mttr ?? 0.0).isEmpty ? "00:00" : convertSecondsToHHMM(countData.mttr ?? 0.0)}(hh:mm)",
                              style: const TextStyle(
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: FadeInRight(
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              "MTBF",
                              style: TextStyle(
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Color(0xFF018786),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${convertSecondsToHHMM(countData.mtbf ?? 0.0).isEmpty ? "00:00" : convertSecondsToHHMM(countData.mtbf ?? 0.0)}(hh:mm)",
                              style: const TextStyle(
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: FadeInLeft(
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              "Downtime Hours",
                              style: TextStyle(
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Color(0xFF018786),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              _convertToHHMMSS(
                                          countData.sumOfDowntime.toString())
                                      .isEmpty
                                  ? '00:00'
                                  : _convertToHHMMSS(
                                      countData.sumOfDowntime.toString()),
                              style: const TextStyle(
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Method to convert total seconds to HH:MM:SS format
  String _convertToHHMMSS(String downtime) {
    int totalSeconds = int.tryParse(downtime) ?? 0;

    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  String convertSecondsToHHMM(double seconds) {
    // Convert seconds to integer
    int totalSeconds = seconds.toInt();

    // Calculate hours and minutes
    int hours = totalSeconds ~/ 3600; // Integer division
    int minutes = (totalSeconds % 3600) ~/ 60;

    // Format as HH:mm
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverPersistentHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

// class Dashboard extends ConsumerStatefulWidget {
//   const Dashboard({super.key});

//   @override
//   ConsumerState<Dashboard> createState() => _DashboardScreenState();
// }

// String open_counts = '';
// String assign_counts = '';
// String progress_counts = '';
// String completed_counts = '';
// double mttr = 0.0;
// double mtbf = 0.0;
// String downtime = '';
// List<BreakdownReportLists> openList = [];
// List<CategoryBreakdownReportLists> categoryList = [];
// DateTime? _fromDate;
// DateTime? _toDate;

// class _DashboardScreenState extends ConsumerState<Dashboard> {
//   int _selectedIndex = 0; // Track the selected toggle button index
//   final bool _showTexts = true; // Track the visibility of the texts
//   String is_mttr = '';
//   String is_down_time = '';
//   final bool _isFirstLoad = true;
//   String _statusName = 'date';
//   String from = "";
//   String to = "";
//   final employeename = SharedUtil().getEmployeeName;
//   final token = SharedUtil().getToken;

//   void _onToggleChanged(int? index) {
//     if (index != null) {
//       setState(() {
//         _selectedIndex = index;

//         // Set the status name based on the selected index
//         switch (_selectedIndex) {
//           case 0:
//             _statusName = "date";
//             from = DateFormat('dd-MM-yyyy').format(DateTime.now());
//             to = "";
//             _fetchBreakdownTicketCounts();
//             DashboardRepository().openCompleted(context,
//                 from_date: from, to_date: to, status: _statusName);
//             DashboardRepository().categoryBased(context,
//                 from_date: from, to_date: to, status: _statusName);
//             break;
//           case 1:
//             _statusName = "date";
//             from = DateFormat('dd-MM-yyyy')
//                 .format(DateTime.now().subtract(const Duration(days: 1)));
//             to = "";
//             _fetchBreakdownTicketCounts();
//             DashboardRepository().openCompleted(context,
//                 from_date: from, to_date: to, status: _statusName);
//             DashboardRepository().categoryBased(context,
//                 from_date: from, to_date: to, status: _statusName);
//             break;
//           case 2:
//             _statusName = "from_to";
//             from = DateFormat('dd-MM-yyyy')
//                 .format(DateTime.now().subtract(const Duration(days: 7)));
//             to = DateFormat('dd-MM-yyyy').format(DateTime.now());
//             _fetchBreakdownTicketCounts();
//             DashboardRepository().openCompleted(context,
//                 from_date: from, to_date: to, status: _statusName);
//             DashboardRepository().categoryBased(context,
//                 from_date: from, to_date: to, status: _statusName);
//             break;
//           case 3:
//             _statusName = "from_to";
//             from = DateFormat('dd-MM-yyyy')
//                 .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
//             to = DateFormat('dd-MM-yyyy').format(DateTime.now());
//             _fetchBreakdownTicketCounts();
//             DashboardRepository().openCompleted(context,
//                 from_date: from, to_date: to, status: _statusName);
//             DashboardRepository().categoryBased(context,
//                 from_date: from, to_date: to, status: _statusName);
//             break;
//           case 4:
//             _statusName = "from_to";
//             from = DateFormat('dd-MM-yyyy')
//                 .format(DateTime(DateTime.now().year, 1, 1));
//             to = DateFormat('dd-MM-yyyy').format(DateTime.now());
//             _fetchBreakdownTicketCounts();
//             DashboardRepository().openCompleted(context,
//                 from_date: from, to_date: to, status: _statusName);
//             DashboardRepository().categoryBased(context,
//                 from_date: from, to_date: to, status: _statusName);
//             break;
//           case 5:
//             _statusName = "custom_date";
//             from = to.toString();
//             to = from.toString();
//             _fetchBreakdownTicketCounts();
//             DashboardRepository().openCompleted(context,
//                 from_date: from, to_date: to, status: _statusName);
//             DashboardRepository().categoryBased(context,
//                 from_date: from, to_date: to, status: _statusName);
//             break;
//           default:
//             _statusName = "date";
//         }
//       });
//       // Call API after the selection has changed
//       _fetchBreakdownTicketCounts();
//     }
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _fetchDepartmentListDirectly();
//       _fetchBreakdownTicketCounts();
//     });
//     checkConnection(context);
//     from = DateFormat('dd-MM-yyyy').format(DateTime.now());
//     to = "";
//     print('init status-> $employeename');
//     print('init from-> $from, to-> $to');
//     setState(() {});
//     super.initState();
//   }

//   // @override
//   // void didChangeDependencies() {
//   //   super.didChangeDependencies();

//   //   // if (_isFirstLoad) {
//   //   //   // Fetch the ticket counts after dependencies are loaded
//   //   //   from = DateFormat('dd-MM-yyyy').format(DateTime.now());
//   //   //   to = "";
//   //   //   _fetchDepartmentListDirectly();
//   //   //   _fetchBreakdownTicketCounts();
//   //   //   _isFirstLoad = false; // Ensure this is only called once
//   //   // }
//   //   if (_isFirstLoad) {
//   //     Future.delayed(Duration(seconds: 1), () {
//   //       from = DateFormat('dd-MM-yyyy').format(DateTime.now());
//   //       to = "";
//   //       _fetchDepartmentListDirectly();
//   //       _fetchBreakdownTicketCounts();
//   //       _isFirstLoad = false;
//   //     });
//   //   }
//   // }

//   Future<void> _selectDate(BuildContext context, bool isFromDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData(
//             useMaterial3: true,
//             colorScheme: ColorScheme.light(
//               primary: const Color.fromRGBO(
//                   21, 147, 159, 1), // Header background color
//               onPrimary: Colors.white, // Header text and selected text color
//               onSurface: Colors.black, // Default text color
//             ),
//             textTheme: TextTheme(
//               titleMedium: TextStyle(
//                 fontFamily: "Mulish",
//                 fontWeight: FontWeight.w500,
//                 fontStyle: FontStyle.normal,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != (isFromDate ? _fromDate : _toDate)) {
//       setState(() {
//         if (isFromDate) {
//           _fromDate = picked;
//           from = DateFormat('dd-MM-yyyy').format(picked);
//           print("From date selected: $from"); // Debug: Check date
//         } else {
//           _toDate = picked;
//           to = DateFormat('dd-MM-yyyy').format(picked);
//           print("To date selected: $to"); // Debug: Check date
//         }

//         // Ensure dates are valid before calling the API
//         if (from.isNotEmpty && to.isNotEmpty) {
//           print("Calling API with From: $from, To: $to");
//           _fetchBreakdownTicketCounts();
//         } else {
//           print("Dates are not valid: From=$from, To=$to");
//         }
//       });
//     } else {
//       print("Date not picked or the same as existing");
//     }
//   }

//   Future<void> _fetchDepartmentListDirectly() async {
//     try {
//       DashboardRepository().departmentLists(context).then((value) async {
//         if (dashboardProvider.departmentListData?.departmentLists != null &&
//             dashboardProvider.departmentListData!.departmentLists!.isNotEmpty) {
//           var countData =
//               dashboardProvider.departmentListData!.departmentLists![0];

//           // Log the retrieved values for debugging
//           logger.i('is_mttr: ${countData.isMttr}');
//           print('is_downtime: ${countData.isDowntime}');
//           print('is_multiple: ${countData.isMultiple}');
//           is_mttr = countData.isMttr.toString();
//           is_down_time = countData.isDowntime.toString();
//           // Save values to SharedPreferences
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           prefs.setString('is_mttr', countData.isMttr!);
//           prefs.setString('is_downtime', countData.isDowntime!);
//           prefs.setString('is_multiple', countData.isMultiple!);

//           print('Saved data to SharedPreferences');
//         }
//       });
//     } catch (e) {
//       // Handle error
//       print("Error fetching data: $e");
//     }
//   }

//   Future<void> _fetchBreakdownTicketCounts() async {
//     try {
//       DashboardRepository()
//           .dashboardTicketCounts(context,
//               from_date: from.toString(),
//               to_date: to.toString(),
//               status: _statusName)
//           .then((value) {
//         logger.w(dashboardProvider.breakdownTicketCountData?.toJson());
//         if (dashboardProvider.breakdownTicketCountData?.breakdownReportLists !=
//                 null &&
//             dashboardProvider
//                 .breakdownTicketCountData!.breakdownReportLists!.isNotEmpty) {
//           var countData = dashboardProvider
//               .breakdownTicketCountData!.breakdownReportLists![0];
//           // Update the state variables and UI
//           setState(() {
//             open_counts = countData.open.toString();
//             assign_counts = countData.assign.toString();
//             progress_counts = countData.inProgressTickets.toString();
//             completed_counts = countData.completed.toString();
//             mttr = countData.mttr!;
//             mtbf = countData.mtbf!;
//             downtime = countData.sumOfDowntime.toString();
//           });
//         }
//       });
//       // Log the API response
//     } catch (e) {
//       // Handle error
//       print("Error fetching data: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: CommonAppBar(
//           title: "DashBoard",
//           action: IconButton(
//             icon: const Icon(Icons.notifications_active_outlined),
//             color: Colors.white,
//             onPressed: () => {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => NotificationScreen()))
//             },
//           ),
//           leading: IconButton(
//             icon: const Icon(Icons.power_settings_new),
//             color: Colors.white,
//             onPressed: () => commonDialog(context, LogoutDialog()),
//           ),
//         ),
//         backgroundColor: const Color(0xF5F5F5F5),
//         body: CustomScrollView(
//           slivers: [
//             SliverPersistentHeader(
//               pinned: true,
//               delegate: _SliverPersistentHeaderDelegate(
//                 minHeight: 50.0,
//                 maxHeight: 70.0,
//                 child: Container(
//                   width: double.infinity,
//                   color: const Color(0xF5F5F5F5),
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Add welcome message here (if needed)
//                       // Padding(
//                       //   padding: const EdgeInsets.symmetric(vertical: 10.0),
//                       //   child: Column(
//                       //     crossAxisAlignment: CrossAxisAlignment.start,
//                       //     children: [
//                       //       Text(
//                       //         'Hello, ${employeename}', // Display employee name
//                       //         style: TextStyle(fontFamily: "Mulish",
//                       //           fontSize: 20,
//                       //           fontWeight: FontWeight.bold,
//                       //         ),
//                       //       ),
//                       //       Text(
//                       //         'Welcome to FixitNow',
//                       //         style: TextStyle(fontFamily: "Mulish",
//                       //           fontSize: 16,
//                       //           fontWeight: FontWeight.bold,
//                       //           color: Colors.grey,
//                       //         ),
//                       //       ),
//                       //     ],
//                       //   ),
//                       // ),
//                       Expanded(
//                         child: CupertinoSlidingSegmentedControl<int>(
//                           padding: EdgeInsets.all(8),
//                           proportionalWidth: true,
//                           groupValue: _selectedIndex,
//                           children: {
//                             0: Text(
//                               'Today',
//                               style: TextStyle(
//                                 fontFamily: "Mulish",
//                                 color: _selectedIndex == 0
//                                     ? Colors.white
//                                     : Colors.black, // White if selected
//                               ),
//                             ),
//                             1: Text(
//                               'Previous Day',
//                               style: TextStyle(
//                                 fontFamily: "Mulish",
//                                 color: _selectedIndex == 1
//                                     ? Colors.white
//                                     : Colors.black, // White if selected
//                               ),
//                             ),
//                             2: Text(
//                               'Week',
//                               style: TextStyle(
//                                 fontFamily: "Mulish",
//                                 color: _selectedIndex == 2
//                                     ? Colors.white
//                                     : Colors.black, // White if selected
//                               ),
//                             ),
//                             3: Text(
//                               'Month',
//                               style: TextStyle(
//                                 fontFamily: "Mulish",
//                                 color: _selectedIndex == 3
//                                     ? Colors.white
//                                     : Colors.black, // White if selected
//                               ),
//                             ),
//                             4: Text(
//                               'Year',
//                               style: TextStyle(
//                                 fontFamily: "Mulish",
//                                 color: _selectedIndex == 4
//                                     ? Colors.white
//                                     : Colors.black, // White if selected
//                               ),
//                             ),
//                             5: Text(
//                               'Custom',
//                               style: TextStyle(
//                                 fontFamily: "Mulish",
//                                 color: _selectedIndex == 5
//                                     ? Colors.white
//                                     : Colors.black, // White if selected
//                               ),
//                             ),
//                           },
//                           thumbColor: const Color(0xFF018786),
//                           onValueChanged: _onToggleChanged,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SliverList(
//               delegate: SliverChildListDelegate([
//                 const SizedBox(height: 5),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: _buildTabContent(),
//                 ),
//               ]),
//             ),
//           ],
//         ));
//   }

//   Widget _buildTabContent() {
//     switch (_selectedIndex) {
//       case 0:
//         return Column(
//           children: [
//             _buildStackedBreakdown(),
//             _buildStackedColumnChart(),
//             if (is_mttr == "yes" || is_down_time == "yes") _buildMttr(),
//             _buildStackedColumnChart1()
//           ],
//         );
//       case 1:
//         return Column(
//           children: [
//             _buildStackedBreakdown(),
//             _buildStackedColumnChart(),
//             if (is_mttr == "yes" || is_down_time == "yes") _buildMttr(),
//             _buildStackedColumnChart1(),
//           ],
//         );
//       case 2:
//         return Column(
//           children: [
//             _buildStackedBreakdown(),
//             _buildStackedColumnChart(),
//             if (is_mttr == "yes" || is_down_time == "yes") _buildMttr(),
//             _buildStackedColumnChart1(),
//           ],
//         );
//       case 3:
//         return Column(
//           children: [
//             _buildStackedBreakdown(),
//             _buildStackedColumnChart(),
//             if (is_mttr == "yes" || is_down_time == "yes") _buildMttr(),
//             _buildStackedColumnChart1(),
//           ],
//         );
//       case 4:
//         return Column(
//           children: [
//             _buildStackedBreakdown(),
//             _buildStackedColumnChart(),
//             if (is_mttr == "yes" || is_down_time == "yes") _buildMttr(),
//             _buildStackedColumnChart1(),
//           ],
//         );
//       case 5:
//         return Column(
//           children: [
//             // HeightFull(),
//             // From/To Date Picker
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () => _selectDate(context, true),
//                     child: Container(
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Palette.primary),
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.calendar_today,
//                             color: Colors.white,
//                             size: 22,
//                           ),
//                           const SizedBox(width: 12.0),
//                           Text(
//                             _fromDate != null
//                                 ? '${DateFormat('dd-MM-yyyy').format(_fromDate!)}'
//                                 : 'Select From Date',
//                             style: const TextStyle(
//                               fontFamily: "Mulish",
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                               // backgroundColor:
//                               //     Color.fromRGBO(30, 152, 165, 1)
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 24.0),
//                   GestureDetector(
//                     onTap: () => _selectDate(context, false),
//                     child: Container(
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Palette.primary),
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.calendar_today,
//                             size: 22,
//                             color: Colors.white,
//                           ),
//                           const SizedBox(width: 12.0),
//                           Text(
//                             _toDate != null
//                                 ? '${DateFormat('dd-MM-yyyy').format(_toDate!)}'
//                                 : 'Select To Date',
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontFamily: "Mulish",
//                                 fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             HeightFull(),

//             _buildStackedBreakdown(),
//             _buildStackedColumnChart(),
//             if (is_mttr == "yes" || is_down_time == "yes") _buildMttr(),
//             _buildStackedColumnChart1(),
//           ],
//         );
//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   Widget _buildStackedBreakdown() {
//     return Container(
//       color: const Color(0xF5F5F5F5),
//       child: Column(
//         children: [
//           const Text(
//             "Breakdown",
//             style: TextStyle(
//                 fontFamily: "Mulish",
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//                 color: Color(0xFF018786)),
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(0.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Expanded(
//                   child: Card(
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Open",
//                             style: TextStyle(
//                               fontFamily: "Mulish",
//                               fontWeight: FontWeight.w500,
//                               fontSize: 15,
//                               color: Color(0xFF018786),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           open_counts.isEmpty ? '0' : open_counts,
//                           style: const TextStyle(
//                             fontFamily: "Mulish",
//                             fontWeight: FontWeight.w400,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // SizedBox(width: 8),
//                 Expanded(
//                   child: Card(
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Assign",
//                             style: TextStyle(
//                               fontFamily: "Mulish",
//                               fontWeight: FontWeight.w500,
//                               fontSize: 15,
//                               color: Color(0xFF018786),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           assign_counts.isEmpty ? '0' : assign_counts,
//                           style: const TextStyle(
//                             fontFamily: "Mulish",
//                             fontWeight: FontWeight.w400,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // SizedBox(width: 8),
//                 Expanded(
//                   child: Card(
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Progress",
//                             style: TextStyle(
//                               fontFamily: "Mulish",
//                               fontWeight: FontWeight.w500,
//                               fontSize: 15,
//                               color: Color(0xFF018786),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           progress_counts.isEmpty ? '0' : progress_counts,
//                           style: const TextStyle(
//                             fontFamily: "Mulish",
//                             fontWeight: FontWeight.w400,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // SizedBox(width: 8),
//                 Expanded(
//                   child: Card(
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Fixed",
//                             style: TextStyle(
//                               fontFamily: "Mulish",
//                               fontWeight: FontWeight.w500,
//                               fontSize: 15,
//                               color: Color(0xFF018786),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           completed_counts.isEmpty ? '0' : completed_counts,
//                           style: const TextStyle(
//                             fontFamily: "Mulish",
//                             fontWeight: FontWeight.w400,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMttr() {
//     return Column(
//       children: [
//         Row(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Expanded(
//               child: Card(
//                 color: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       const Text(
//                         "MTTR",
//                         style: TextStyle(
//                           fontFamily: "Mulish",
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                           color: Color(0xFF018786),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         "${convertToHHMM(mttr).isEmpty ? "00:00" : convertToHHMM(mttr)}(hh:mm)",
//                         style: const TextStyle(
//                           fontFamily: "Mulish",
//                           fontWeight: FontWeight.w400,
//                           fontSize: 15,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Row(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Expanded(
//               child: Card(
//                 color: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       const Text(
//                         "MTBF",
//                         style: TextStyle(
//                           fontFamily: "Mulish",
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                           color: Color(0xFF018786),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         "${convertToHHMM(mtbf).isEmpty ? "00:00" : convertToHHMM(mtbf)}(hh:mm)",
//                         style: const TextStyle(
//                           fontFamily: "Mulish",
//                           fontWeight: FontWeight.w400,
//                           fontSize: 15,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Row(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Expanded(
//               child: Card(
//                 color: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       const Text(
//                         "Downtime Hours",
//                         style: TextStyle(
//                           fontFamily: "Mulish",
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                           color: Color(0xFF018786),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         _convertToHHMMSS(downtime).isEmpty
//                             ? '00:00'
//                             : _convertToHHMMSS(downtime),
//                         style: const TextStyle(
//                           fontFamily: "Mulish",
//                           fontWeight: FontWeight.w400,
//                           fontSize: 15,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildStackedColumnChart() {
//     return Card(
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: FutureBuilder(
//           future: ref
//               .watch(apiServiceProvider)
//               .OpenCompleted(from_date: from, to_date: to, status: _statusName),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(child: Text(snapshot.error.toString()));
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: ShimmerCard());
//             }

//             if (snapshot.data == null ||
//                 snapshot.data!.breakdownReportLists == null ||
//                 snapshot.data!.breakdownReportLists!.isEmpty) {
//               return Center(
//                 child: NoDataScreen(),
//               );
//             }

//             openList = snapshot.data!.breakdownReportLists!;

//             // Create grouped chartData for both 'Open' and 'Fixed'
//             List<OpenChartData> chartData = openList.map((item) {
//               return OpenChartData(
//                 x: item.date!, // Assuming 'category' is the shared x-axis label
//                 y1: item.open!, // Open data
//                 y2: item.fixed!, // Fixed data
//               );
//             }).toList();

//             return Center(
//               child: SfCartesianChart(
//                 title: ChartTitle(
//                   text: 'Open vs Fixed',
//                   textStyle: const TextStyle(
//                     fontFamily: "Mulish",
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF018786),
//                   ),
//                   alignment: ChartAlignment.near,
//                 ),
//                 primaryXAxis: CategoryAxis(
//                   labelStyle: const TextStyle(
//                     fontFamily: "Mulish",
//                     color: Colors.grey,
//                     fontWeight: FontWeight.normal,
//                     fontSize: 10,
//                   ),
//                   labelRotation: 30,
//                   edgeLabelPlacement: EdgeLabelPlacement.shift,
//                   majorGridLines: const MajorGridLines(width: 0.2),
//                   labelAlignment: LabelAlignment.start,
//                 ),
//                 primaryYAxis: NumericAxis(
//                   labelStyle: const TextStyle(
//                     fontFamily: "Mulish",
//                     fontSize: 12,
//                   ),
//                   majorGridLines: const MajorGridLines(width: 0.5),
//                 ),
//                 series: <CartesianSeries>[
//                   // Open bars
//                   ColumnSeries<OpenChartData, String>(
//                     dataSource: chartData,
//                     xValueMapper: (OpenChartData ch, _) => ch.x,
//                     yValueMapper: (OpenChartData ch, _) => ch.y1,
//                     name: 'Open',
//                     color: Colors.blue,
//                     width: 0.4,
//                     spacing: 0.2,
//                     // Enabling data labels to show counts
//                     dataLabelSettings: const DataLabelSettings(
//                       isVisible: true, // Show data labels
//                       textStyle: TextStyle(
//                         fontFamily: "Mulish",
//                         fontSize: 10, // Size of the data label text
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black, // Data label color
//                       ),
//                     ),
//                   ),
//                   // Fixed bars
//                   ColumnSeries<OpenChartData, String>(
//                     dataSource: chartData,
//                     xValueMapper: (OpenChartData ch, _) => ch.x,
//                     yValueMapper: (OpenChartData ch, _) => ch.y2,
//                     name: 'Fixed',
//                     color: Colors.green,
//                     width: 0.4,
//                     spacing: 0.2,
//                     // Enabling data labels to show counts
//                     dataLabelSettings: const DataLabelSettings(
//                       isVisible: true, // Show data labels
//                       textStyle: TextStyle(
//                         fontFamily: "Mulish",
//                         fontSize: 10, // Size of the data label text
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black, // Data label color
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildStackedColumnChart1() {
//     return Card(
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: FutureBuilder(
//           future: ref.watch(apiServiceProvider).CategoryBased(
//               from_date: from.toString(),
//               to_date: to.toString(),
//               status: _statusName),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(child: Text(snapshot.error.toString()));
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: ShimmerCard());
//             }

//             if (snapshot.data == null ||
//                 snapshot.data!.breakdownReportLists == null ||
//                 snapshot.data!.breakdownReportLists!.isEmpty) {
//               return Center(
//                 child: NoDataScreen(),
//               );
//             }

//             categoryList = snapshot.data!.breakdownReportLists!;

//             // Create grouped chartData for both 'Open' and 'Fixed'
//             List<OpenChartData> chartData = openList.map((item) {
//               return OpenChartData(
//                 x: item
//                     .breakdownCategoryName!, // Assuming 'category' is the shared x-axis label
//                 y1: item.ticketCount!, // Open data
//                 y2: item.sumOfDowntime!, // Fixed data
//               );
//             }).toList();

//             return Center(
//               child: SfCartesianChart(
//                 title: ChartTitle(
//                   text: 'Category Based Breakdown',
//                   textStyle: const TextStyle(
//                     fontFamily: "Mulish",
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF018786),
//                   ),
//                   alignment: ChartAlignment.near,
//                 ),
//                 primaryXAxis: CategoryAxis(
//                   // Enhancing X-Axis clarity
//                   labelStyle: const TextStyle(
//                     fontFamily: "Mulish",
//                     color: Colors.grey, // Make the label text color clear
//                     fontWeight: FontWeight.normal,
//                     fontSize: 8, // Set the size to make labels readable
//                   ),
//                   labelRotation:
//                       45, // Rotate labels by 45 degrees to avoid overlapping
//                   edgeLabelPlacement:
//                       EdgeLabelPlacement.shift, // Adjust edge labels
//                   majorGridLines: const MajorGridLines(
//                       width: 0), // Remove x-axis grid lines for clarity
//                   labelAlignment: LabelAlignment
//                       .start, // Align labels for better visibility
//                 ),
//                 primaryYAxis: NumericAxis(
//                   labelStyle: const TextStyle(
//                     fontFamily: "Mulish",
//                     fontSize: 12,
//                   ),
//                   majorGridLines: const MajorGridLines(
//                       width: 0.5), // Y-axis grid line adjustment
//                 ),
//                 series: <CartesianSeries>[
//                   // Open bars
//                   ColumnSeries<OpenChartData, String>(
//                     dataSource: chartData,
//                     xValueMapper: (OpenChartData ch, _) => ch.x,
//                     yValueMapper: (OpenChartData ch, _) => ch.y1,

//                     name: 'Open', // Group label for 'Open'
//                     color: Colors.red,
//                     onPointTap: (ChartPointDetails details) {
//                       // Show ticket count and downtime on bar tap
//                       final String categoryName =
//                           chartData[details.pointIndex!].x;
//                       final int ticketCount = chartData[details.pointIndex!].y1;
//                       final int downtime = chartData[details.pointIndex!].y2;

//                       // Show dialog or Snackbar with the ticket count and downtime
//                       showDialog(
//                         context: context,
//                         builder: (_) => AlertDialog(
//                           title: Text('Details for $categoryName'),
//                           content: Text(
//                               'No.of Tickets : $ticketCount\nDuration : ${_convertToHHMMSS(downtime.toString())}'),
//                           backgroundColor: Colors.white,
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: const Text('OK'),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // Method to convert total seconds to HH:MM:SS format
//   String _convertToHHMMSS(String downtime) {
//     int totalSeconds = int.tryParse(downtime) ?? 0;

//     int hours = totalSeconds ~/ 3600;
//     int minutes = (totalSeconds % 3600) ~/ 60;

//     String formattedTime =
//         '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

//     return formattedTime;
//   }

//   String convertToHHMM(double valueInMinutes) {
//     int hours = valueInMinutes ~/ 60;
//     int minutes = (valueInMinutes % 60).toInt();
//     return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
//   }
// }
