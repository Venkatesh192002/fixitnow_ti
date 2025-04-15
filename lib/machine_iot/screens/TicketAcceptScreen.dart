// ignore_for_file: unused_local_variable

import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/bottom_navigation/bottomnavscreen.dart';
import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/model/TicketDetailModel.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/widgets/buttons.dart';
import 'package:auscurator/widgets/dialogs.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:auscurator/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:auscurator/machine_iot/widget/ticket_info_cart_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TicketAcceptScreen extends ConsumerStatefulWidget {
  final String ticketNumber;

  const TicketAcceptScreen({super.key, required this.ticketNumber});

  @override
  ConsumerState createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends ConsumerState<TicketAcceptScreen> {
  @override
  void initState() {
    super.initState();
    checkConnection(context); // Assuming this checks for internet connection
  }

  final login_id = SharedUtil().getLoginId;

  @override
  Widget build(BuildContext context) {
    final ticketFuture = ref.watch(apiServiceProvider).getBreakDownDetailList(
          ticket_no: widget.ticketNumber,
        );

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
      body: FutureBuilder<TicketDetailModel>(
        future: ticketFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.all(10),
              child: ShimmerLists(
                count: 3,
                width: double.infinity,
                height: 200,
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ));
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
            print('${breakdownDetail.createdById},$login_id');
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            TextEditingController textFieldController =
                                TextEditingController();

                            return AlertDialog(
                              title: const Text(
                                  'Do you want to Accept or Check In?',
                                  style: TextStyle(
                                      fontFamily: "Mulish",
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal)),
                              backgroundColor: Colors.white,
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    commonDialog(
                                        context,
                                        PlantDateDialog(
                                          TicketNumber:
                                              widget.ticketNumber.toString(),
                                          statusId: "3",
                                        ));
                                  },
                                  child: const Text(
                                    'Accept',
                                    style: TextStyle(
                                        fontFamily: "Mulish",
                                        color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    commonDialog(
                                        context,
                                        PlantDateDialog(
                                          TicketNumber:
                                              widget.ticketNumber.toString(),
                                          statusId: "6",
                                        ));
                                    // ApiService()
                                    //     .TicketAccept(
                                    //         ticketNo:
                                    //             widget.ticketNumber.toString(),
                                    //         status_id: '6',
                                    //         priority: '',
                                    //         assign_type: '',
                                    //         downtime_val: '',
                                    //         open_comment: '',
                                    //         assigned_comment: '',
                                    //         accept_comment: '',
                                    //         reject_comment: '',
                                    //         hold_comment: '',
                                    //         pending_comment: '',
                                    //         check_out_comment: '',
                                    //         completed_comment: '',
                                    //         reopen_comment: '',
                                    //         reassign_comment: '',
                                    //         comment: '',
                                    //         solution: '',
                                    //         breakdown_category_id: '',
                                    //         breakdown_subcategory_id: '',
                                    //         checkin_comment: '')
                                    //     .then((value) {
                                    //   if (value.isError == false) {
                                    //     // Navigator.of(context)
                                    //     //     .pushAndRemoveUntil(
                                    //     //   MaterialPageRoute(
                                    //     //     builder: (ctx) =>
                                    //     //         const BottomNavScreen(),
                                    //     //   ),
                                    //     //   (route) => false,
                                    //     // );
                                    //   }
                                    //   showMessage(
                                    //       context: context,
                                    //       isError: value.isError!,
                                    //       responseMessage: value.message!);
                                    //   value.message;
                                    // });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(21, 147, 159, 1),
                                  ),
                                  child: const Text(
                                    'Check In',
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(
                            fontFamily: "Mulish", color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: breakdownDetail.engineerId.toString() ==
                              login_id.toString()
                          ? () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  TextEditingController textFieldController =
                                      TextEditingController();

                                  return AlertDialog(
                                    title: const Text('Reason For Reject',
                                        style: TextStyle(
                                            fontFamily: "Mulish",
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal)),
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
                                            border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0))),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Colors.black),
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
                                          if (textFieldController
                                              .text.isEmpty) {
                                            return showMessage(
                                                context: context,
                                                isError: true,
                                                responseMessage:
                                                    "Kindly enter reason");
                                          }
                                          ApiService()
                                              .TicketAccept(
                                                  ticketNo: widget.ticketNumber
                                                      .toString(),
                                                  status_id: '4',
                                                  priority: '',
                                                  assign_type: '',
                                                  downtime_val: '',
                                                  open_comment: '',
                                                  assigned_comment: '',
                                                  accept_comment: '',
                                                  reject_comment:
                                                      textFieldController.text,
                                                  hold_comment: '',
                                                  pending_comment: '',
                                                  check_out_comment: '',
                                                  completed_comment: '',
                                                  reopen_comment: '',
                                                  reassign_comment: '',
                                                  comment: '',
                                                  solution: '',
                                                  breakdown_category_id: '',
                                                  breakdown_subcategory_id: '',
                                                  checkin_comment: '',
                                                  planned_Date: '')
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
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(
                                              21, 147, 159, 1),
                                        ),
                                        child: const Text(
                                          'Reject',
                                          style: TextStyle(
                                              fontFamily: "Mulish",
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
                      ),
                      child: const Text(
                        'Reject',
                        style: TextStyle(
                            fontFamily: "Mulish", color: Colors.white),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12.0),
                  Column(
                    children: [
                      Card(
                        child: IconButton(
                          onPressed: () {
                            // final LoginId = SharedUtil().getLoginId;

                            // WorkLogRepository().getWorkLogList(context, {
                            //   "user_login_id": LoginId,
                            //   "ticket_id": widget.ticketNumber
                            // }).then((value) {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => WorkLogScreen(
                            //           ticketNo: widget.ticketNumber,
                            //           status: breakdownDetail.status ?? ""),
                            //     ));
                            // });
                          },
                          icon: const Icon(Icons.description_sharp),
                          color: Color.fromRGBO(30, 152, 165, 1),
                        ),
                      ),
                      const Text('Work Log')
                    ],
                  ),
                  const SizedBox(height: 12.0),
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
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                                  DateTime.parse(
                                          breakdownDetail.createdOn.toString())
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
                              value:
                                  breakdownDetail.location?.toString() ?? 'N/A',
                            ),
                            const SizedBox(height: 5.0),
                          ])))
                ],
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

