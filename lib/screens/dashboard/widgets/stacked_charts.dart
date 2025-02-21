import 'package:animate_do/animate_do.dart';
import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/model/CategoryBasedModel.dart';
import 'package:auscurator/model/OpenCompletedModel.dart';
import 'package:auscurator/provider/dashboard_provider.dart';
import 'package:auscurator/widgets/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StackedColumnChart extends StatefulWidget {
  const StackedColumnChart({super.key});

  @override
  State<StackedColumnChart> createState() => _StackedColumnChartState();
}

class _StackedColumnChartState extends State<StackedColumnChart> {
  List<BreakdownReportLists> openList = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dash, _) {
        openList = dash.openCompleteData?.breakdownReportLists ?? [];

        List<OpenChartData> chartData = openList.map((item) {
          return OpenChartData(
            x: item.date!,
            y1: item.open!,
            y2: item.fixed!,
          );
        }).toList();

        return dash.isLoading
            ? Center(child: ShimmerCard())
            : Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: openList.isEmpty
                      ? Center(
                          child: NoDataScreen(),
                        )
                      : SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal, // Enable horizontal scroll
                          child: FadeInRight(
                            child: Container(
                              width: chartData.length < 20
                                  ? context.widthFull()
                                  : chartData.length * 100,
                              padding: const EdgeInsets.all(16),
                              child: SfCartesianChart(
                                title: ChartTitle(
                                  text: 'Open vs Fixed',
                                  textStyle: const TextStyle(
                                    fontFamily: "Mulish",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF018786),
                                  ),
                                  alignment: ChartAlignment.near,
                                ),
                                legend: Legend(
                                  isVisible: true, // Make legend visible
                                  position: LegendPosition
                                      .bottom, // Position legend at the bottom
                                  textStyle: const TextStyle(
                                    fontFamily: "Mulish",
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                primaryXAxis: CategoryAxis(
                                  labelStyle: const TextStyle(
                                    fontFamily: "Mulish",
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10,
                                  ),
                                  labelRotation:
                                      45, // Rotate labels to avoid overlap
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                ),
                                primaryYAxis: NumericAxis(
                                  labelStyle: const TextStyle(
                                    fontFamily: "Mulish",
                                    fontSize: 12,
                                  ),
                                  majorGridLines:
                                      const MajorGridLines(width: 0.5),
                                ),
                                series: <CartesianSeries>[
                                  // Open bars
                                  ColumnSeries<OpenChartData, String>(
                                    dataSource: chartData,
                                    xValueMapper: (OpenChartData ch, _) => ch.x,
                                    yValueMapper: (OpenChartData ch, _) =>
                                        ch.y1,
                                    name: 'Open', // Group label for 'Open'
                                    color: Colors.blue,
                                    width: 0.4, // Column width
                                    spacing: 0.2, // Space between columns
                                    dataLabelSettings: const DataLabelSettings(
                                      isVisible: true, // Show data labels
                                      textStyle: TextStyle(
                                        fontFamily: "Mulish",
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  // Fixed bars
                                  ColumnSeries<OpenChartData, String>(
                                    dataSource: chartData,
                                    xValueMapper: (OpenChartData ch, _) => ch.x,
                                    yValueMapper: (OpenChartData ch, _) =>
                                        ch.y2,
                                    name: 'Fixed', // Group label for 'Fixed'
                                    color: Colors.green,
                                    width: 0.4, // Column width
                                    spacing: 0.2, // Space between columns
                                    dataLabelSettings: const DataLabelSettings(
                                      isVisible: true, // Show data labels
                                      textStyle: TextStyle(
                                        fontFamily: "Mulish",
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              );
      },
    );
  }
}

class StackedColumnChart1 extends StatefulWidget {
  const StackedColumnChart1({super.key});

  @override
  State<StackedColumnChart1> createState() => _StackedColumnChart1State();
}

class _StackedColumnChart1State extends State<StackedColumnChart1> {
  List<CategoryBreakdownReportLists> categoryList = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dash, _) {
        categoryList = dash.categoryBasedData?.breakdownReportLists ?? [];

        // Create grouped chartData for both 'Open' and 'Fixed'
        List<OpenChartData> chartData = categoryList.map((item) {
          return OpenChartData(
            x: item.breakdownCategoryName!,
            y1: item.ticketCount!,
            y2: item.sumOfDowntime!,
          );
        }).toList();

        return dash.isLoading
            ? Center(child: ShimmerCard())
            : FadeInLeft(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: categoryList.isEmpty
                          ? Center(child: NoDataScreen())
                          : SfCartesianChart(
                              title: ChartTitle(
                                text: 'Category Based Breakdown',
                                textStyle: const TextStyle(
                                  fontFamily: "Mulish",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF018786),
                                ),
                                alignment: ChartAlignment.near,
                              ),
                              legend: Legend(
                                isVisible: true,
                                position: LegendPosition.bottom,
                                overflowMode: LegendItemOverflowMode.wrap,
                                textStyle: const TextStyle(
                                  fontFamily: "Mulish",
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                                header: '',
                                canShowMarker: false,
                                textStyle: const TextStyle(
                                  fontFamily: "Mulish",
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                                color: const Color(0xFF0288D1),
                              ),
                              primaryXAxis: CategoryAxis(
                                labelStyle: const TextStyle(
                                  fontFamily: "Mulish",
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10,
                                ),
                                labelRotation:
                                    45, // Rotate labels to avoid overlap
                                majorGridLines: const MajorGridLines(width: 0),
                              ),
                              primaryYAxis: NumericAxis(
                                labelStyle: const TextStyle(
                                  fontFamily: "Mulish",
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                axisLine: const AxisLine(width: 0),
                                majorGridLines:
                                    const MajorGridLines(width: 0.5),
                                title: AxisTitle(
                                  text: 'Counts / Downtime',
                                  textStyle: const TextStyle(
                                    fontFamily: "Mulish",
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              series: <CartesianSeries>[
                                ColumnSeries<OpenChartData, String>(
                                  dataSource: chartData,
                                  width: 0.6, // Column width

                                  xValueMapper: (OpenChartData ch, _) => ch.x,
                                  yValueMapper: (OpenChartData ch, _) => ch.y1,
                                  name: 'Open',
                                  color: Colors.red,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    textStyle: TextStyle(
                                      fontFamily: "Mulish",
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPointTap: (ChartPointDetails details) {
                                    final String categoryName =
                                        chartData[details.pointIndex!].x;
                                    final int ticketCount =
                                        chartData[details.pointIndex!].y1;
                                    final int downtime =
                                        chartData[details.pointIndex!].y2;

                                    // Show dialog with the details
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title:
                                            Text('Details for $categoryName'),
                                        content: Text(
                                            'No.of Tickets: $ticketCount\nDuration: ${_convertToHHMMSS(downtime.toString())}'),
                                        backgroundColor: Colors.white,
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  String _convertToHHMMSS(String downtime) {
    int totalSeconds = int.tryParse(downtime) ?? 0;

    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String convertToHHMM(double valueInMinutes) {
    int hours = valueInMinutes ~/ 60;
    int minutes = (valueInMinutes % 60).toInt();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}

class OpenChartData {
  final String x;
  final int y1; // Open values
  final int y2; // Fixed values

  OpenChartData({required this.x, required this.y1, required this.y2});
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


// class StackedColumnChart extends StatefulWidget {
//   const StackedColumnChart({super.key});

//   @override
//   State<StackedColumnChart> createState() => _StackedColumnChartState();
// }

// class _StackedColumnChartState extends State<StackedColumnChart> {
//   List<BreakdownReportLists> openList = [];

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<DashboardProvider>(
//       builder: (context, dash, _) {
//         openList = dash.openCompleteData?.breakdownReportLists ?? [];

//         List<OpenChartData> chartData = openList.map((item) {
//           return OpenChartData(
//             x: item.date!,
//             y1: item.open!,
//             y2: item.fixed!,
//           );
//         }).toList();

//         return dash.isLoading
//             ? Center(child: ShimmerCard())
//             : Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 margin: const EdgeInsets.all(12),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: openList.isEmpty
//                       ? Center(child: NoDataScreen())
//                       : SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: SizedBox(
//                             width: chartData.length *
//                                 100, // Dynamically set width based on data count
//                             child: SfCartesianChart(
//                               title: ChartTitle(
//                                 text: 'Open vs Fixed Breakdown',
//                                 textStyle: const TextStyle(
//                                   fontFamily: "Mulish",
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF018786),
//                                 ),
//                               ),
//                               legend: Legend(
//                                 isVisible: true,
//                                 position: LegendPosition.bottom,
//                                 textStyle: const TextStyle(
//                                   fontFamily: "Mulish",
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                 ),
//                                 overflowMode: LegendItemOverflowMode.wrap,
//                               ),
//                               tooltipBehavior: TooltipBehavior(enable: true),
//                               primaryXAxis: CategoryAxis(
//                                 labelStyle: const TextStyle(
//                                   fontFamily: "Mulish",
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                 ),
//                                 majorGridLines: const MajorGridLines(width: 0),
//                                 labelRotation: 30,
//                                 edgeLabelPlacement: EdgeLabelPlacement.shift,
//                                 // Enable scrolling on the X-axis
//                                 // enableScrolling: true,
//                               ),
//                               primaryYAxis: NumericAxis(
//                                 labelStyle: const TextStyle(
//                                   fontFamily: "Mulish",
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                 ),
//                                 majorGridLines:
//                                     const MajorGridLines(width: 0.5),
//                                 title: AxisTitle(
//                                   text: 'Counts',
//                                   textStyle: const TextStyle(
//                                     fontFamily: "Mulish",
//                                     fontSize: 14,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                               series: <CartesianSeries>[
//                                 // Open Series with Gradient
//                                 ColumnSeries<OpenChartData, String>(
//                                   dataSource: chartData,
//                                   xValueMapper: (OpenChartData data, _) =>
//                                       data.x,
//                                   yValueMapper: (OpenChartData data, _) =>
//                                       data.y1,
//                                   name: 'Open',
//                                   gradient: const LinearGradient(
//                                     colors: [
//                                       Color(0xFF4FC3F7),
//                                       Color(0xFF0288D1),
//                                     ],
//                                     stops: [0.2, 1.0],
//                                   ),
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(8)),
//                                   dataLabelSettings: const DataLabelSettings(
//                                     isVisible: true,
//                                     textStyle: TextStyle(
//                                       fontFamily: "Mulish",
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                                 // Fixed Series with Gradient
//                                 ColumnSeries<OpenChartData, String>(
//                                   dataSource: chartData,
//                                   xValueMapper: (OpenChartData data, _) =>
//                                       data.x,
//                                   yValueMapper: (OpenChartData data, _) =>
//                                       data.y2,
//                                   name: 'Fixed',
//                                   gradient: const LinearGradient(
//                                     colors: [
//                                       Color(0xFF66BB6A),
//                                       Color(0xFF388E3C),
//                                     ],
//                                     stops: [0.2, 1.0],
//                                   ),
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(8)),
//                                   dataLabelSettings: const DataLabelSettings(
//                                     isVisible: true,
//                                     textStyle: TextStyle(
//                                       fontFamily: "Mulish",
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                               plotAreaBorderWidth: 0,
//                             ),
//                           ),
//                         ),
//                 ),
//               );
//       },
//     );
//   }
// }