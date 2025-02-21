import 'package:auscurator/model/worklogdetail_model.dart';
import 'package:auscurator/provider/work_log_provider.dart';
import 'package:auscurator/screens/widgets_common/appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkLogTableScreen extends StatefulWidget {
  @override
  State<WorkLogTableScreen> createState() => _WorkLogTableScreenState();
}

class _WorkLogTableScreenState extends State<WorkLogTableScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkLogProvider>(
      builder: (context, workLog, _) {
        List<BreakdownWorkLogList> workLogDetails =
            workLog.workLogDetailData?.breakdownWorkLogList ?? [];

        return Scaffold(
          appBar: CommonAppBar(title: "WorkLog Details"),
          body: workLogDetails.isEmpty
              ? Center(
                  child: Text(
                    "No data available",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // Wrap in Container with max width for horizontal scrolling
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width),
                      child: Table(
                        border: TableBorder.all(
                          color: Colors.grey, // Border color
                          width: 1.0, // Border width
                        ),
                        columnWidths: {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(3),
                          3: FlexColumnWidth(3),
                          4: FlexColumnWidth(4),
                        },
                        children: [
                          // Header Row
                          TableRow(
                            decoration: BoxDecoration(color: Colors.grey[300]),
                            children: [
                              _buildTableCell('Status', isHeader: true),
                              _buildTableCell('Date Time', isHeader: true),
                              _buildTableCell('Action done by', isHeader: true),
                              _buildTableCell('Engineer', isHeader: true),
                              _buildTableCell('Comment', isHeader: true),
                            ],
                          ),
                          // Data Rows
                          ...workLogDetails.map((item) {
                            return TableRow(children: [
                              _buildTableCell(item.type ?? '-'),
                              _buildTableCell(
                                  "${DateFormat("yyyy-MM-dd").format(DateTime.parse(item.dateTime ?? '-'))}-${DateFormat("hh:mm").format(DateTime.parse(item.dateTime ?? '-'))}"),
                              _buildTableCell(item.loginUserName ?? '-'),
                              _buildTableCell(
                                  item.assignedToEngineerName ?? '-'),
                              _buildTableCell(item.comment ?? '-'),
                            ]);
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 14.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