class PlantDateDialog extends StatefulWidget {
  const PlantDateDialog(
      {super.key,
      this.TicketNumber,
      this.statusId,
      this.isConfirm = false,
      this.planDate});
  final String? TicketNumber, statusId, planDate;
  final bool isConfirm;

  @override
  State<PlantDateDialog> createState() => _PlantDateDialogState();
}

class _PlantDateDialogState extends State<PlantDateDialog> {
  @override
  void initState() {
    try {
      // Parse string into DateTime
      DateTime parsedDate =
          DateFormat("dd-MM-yyyy").parse(widget.planDate ?? "");
      plantDate = parsedDate; // Assign to DateTime variable
    } catch (e) {
      print("Error parsing date: $e");
      plantDate = null; // Handle error by assigning null
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextCustom("Select Planned Date", fontWeight: FontWeight.bold, size: 18),
      HeightFull(),
      GestureDetector(
        onTap: () => selectDate(context),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(2, 4),
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 16,
                  spreadRadius: -1,
                  offset: Offset(-2, -2),
                ),
              ]),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 25.0, // Adjust the size here
                color: Color(0xFF018786),
              ),
              // Gap(3),
              // Text(
              //   "To:",
              //   style: TextStyle(fontFamily: "Mulish",
              //     fontSize: 16,
              //   ),
              // ),
              SizedBox(width: 12),

              Text(
                plantDate != null
                    ? DateFormat('dd-MM-yyyy').format(plantDate!)
                    : 'Select To Planned Date',
                style: TextStyle(
                    fontFamily: "Mulish",
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
      HeightFull(),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        ButtonPrimary(
            onPressed: () {
              if (widget.isConfirm) {
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            label: "Cancel"),
        WidthFull(),
        ButtonPrimary(
            onPressed: () {
              ApiService()
                  .TicketAccept(
                      ticketNo: widget.TicketNumber.toString(),
                      status_id:
                          widget.isConfirm ? "" : widget.statusId.toString(),
                      isComment: widget.isConfirm ? "yes" : "no",
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
                      breakdown_category_id: '',
                      breakdown_subcategory_id: '',
                      checkin_comment: '',
                      planned_Date: plantDate == "" || plantDate == null
                          ? ""
                          : DateFormat("dd-MM-yyyy").format(plantDate!))
                  .then((value) {
                if (value.isError == false) {
                  if (widget.isConfirm) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (ctx) => const BottomNavScreen(),
                      ),
                      (route) => false,
                    );
                  }
                }
                showMessage(
                    context: context,
                    isError: value.isError!,
                    responseMessage: value.message!);
                value.message;
              });
            },
            label: widget.isConfirm
                ? "Confirm"
                : widget.statusId.toString() == "6"
                    ? "Check In"
                    : "Accept")
      ]),
    ]);
  }

  DateTime? plantDate;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.light(
              primary: const Color.fromRGBO(
                  21, 147, 159, 1), // Header background color
              onPrimary: Colors.white, // Header text and selected text color
              onSurface: Colors.black, // Default text color
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
    if (picked != null && picked != (plantDate)) {
      setState(() {
        plantDate = picked;
      });
    }
  }
}
