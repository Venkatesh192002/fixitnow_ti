// ignore_for_file: unused_field, unused_local_variable

import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/model/DepartmentListsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardBreakdown extends ConsumerStatefulWidget {
  const DashboardBreakdown({super.key});

  @override
  ConsumerState<DashboardBreakdown> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardBreakdown> {
  final List<ChartData> chartData = [
    ChartData('Monday', 20, 30, 40, 50),
    ChartData('Tuesday', 53, 43, 22, 22),
    ChartData('Wednesday', 75, 63, 22, 32),
    ChartData('Thursday', 10, 67, 92, 34),
  ];

  final List<PieData> pieData = [
    PieData('Category A', 35, Colors.blue, 'Blue'),
    PieData('Category B', 25, Colors.green, 'Green'),
    PieData('Category C', 15, Colors.orange, 'Orange'),
    PieData('Category D', 25, Colors.red, 'Red'),
  ];

  int _selectedIndex = 0; // Track the selected toggle button index
  bool _showTexts = true; // Track the visibility of the texts
  List<DepartmentLists>? departmentLists;
  final bool _isFirstLoad = true;
  final ScrollController _scrollController = ScrollController();

  void _onToggleChanged(int? index) {
    if (index != null) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnection(context);
    // _fetchDepartmentListDirectly();
    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && _showTexts) {
        setState(() {
          _showTexts = false;
        });
      } else if (_scrollController.offset <= 100 && !_showTexts) {
        setState(() {
          _showTexts = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if (_isFirstLoad) {
    //   // Fetch the ticket counts after dependencies are loaded
    //   _fetchDepartmentListDirectly();
    //   _isFirstLoad = false; // Ensure this is only called once
    // }
  }

  @override
  Widget build(BuildContext context) {
    final response = ref.read(apiServiceProvider).DepartmentLists();
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Breakdown Dashboard',
            style: TextStyle(fontFamily: "Mulish", color: Colors.white),
          ),
          backgroundColor: Color.fromRGBO(30, 152, 165, 1),
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        backgroundColor: const Color(0xF5F5F5F5),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverPersistentHeaderDelegate(
                minHeight: 50.0,
                maxHeight: 70.0,
                child: Container(
                  color: const Color(0xF5F5F5F5),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CupertinoSlidingSegmentedControl(
                          groupValue: _selectedIndex,
                          children: {
                            0: Text(
                              'Today',
                              style: TextStyle(
                                fontFamily: "Mulish",
                                color: _selectedIndex == 0
                                    ? Colors.white
                                    : null, // Set text color to white if selected
                              ),
                            ),
                            1: Text(
                              'Week',
                              style: TextStyle(
                                fontFamily: "Mulish",
                                color: _selectedIndex == 1
                                    ? Colors.white
                                    : null, // Set text color to white if selected
                              ),
                            ),
                            2: Text(
                              'Month',
                              style: TextStyle(
                                fontFamily: "Mulish",
                                color: _selectedIndex == 2
                                    ? Colors.white
                                    : null, // Set text color to white if selected
                              ),
                            ),
                            3: Text(
                              'Year',
                              style: TextStyle(
                                fontFamily: "Mulish",
                                color: _selectedIndex == 3
                                    ? Colors.white
                                    : null, // Set text color to white if selected
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
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 5),
                  _buildTabContent(),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildTabContent() {
    switch (_selectedIndex) {
      case 0:
        return Column(
          children: [
            _buildStackedBreakdown(),
            _buildStackedColumnChart(),
            _buildMttr(),
            _buildStackedColumnChart1(),
            _buildPieChart(),
            _buildLineChart(),
          ],
        );
      case 1:
        return Column(
          children: [
            _buildStackedColumnChart(),
            _buildMttr(),
            _buildStackedColumnChart1(),
            _buildPieChart(),
            _buildLineChart(),
          ],
        );
      case 2:
        return Column(
          children: [
            _buildStackedColumnChart(),
            _buildMttr(),
            _buildStackedColumnChart1(),
            _buildPieChart(),
            _buildLineChart(),
          ],
        );
      case 3:
        return Column(
          children: [
            _buildStackedColumnChart(),
            _buildMttr(),
            _buildStackedColumnChart1(),
            _buildPieChart(),
            _buildLineChart(),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStackedBreakdown() {
    return Container(
      color: const Color(0xF5F5F5F5),
      child: const Column(
        children: [
          Text(
            "Breakdown",
            style: TextStyle(
                fontFamily: "Mulish",
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF018786)),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Open",
                            style: TextStyle(
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xFF018786),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "10",
                          style: TextStyle(
                            fontFamily: "Mulish",
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(width: 8),
                Expanded(
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Assign",
                            style: TextStyle(
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xFF018786),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "10",
                          style: TextStyle(
                            fontFamily: "Mulish",
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(width: 8),
                Expanded(
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Progress",
                            style: TextStyle(
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xFF018786),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "10",
                          style: TextStyle(
                            fontFamily: "Mulish",
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(width: 8),
                Expanded(
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Completed",
                            style: TextStyle(
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xFF018786),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "10",
                          style: TextStyle(
                            fontFamily: "Mulish",
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMttr() {
    return const Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "MTTR",
                        style: TextStyle(
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xFF018786),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "01:10:54 (hh:mm:ss)",
                        style: TextStyle(
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
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "MTBF",
                        style: TextStyle(
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xFF018786),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "01:10:54 (hh:mm:ss)",
                        style: TextStyle(
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
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Downtime Hours",
                        style: TextStyle(
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xFF018786),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "01:10:54",
                        style: TextStyle(
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
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Average Response Time",
                        style: TextStyle(
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xFF018786),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "01:10:54",
                        style: TextStyle(
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
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Average Resolve Time",
                        style: TextStyle(
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xFF018786),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "01:10:54",
                        style: TextStyle(
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
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Performance Rate",
                        style: TextStyle(
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xFF018786),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "01:10:54",
                        style: TextStyle(
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
          ],
        ),
      ],
    );
  }

  Widget _buildStackedColumnChart() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            child: SfCartesianChart(
              title: ChartTitle(
                text: 'Breakdown', // Set your side heading text here
                textStyle: const TextStyle(
                    fontFamily: "Mulish",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF018786)),
                alignment: ChartAlignment.near, // Align the title to the side
              ),
              primaryXAxis: CategoryAxis(),
              series: <CartesianSeries>[
                StackedColumnSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData ch, _) => ch.x,
                  yValueMapper: (ChartData ch, _) => ch.y1,
                ),
                StackedColumnSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData ch, _) => ch.x,
                  yValueMapper: (ChartData ch, _) => ch.y2,
                ),
                StackedColumnSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData ch, _) => ch.x,
                  yValueMapper: (ChartData ch, _) => ch.y3,
                ),
                StackedColumnSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData ch, _) => ch.x,
                  yValueMapper: (ChartData ch, _) => ch.y4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStackedColumnChart1() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            child: SfCartesianChart(
              title: ChartTitle(
                text: 'Asset Based Breakdown',
                // Set your side heading text here
                textStyle: const TextStyle(
                    fontFamily: "Mulish",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF018786)),
                alignment: ChartAlignment.near, // Align the title to the side
              ),
              primaryXAxis: CategoryAxis(),
              series: <CartesianSeries>[
                StackedColumnSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData ch, _) => ch.x,
                  yValueMapper: (ChartData ch, _) => ch.y1,
                ),
                StackedColumnSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData ch, _) => ch.x,
                  yValueMapper: (ChartData ch, _) => ch.y2,
                ),
                StackedColumnSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData ch, _) => ch.x,
                  yValueMapper: (ChartData ch, _) => ch.y3,
                ),
                StackedColumnSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData ch, _) => ch.x,
                  yValueMapper: (ChartData ch, _) => ch.y4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            child: SfCartesianChart(
              title: ChartTitle(
                text: 'Spare Consumption', // Set your side heading text here
                textStyle: const TextStyle(
                    fontFamily: "Mulish",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF018786)),
                alignment: ChartAlignment.near, // Align the title to the side
              ),
              primaryXAxis: CategoryAxis(),
              series: <CartesianSeries>[
                LineSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData ch, _) => ch.x,
                  yValueMapper: (ChartData ch, _) => ch.y1,
                ),
                LineSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData ch, _) => ch.x,
                  yValueMapper: (ChartData ch, _) => ch.y2,
                ),
                LineSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData ch, _) => ch.x,
                  yValueMapper: (ChartData ch, _) => ch.y3,
                ),
                LineSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData ch, _) => ch.x,
                  yValueMapper: (ChartData ch, _) => ch.y4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox(
            height: 300, // Specify a height for better layout control
            child: SfCircularChart(
              title: ChartTitle(
                text: 'Repeated Breakdown',
                textStyle: const TextStyle(
                    fontFamily: "Mulish",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF018786)),
                alignment: ChartAlignment.near, // Align the title to the side
              ),
              series: <CircularSeries>[
                PieSeries<PieData, String>(
                  dataSource: pieData,
                  pointColorMapper: (PieData data, _) => data.color,
                  xValueMapper: (PieData data, _) => data.category,
                  yValueMapper: (PieData data, _) => data.value,
                  dataLabelMapper: (PieData data, _) =>
                      '${data.category}\n${data.colorName}',
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(
                      fontFamily: "Mulish",
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    labelPosition: ChartDataLabelPosition.inside,
                    useSeriesColor: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

class ChartData {
  final String x;
  final int y1;
  final int y2;
  final int y3;
  final int y4;

  ChartData(this.x, this.y1, this.y2, this.y3, this.y4);
}

class PieData {
  PieData(this.category, this.value, this.color, this.colorName);

  final String category;
  final double value;
  final Color color;
  final String colorName;
}
