import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/widget/details_card_widget.dart';
import 'package:auscurator/machine_iot/widget/my_time_line_widget.dart'
    show MyTimeLineWidget;
import 'package:auscurator/model/worklogdetail_model.dart';
import 'package:auscurator/provider/work_log_provider.dart';
import 'package:auscurator/repository/work_log_repository.dart';
import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/shimmer_custom.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:auscurator/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkLogScreen extends StatefulWidget {
  const WorkLogScreen({super.key, required this.ticketNo});
  final String ticketNo;
  // final String status;

  @override
  State<WorkLogScreen> createState() => _WorkLogScreenState();
}

class _WorkLogScreenState extends State<WorkLogScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((time) {
      // WorkLogRepository().getWorkLogList(context, ticket_no: widget.ticketNo);
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
          body: work.isLoading
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
                  : ListView(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        HeightFull(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextCustom(
                              "Ticket No :",
                              size: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            WidthHalf(),
                            TextCustom(
                              "${widget.ticketNo}",
                              size: 18,
                              color: Palette.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        HeightFull(),
                        ListView.builder(
                            itemCount: workDetail.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
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
                            }),
                      ],
                    ),
        );
      },
    );
  }
}
