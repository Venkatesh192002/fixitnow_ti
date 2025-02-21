import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/widget/details_card_widget.dart';
import 'package:auscurator/machine_iot/widget/my_time_line_widget.dart'
    show MyTimeLineWidget;
import 'package:auscurator/model/worklogdetail_model.dart';
import 'package:auscurator/provider/work_log_provider.dart';
import 'package:auscurator/repository/work_log_repository.dart';
import 'package:auscurator/widgets/shimmer_custom.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkLogScreen extends StatefulWidget {
  const WorkLogScreen(
      {super.key, required this.ticketNo, required this.status});
  final String ticketNo;
  final String status;

  @override
  State<WorkLogScreen> createState() => _WorkLogScreenState();
}

class _WorkLogScreenState extends State<WorkLogScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((time) {
      WorkLogRepository().getWorkLogList(context, ticket_no: widget.ticketNo);
    });
    super.initState();
  }

  // List<Map<String,dynamic>>  workLog =[{"id":1,""}]

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkLogProvider>(
      builder: (context, work, child) {
        // final logData = work.workLogData?.breakdownDetailList?[0];
        List<BreakdownWorkLogList> workDetail =
            work.workLogDetailData?.breakdownWorkLogList ?? [];
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Work Logs',
              style: TextStyle(fontFamily: "Mulish", color: Colors.white),
            ),
            backgroundColor: Color.fromRGBO(30, 152, 165, 1),
            iconTheme: const IconThemeData(
              color: Colors.white, // Change your color here
            ),
            // actions: [
            //   InkWell(
            //       onTap: () => Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => WorkLogTableScreen())),
            //       child: Padding(
            //         padding: const EdgeInsets.only(right: 24),
            //         child: Icon(Icons.work_history, color: Colors.white),
            //       ))
            // ],
          ),
          backgroundColor: Colors.white,
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: work.isLoading
                  ? ShimmerCustom(
                      child: ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemBuilder: (_, i) =>
                              LayoutBuilder(builder: (context, constraints) {
                                return MyTimeLineWidget(
                                  isFirst: i == 0 ? true : false,
                                  isLast: false,
                                  isPast: false,
                                  detailsCard: DetailCardWidget(
                                    isPast: false,
                                    data: workDetail[i],
                                  ),
                                );
                              }),
                          separatorBuilder: (_, i) => const HeightFull(),
                          itemCount: 10))
                  : workDetail.isEmpty
                      ? NoDataScreen()
                      : ListView.builder(
                          itemCount: workDetail.length,
                          itemBuilder: (context, index) {
                            return MyTimeLineWidget(
                              isFirst: index == 0 ? true : false,
                              isLast: workDetail[index].type == "Fixed"
                                  ? true
                                  : false,
                              isPast: true,
                              detailsCard: DetailCardWidget(
                                isPast: false,
                                data: workDetail[index],
                              ),
                            );
                          })
              // ListView(
              //     children: [
              //       logData?.createdOn == "1900-01-01T00:00:00"
              //           ? SizedBox.shrink()
              //           : MyTimeLineWidget(
              //               isFirst: true,
              //               isLast: false,
              //               isPast: logData?.createdOn ==
              //                       "1900-01-01T00:00:00"
              //                   ? false
              //                   : true,
              //               detailsCard: DetailCardWidget(
              //                 isPast: logData?.createdOn ==
              //                         "1900-01-01T00:00:00"
              //                     ? true
              //                     : false,
              //                 data: {
              //                   "head1": "Raised Date",
              //                   "head2": "Raised By",
              //                   "date": logData?.createdOn,
              //                   "status": "Open",
              //                   "comment": logData?.openComment,
              //                   "by": logData?.createdBy
              //                 },
              //               ),
              //             ),
              //       logData?.assignBeginTime == "1900-01-01T00:00:00"
              //           ? SizedBox.shrink()
              //           : MyTimeLineWidget(
              //               isFirst: false,
              //               isLast: false,
              //               isPast: logData?.assignBeginTime ==
              //                       "1900-01-01T00:00:00"
              //                   ? false
              //                   : true,
              //               detailsCard: DetailCardWidget(
              //                 isPast: logData?.assignBeginTime ==
              //                         "1900-01-01T00:00:00"
              //                     ? true
              //                     : false,
              //                 data: {
              //                   "head1": "Assign Date",
              //                   "head2": "Assign To",
              //                   "date": logData?.assignBeginTime,
              //                   "status": "Assign",
              //                   "comment": logData?.assignedComment,
              //                   "by": logData?.assignedToEngineer
              //                 },
              //               )),
              //       logData?.ackBeginTime == "1900-01-01T00:00:00"
              //           ? SizedBox.shrink()
              //           : MyTimeLineWidget(
              //               isFirst: false,
              //               isLast: false,
              //               isPast: logData?.ackBeginTime ==
              //                       "1900-01-01T00:00:00"
              //                   ? false
              //                   : true,
              //               detailsCard: DetailCardWidget(
              //                 isPast: logData?.ackBeginTime ==
              //                         "1900-01-01T00:00:00"
              //                     ? true
              //                     : false,
              //                 data: {
              //                   "head1": "Accept Date",
              //                   "head2": "Accept By",
              //                   "date": logData?.ackBeginTime,
              //                   "status": "Accept",
              //                   "comment": logData?.acceptComment,
              //                   "by": logData?.assignedToEngineer
              //                 },
              //               )),
              //       logData?.checkInTime == "1900-01-01T00:00:00"
              //           ? SizedBox.shrink()
              //           : MyTimeLineWidget(
              //               isFirst: false,
              //               isLast: false,
              //               isPast: logData?.checkInTime ==
              //                       "1900-01-01T00:00:00"
              //                   ? false
              //                   : true,
              //               detailsCard: DetailCardWidget(
              //                 isPast: logData?.checkInTime ==
              //                         "1900-01-01T00:00:00"
              //                     ? true
              //                     : false,
              //                 data: {
              //                   "head1": "Onprogress Date",
              //                   "head2": "Progressed by",
              //                   "date": logData?.checkInTime,
              //                   "status": "Onprogress",
              //                   "comment": logData?.checkOutComment,
              //                   "by": logData?.assignedToEngineer
              //                 },
              //               )),
              //       // logData?.lastCheckOutTime == "1900-01-01T00:00:00"
              //       //     ? SizedBox.shrink()
              //       //     : MyTimeLineWidget(
              //       //         isFirst: false,
              //       //         isLast: false,
              //       //         isPast: logData?.lastCheckOutTime ==
              //       //                 "1900-01-01T00:00:00"
              //       //             ? false
              //       //             : true,
              //       //         detailsCard: DetailCardWidget(
              //       //           isPast: logData?.lastCheckOutTime ==
              //       //                   "1900-01-01T00:00:00"
              //       //               ? true
              //       //               : false,
              //       //           data: {
              //       //             "head1": "Awaiting Date",
              //       //             "head2": "Awaited By",
              //       //             "date": logData?.lastCheckOutTime,
              //       //             "status": "Await RCA",
              //       //             "comment": logData?.holdComment,
              //       //             "by": logData?.assignedToEngineer
              //       //           },
              //       //         )),
              //       logData?.lastCheckOutTime == "1900-01-01T00:00:00"
              //           ? SizedBox.shrink()
              //           : MyTimeLineWidget(
              //               isFirst: false,
              //               isLast: false,
              //               isPast: logData?.lastCheckOutTime ==
              //                       "1900-01-01T00:00:00"
              //                   ? false
              //                   : true,
              //               detailsCard: DetailCardWidget(
              //                 isPast: logData?.lastCheckOutTime ==
              //                         "1900-01-01T00:00:00"
              //                     ? true
              //                     : false,
              //                 data: {
              //                   "head1": "Pending Date",
              //                   "head2": "Pending By",
              //                   "date": logData?.lastCheckOutTime,
              //                   "status": "Pending",
              //                   "comment": logData?.pendingComment,
              //                   "by": logData?.assignedToEngineer
              //                 },
              //               )),
              //       logData?.completeBeginTime == "1900-01-01T00:00:00"
              //           ? SizedBox.shrink()
              //           : MyTimeLineWidget(
              //               isFirst: false,
              //               isLast: false,
              //               isPast: logData?.completeBeginTime ==
              //                       "1900-01-01T00:00:00"
              //                   ? false
              //                   : true,
              //               detailsCard: DetailCardWidget(
              //                 isPast: logData?.completeBeginTime ==
              //                         "1900-01-01T00:00:00"
              //                     ? true
              //                     : false,
              //                 data: {
              //                   "head1": "Completed Date",
              //                   "head2": "Completed By",
              //                   "date": logData?.completeBeginTime,
              //                   "status": "Complete",
              //                   "comment": logData?.completedComment,
              //                   "by": logData?.assignedToEngineer
              //                 },
              //               )),
              //       logData?.fixedBeginTime == "1900-01-01T00:00:00"
              //           ? SizedBox.shrink()
              //           : MyTimeLineWidget(
              //               isFirst: false,
              //               isLast: true,
              //               isPast: logData?.fixedBeginTime ==
              //                       "1900-01-01T00:00:00"
              //                   ? false
              //                   : true,
              //               detailsCard: DetailCardWidget(
              //                 isPast: logData?.fixedBeginTime ==
              //                         "1900-01-01T00:00:00"
              //                     ? true
              //                     : false,
              //                 data: {
              //                   "head1": "Fixed Date",
              //                   "head2": "Fixed By",
              //                   "date": logData?.fixedBeginTime,
              //                   "status": "Fixed",
              //                   "comment": logData?.completedComment,
              //                   "by": logData?.fixedBy
              //                 },
              //               )),
              //     ],
              //   ),
              ),
        );
      },
    );
  }
}
