import 'package:auscurator/bottom_navigation/bottomnavscreen.dart';
import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/screens/MTTREditScreen.dart';
import 'package:auscurator/machine_iot/screens/consumed_spares_screen.dart';
import 'package:auscurator/machine_iot/screens/solution_bank_edit_screen.dart';
import 'package:auscurator/machine_iot/screens/work_log_screen.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/machine_iot/widget/ticket_info_cart_widget.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/repository/breakdown_repository.dart';
import 'package:auscurator/repository/mttr_repository.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:flutter/material.dart';
import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TicketCompletedScreen extends ConsumerStatefulWidget {
  final String ticketNumber;
  @override
  _TicketCompletedScreenState createState() => _TicketCompletedScreenState();
  const TicketCompletedScreen({
    super.key,
    required this.ticketNumber,
  });
}

class _TicketCompletedScreenState extends ConsumerState<TicketCompletedScreen> {
  final employee_type = SharedUtil().getEmployeeType;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      MttrRepository().MTTRUpdatedLists(context, ticketId: widget.ticketNumber);

      BreakdownRepository()
          .getBreakDownDetailList(context, ticket_no: widget.ticketNumber);
    });
    super.initState();
    checkConnection(context); // Assuming this checks for internet connection
  }

  @override
  Widget build(BuildContext context) {
    final ticketFuture = ref.watch(apiServiceProvider).getBreakDownDetailList(
        date: "date",
        ticket_no: widget.ticketNumber,
        fromDate: DateFormat("dd-MM-yyyy").format(DateTime.now()).toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ticket Details',
          style: TextStyle(fontFamily: "Mulish", color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: ticketFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(
              child: const Center(
                  child: Padding(
                padding: EdgeInsets.all(15),
                child: ShimmerLists(
                  count: 3,
                  width: double.infinity,
                  height: 300,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              )),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final ticketDetails = snapshot.data;

            if (ticketDetails == null ||
                ticketDetails.breakdownDetailList == null ||
                ticketDetails.breakdownDetailList!.isEmpty) {
              return Center(
                child: NoDataScreen(),
              );
            }

            // Accessing the first item of breakdownDetailList safely
            final breakdownDetail = ticketDetails.breakdownDetailList![0];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Image.asset(
                          'images/machine.jpeg',
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(width: 5.0),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '${breakdownDetail.breakdownCategory}',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontFamily: "Mulish", color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                '${breakdownDetail.status}',
                                style: const TextStyle(
                                    fontFamily: "Mulish",
                                    color: Color.fromRGBO(21, 147, 159, 1)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Card(
                              child: IconButton(
                                onPressed: () {
                                  // final LoginId = SharedUtil().getLoginId;

                                  // WorkLogRepository().getWorkLogList(
                                  //     context, {
                                  //   "user_login_id": LoginId,
                                  //   "ticket_id": widget.ticketNumber
                                  // }).then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WorkLogScreen(
                                            ticketNo: widget.ticketNumber,
                                            status:
                                                breakdownDetail.status ?? ""),
                                      ));
                                  // });
                                },
                                icon: const Icon(Icons.description_sharp),
                                color: Color.fromRGBO(30, 152, 165, 1),
                              ),
                            ),
                            const Text('Work Log',
                                style: TextStyle(fontSize: 13))
                          ],
                        ),
                        Column(
                          children: [
                            Card(
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SolutionBankEditScreen(
                                                  status:
                                                      breakdownDetail.status ??
                                                          "",
                                                  ticketNumber:
                                                      widget.ticketNumber, ticketFrom: breakdownDetail.ticketFrom??"",)));
                                },
                                icon: const Icon(Icons.article_outlined),
                                color: Color.fromRGBO(30, 152, 165, 1),
                              ),
                            ),
                            const Text('Solution Bank',
                                style: TextStyle(fontSize: 13))
                          ],
                        ),
                        Column(
                          children: [
                            Card(
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ConsumedSparesScreen(
                                                  status:
                                                      breakdownDetail.status ??
                                                          "",
                                                  asset_id: breakdownDetail
                                                      .assetId
                                                      .toString(),
                                                  asset_group_id:
                                                      breakdownDetail
                                                          .assetGroupId
                                                          .toString(),
                                                  ticketNumber:
                                                      widget.ticketNumber)));
                                },
                                icon: const Icon(Icons.handyman_outlined),
                                color: Color.fromRGBO(30, 152, 165, 1),
                              ),
                            ),
                            const Text('Spares', style: TextStyle(fontSize: 13))
                          ],
                        ),
                        Column(
                          children: [
                            Card(
                              child: IconButton(
                                onPressed: () {
                                  MttrRepository()
                                      .MTTRUpdatedLists(
                                    context,
                                    ticketId: breakdownDetail.id.toString(),
                                  )
                                      .then((value) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MTTREditScreen(
                                                  asset_group_id:
                                                      breakdownDetail
                                                          .assetGroupId
                                                          .toString(),
                                                  ticketNumber: breakdownDetail
                                                      .id
                                                      .toString(),
                                                  downTime: breakdownDetail
                                                      .downtimeDuration
                                                      .toString(),
                                                  status: breakdownDetail.status
                                                      .toString(),
                                                )));
                                  });
                                },
                                icon: const Icon(Icons.timelapse_sharp),
                                color: Color.fromRGBO(30, 152, 165, 1),
                              ),
                            ),
                            const Text('MTTR', style: TextStyle(fontSize: 13))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    if (breakdownDetail.status == 'Completed') ...[
                      if (employee_type != "Engineer") ...[
                        Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Are you sure you  want to Acknowledge this ticket?',
                                              style: TextStyle(
                                                  fontFamily: "Mulish",
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            backgroundColor: Colors.white,
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      fontFamily: "Mulish",
                                                      color: Colors.black),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  ApiService()
                                                      .TicketAccept(
                                                          ticketNo: widget
                                                              .ticketNumber
                                                              .toString(),
                                                          status_id: '11',
                                                          priority: '',
                                                          assign_type: '',
                                                          downtime_val: '',
                                                          open_comment: '',
                                                          assigned_comment: '',
                                                          accept_comment: '',
                                                          reject_comment: '',
                                                          hold_comment: '',
                                                          pending_comment: '',
                                                          check_out_comment: '',
                                                          completed_comment: '',
                                                          reopen_comment: '',
                                                          reassign_comment: '',
                                                          comment: '',
                                                          solution: '',
                                                          breakdown_category_id:
                                                              '',
                                                          breakdown_subcategory_id:
                                                              '',
                                                          checkin_comment: '', planned_Date: '')
                                                      .then((value) {
                                                    if (value.isError ==
                                                        false) {
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              const BottomNavScreen(),
                                                        ),
                                                        (route) => false,
                                                      );
                                                    }
                                                    showMessage(
                                                        context: context,
                                                        isError: value.isError!,
                                                        responseMessage:
                                                            value.message!);
                                                    value.message;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          21, 147, 159, 1),
                                                ),
                                                child: const Text(
                                                  'Submit',
                                                  style: TextStyle(
                                                      fontFamily: "Mulish",
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon:
                                        const Icon(Icons.thumb_up_alt_outlined),
                                    color: Colors.black),
                                const SizedBox(width: 5.0),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        TextEditingController
                                            textFieldController =
                                            TextEditingController();

                                        return AlertDialog(
                                          title: const Text(
                                              'Reason For Re-Open',
                                              style: TextStyle(
                                                  fontFamily: "Mulish",
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          backgroundColor: Colors.white,
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                controller: textFieldController,
                                                decoration: InputDecoration(
                                                  labelText: 'Enter Reason',
                                                  labelStyle: const TextStyle(
                                                      fontFamily: "Mulish",
                                                      color: Colors.black),
                                                  border:
                                                      const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                    fontFamily: "Mulish",
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    fontFamily: "Mulish",
                                                    color: Colors.black),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                ApiService()
                                                    .TicketAccept(
                                                        ticketNo: widget
                                                            .ticketNumber
                                                            .toString(),
                                                        status_id: '12',
                                                        priority: '',
                                                        assign_type: '',
                                                        downtime_val: '',
                                                        open_comment: '',
                                                        assigned_comment: '',
                                                        accept_comment: '',
                                                        reject_comment: '',
                                                        hold_comment: '',
                                                        pending_comment: '',
                                                        check_out_comment: '',
                                                        completed_comment: '',
                                                        reopen_comment:
                                                            textFieldController
                                                                .text,
                                                        reassign_comment: '',
                                                        solution: "",
                                                        comment: '',
                                                        breakdown_category_id:
                                                            '',
                                                        breakdown_subcategory_id:
                                                            '',
                                                        checkin_comment: '', planned_Date: '')
                                                    .then((value) {
                                                  if (value.isError == false) {
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            const BottomNavScreen(),
                                                      ),
                                                      (route) => false,
                                                    );
                                                  }
                                                  showMessage(
                                                      context: context,
                                                      isError: value.isError!,
                                                      responseMessage:
                                                          value.message!);
                                                  value.message;
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        21, 147, 159, 1),
                                              ),
                                              child: const Text(
                                                'Re-Open',
                                                style: TextStyle(
                                                    fontFamily: "Mulish",
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                      Icons.thumb_down_off_alt_sharp),
                                  color: Colors.black,
                                ),
                              ]),
                        ),
                      ]
                    ],
                    const SizedBox(height: 10.0),
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Ticket details',
                            style: TextStyle(
                                fontFamily: "Mulish",
                                color: Color.fromRGBO(21, 147, 159, 1),
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    const SizedBox(height: 10.0),
                    Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(children: [
                          TicketInfoCardWidget(
                            title: 'Category',
                            value: breakdownDetail.breakdownCategory ??
                                'N/A', // Accessing safely
                          ),
                          const SizedBox(height: 5.0),
                          TicketInfoCardWidget(
                            title: 'Issue',
                            value: breakdownDetail.breakdownSubCategory ??
                                'N/A', // Accessing safely
                          ),
                          const SizedBox(height: 5.0),
                          TicketInfoCardWidget(
                            title: 'Ticket Number',
                            value: breakdownDetail.ticketNo ??
                                'N/A', // Accessing safely
                          ),
                          const SizedBox(height: 5.0),
                          TicketInfoCardWidget(
                            title: 'Raised By',
                            value: breakdownDetail.createdBy ??
                                'N/A', // Accessing safely
                          ),
                          const SizedBox(height: 5.0),
                          TicketInfoCardWidget(
                            title: 'Raised Date',
                            value: breakdownDetail.createdOn != null
                                ? DateFormat('yyyy-MM-dd HH:mm').format(
                                    DateTime.parse(breakdownDetail.createdOn
                                            .toString())
                                        .toLocal())
                                : 'N/A', // Assuming createdOn is a string
                          ),
                          const SizedBox(height: 5.0),
                          TicketInfoCardWidget(
                            title: 'Status',
                            value: breakdownDetail.status ??
                                'N/A', // Accessing safely
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Asset details',
                            style: TextStyle(
                                fontFamily: "Mulish",
                                color: Color.fromRGBO(21, 147, 159, 1),
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    const SizedBox(height: 10.0),
                    Card(
                        color: Colors.white,
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(children: [
                              TicketInfoCardWidget(
                                title: 'Asset Status',
                                value: breakdownDetail.machineStatus
                                    .toString(), // Accessing safely
                              ),
                              const SizedBox(height: 5.0),
                              TicketInfoCardWidget(
                                title: 'Asset Name',
                                value: breakdownDetail.asset ??
                                    'N/A', // Accessing safely
                              ),
                              const SizedBox(height: 5.0),
                              TicketInfoCardWidget(
                                title: 'Asset Group',
                                value: breakdownDetail.assetGroupName ?? 'N/A',
                              ),
                              const SizedBox(height: 5.0),
                              TicketInfoCardWidget(
                                title: 'Asset Model',
                                value: breakdownDetail.assetNo ?? 'N/A',
                              ),
                              const SizedBox(height: 5.0),
                              TicketInfoCardWidget(
                                title: 'Location',
                                value: breakdownDetail.location?.toString() ??
                                    'N/A',
                              ),
                              const SizedBox(height: 5.0),
                            ])))
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: NoDataScreen(),
            );
          }
        },
      ),
    );
  }
}
