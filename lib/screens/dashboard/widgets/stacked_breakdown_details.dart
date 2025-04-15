import 'package:auscurator/provider/dashboard_provider.dart';
import 'package:auscurator/provider/layout_provider.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/widgets/shimmer_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StackedBreakdownDetails extends StatefulWidget {
  const StackedBreakdownDetails({
    super.key,
  });

  @override
  State<StackedBreakdownDetails> createState() =>
      _StackedBreakdownDetailsState();
}

String open_counts = '';
String assign_counts = '';
String progress_counts = '';
String completed_counts = '';
double mttr = 0.0;
double mtbf = 0.0;
String downtime = '';

class _StackedBreakdownDetailsState extends State<StackedBreakdownDetails> {
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
    return Consumer<DashboardProvider>(
      builder: (context, dash, _) {
        if (dash.breakdownTicketCountData?.breakdownReportLists != null &&
            dash.breakdownTicketCountData!.breakdownReportLists!.isNotEmpty) {
          var countData =
              dash.breakdownTicketCountData!.breakdownReportLists![0];
          // logger.w(countData.toJson());
          int progressCount = (countData.checkIn ?? 0) +
              (countData.onHold ?? 0) +
              (countData.pending ?? 0);

          open_counts = countData.open.toString();
          assign_counts = countData.assign.toString();
          progress_counts = progressCount.toString();
          completed_counts = countData.fixed.toString();
          downtime = countData.sumOfDowntime.toString();
          // setState(() {});
        } else {
          open_counts = "0";
          assign_counts = "0";
          progress_counts = "0";
          completed_counts = "0";
          downtime = "0";
        }
        ;
        return Consumer<LayoutProvider>(
          builder: (context, layout, child) {
            return Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      "Breakdown",
                      style: TextStyle(
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF018786)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: dash.isLoading
                          ? ShimmerCustom(
                              child: shimmer_breakdown(),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Card(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Open",
                                            style: TextStyle(
                                              fontFamily: "Mulish",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xFF018786),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          open_counts.isEmpty
                                              ? '0'
                                              : open_counts,
                                          style: const TextStyle(
                                            fontFamily: "Mulish",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(
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
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Assign",
                                            style: TextStyle(
                                              fontFamily: "Mulish",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xFF018786),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          assign_counts.isEmpty
                                              ? '0'
                                              : assign_counts,
                                          style: const TextStyle(
                                            fontFamily: "Mulish",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(
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
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Progress",
                                            style: TextStyle(
                                              fontFamily: "Mulish",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xFF018786),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          progress_counts.isEmpty
                                              ? '0'
                                              : progress_counts,
                                          style: const TextStyle(
                                            fontFamily: "Mulish",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(
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
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Fixed",
                                            style: TextStyle(
                                              fontFamily: "Mulish",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xFF018786),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          completed_counts.isEmpty
                                              ? '0'
                                              : completed_counts,
                                          style: const TextStyle(
                                            fontFamily: "Mulish",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(
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
              ),
            );
          },
        );
      },
    );
  }

  Row shimmer_breakdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Card(
            color: Colors.white,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Open",
                    style: TextStyle(
                      fontFamily: "Mulish",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF018786),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  open_counts.isEmpty ? '0' : open_counts,
                  style: const TextStyle(
                    fontFamily: "Mulish",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Assign",
                    style: TextStyle(
                      fontFamily: "Mulish",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF018786),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  assign_counts.isEmpty ? '0' : assign_counts,
                  style: const TextStyle(
                    fontFamily: "Mulish",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Progress",
                    style: TextStyle(
                      fontFamily: "Mulish",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF018786),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  progress_counts.isEmpty ? '0' : progress_counts,
                  style: const TextStyle(
                    fontFamily: "Mulish",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Fixed",
                    style: TextStyle(
                      fontFamily: "Mulish",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF018786),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  completed_counts.isEmpty ? '0' : completed_counts,
                  style: const TextStyle(
                    fontFamily: "Mulish",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
