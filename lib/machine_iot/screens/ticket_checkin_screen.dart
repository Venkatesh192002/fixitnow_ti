import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/bottom_navigation/bottomnavscreen.dart';
import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/screens/TicketAcceptScreen.dart';
import 'package:auscurator/machine_iot/screens/TicketDetailsScreen.dart';
import 'package:auscurator/machine_iot/screens/spare_edit_screen.dart';
import 'package:auscurator/machine_iot/screens/why_why_screen.dart';
import 'package:auscurator/machine_iot/screens/work_log_screen.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/machine_iot/widget/ticket_info_cart_widget.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/model/MainCategoryModel.dart';
import 'package:auscurator/model/SubCategoryModel.dart';
import 'package:auscurator/provider/breakkdown_provider.dart';
import 'package:auscurator/repository/breakdown_repository.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/widgets/context_extension.dart';
import 'package:auscurator/widgets/dialogs.dart';
import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:auscurator/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:auscurator/api_service/api_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/TicketDetailModel.dart' show BreakdownDetailList;

class TicketCheckIn extends StatefulWidget {
  const TicketCheckIn({super.key, required this.ticketNumber});
  final String ticketNumber;

  @override
  State<TicketCheckIn> createState() => _TicketCheckInState();
}

class _TicketCheckInState extends State<TicketCheckIn> {
  String? is_mttr;

  @override
  void initState() {
    checkConnection(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BreakdownRepository()
          .getBreakDownDetailList(context, ticket_no: widget.ticketNumber);
    });

    print('type -> ${employee_type}');
    _loadSharedPreferences();
    setState(() {});
    super.initState();
  }

  Future<void> _loadSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      is_mttr = prefs.getString('is_mttr') ?? "";
    });
  }

  final employee_type = SharedUtil().getEmployeeType;
  @override
  Widget build(BuildContext context) {
    // final ticketFuture = ref.watch(apiServiceProvider).getBreakDownDetailList(
    //       ticket_no: widget.ticketNumber,
    //     );

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Ticket Details',
            style: TextStyle(fontFamily: "Mulish", color: Colors.white),
          ),
          backgroundColor: Color.fromRGBO(30, 152, 165, 1),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        backgroundColor: Colors.white,
        body: Consumer<BreakkdownProvider>(builder: (context, breakDown, _) {
          BreakdownDetailList breakdownDetail =
              breakDown.ticketDetailData?.breakdownDetailList?[0] ??
                  BreakdownDetailList();
          List<BreakdownDetailList> detail =
              breakDown.ticketDetailData?.breakdownDetailList ?? [];
          return breakDown.isLoading
              ? SingleChildScrollView(
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
                )
              : detail.isEmpty
                  ? Center(
                      child: NoDataScreen(),
                    )
                  : SingleChildScrollView(
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
                                SizedBox(width: 5.0),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        '${breakdownDetail.breakdownCategory}',
                                        style: TextStyle(
                                          fontFamily: "Mulish",
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        '${breakdownDetail.status}',
                                        style: TextStyle(
                                            fontFamily: "Mulish",
                                            color: Color.fromRGBO(
                                                21, 147, 159, 1)),
                                      ),
                                      SizedBox(height: 10.0),
                                      if (employee_type == "Head/Engineer")
                                        ElevatedButton(
                                          onPressed: breakdownDetail
                                                  .reassignBy3!.isEmpty
                                              ? () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      TextEditingController
                                                          textReassignController =
                                                          TextEditingController();

                                                      return AlertDialog(
                                                        title: Text(
                                                            'Reason for Re-Assign'),
                                                        backgroundColor:
                                                            Colors.white,
                                                        content: TextField(
                                                          controller:
                                                              textReassignController,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Enter Reason',
                                                            labelStyle:
                                                                TextStyle(
                                                              fontFamily:
                                                                  "Mulish",
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    15.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Mulish",
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              // Perform re-assign action here using textReassignController.text
                                                              ApiService()
                                                                  .TicketAccept(
                                                                      ticketNo: widget
                                                                          .ticketNumber
                                                                          .toString(),
                                                                      status_id:
                                                                          '5',
                                                                      priority:
                                                                          '',
                                                                      assign_type:
                                                                          '',
                                                                      downtime_val:
                                                                          '',
                                                                      open_comment:
                                                                          '',
                                                                      assigned_comment:
                                                                          '',
                                                                      accept_comment:
                                                                          '',
                                                                      reject_comment:
                                                                          '',
                                                                      hold_comment:
                                                                          '',
                                                                      pending_comment:
                                                                          '',
                                                                      check_out_comment:
                                                                          '',
                                                                      completed_comment:
                                                                          '',
                                                                      reopen_comment:
                                                                          '',
                                                                      reassign_comment:
                                                                          textReassignController
                                                                              .text,
                                                                      solution:
                                                                          "",
                                                                      comment:
                                                                          '',
                                                                      breakdown_category_id:
                                                                          '',
                                                                      breakdown_subcategory_id:
                                                                          '',
                                                                      checkin_comment:
                                                                          '',
                                                                      planned_Date:
                                                                          '')
                                                                  .then(
                                                                      (value) {
                                                                if (value
                                                                        .isError ==
                                                                    false) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushReplacement(MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              TicketDetailsScreen(ticketNumber: widget.ticketNumber.toString())));
                                                                }
                                                                showMessage(
                                                                    context:
                                                                        context,
                                                                    isError: value
                                                                        .isError!,
                                                                    responseMessage:
                                                                        value
                                                                            .message!);
                                                              });
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromRGBO(
                                                                          21,
                                                                          147,
                                                                          159,
                                                                          1),
                                                            ),
                                                            child: Text(
                                                                'Re Assign',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Mulish",
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              : null, // Disable button if reassignBy3 is not empty
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromRGBO(21, 147, 159, 1),
                                          ),
                                          child: Text(
                                            'Re Assign',
                                            style: TextStyle(
                                                fontFamily: "Mulish",
                                                color: Colors.white),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                                            //       builder: (context) =>
                                            //           WorkLogScreen(
                                            //               ticketNo: widget
                                            //                   .ticketNumber,
                                            //               status:
                                            //                   breakdownDetail
                                            //                           .status ??
                                            //                       ""),
                                            //     ));
                                            // });
                                          },
                                          icon: const Icon(
                                              Icons.description_sharp),
                                          color:
                                              Color.fromRGBO(30, 152, 165, 1),
                                        ),
                                      ),
                                      const Text('Work Log')
                                    ],
                                  ),
                                  // if (is_mttr == 'yes' &&
                                  //     breakdownDetail.status != 'Accept') ...[
                                  //   SizedBox(width: 20.0),
                                  //   Column(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     children: [
                                  //       Card(
                                  //         child: IconButton(
                                  //           onPressed: () {},
                                  //           icon: Icon(Icons.timelapse_sharp),
                                  //           color: Theme.of(context)
                                  //               .colorScheme
                                  //               .onPrimary,
                                  //         ),
                                  //       ),
                                  //       Text('MTTR'),
                                  //     ],
                                  //   ),
                                  // ],
                                  if (breakdownDetail.status != 'Accept') ...[
                                    SizedBox(width: 20.0),
                                    Column(
                                      children: [
                                        Card(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SpareEditScreen(
                                                    status:
                                                        breakdownDetail.status,
                                                    ticketNumber:
                                                        breakdownDetail.id!
                                                            .toString(),
                                                    asset_id: breakdownDetail
                                                        .assetId!
                                                        .toString(),
                                                    asset_group_id:
                                                        breakdownDetail
                                                            .assetGroupId!
                                                            .toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.handyman_outlined),
                                            color:
                                                Color.fromRGBO(30, 152, 165, 1),
                                          ),
                                        ),
                                        Text('Replace Spares'),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Center(
                              child: SizedBox(
                                width:
                                    300, // Adjust this width based on design requirements
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: TicketInfoCardWidget(
                                        title: 'Check In Time',
                                        value: DateFormat('yyyy-MM-dd HH:mm')
                                            .format(
                                          DateTime.parse(breakdownDetail
                                              .checkInTime
                                              .toString()),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: (breakdownDetail.status ==
                                                  'Accept' ||
                                              breakdownDetail.status ==
                                                  'On Hold' ||
                                              breakdownDetail.status ==
                                                  'Pending')
                                          ? () {
                                              ApiService()
                                                  .TicketAccept(
                                                      ticketNo: widget
                                                          .ticketNumber
                                                          .toString(),
                                                      status_id: '6',
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
                                                      solution: "",
                                                      comment: '',
                                                      breakdown_category_id: '',
                                                      breakdown_subcategory_id:
                                                          '',
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
                                                value.message;
                                              });
                                            }
                                          : null, // Disable the button if the status is not 'accept' or 'on hold'
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: (breakdownDetail
                                                        .status ==
                                                    'Accept' ||
                                                breakdownDetail.status ==
                                                    'On Hold' ||
                                                breakdownDetail.status ==
                                                    'Pending')
                                            ? Colors.red
                                            : Colors
                                                .grey, // Disable color change
                                      ),
                                      child: Text(
                                        'CHECK IN',
                                        style: TextStyle(
                                            fontFamily: "Mulish",
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    ElevatedButton(
                                      onPressed: (breakdownDetail.status ==
                                              'Check In')
                                          ? () => selectStatus(context,
                                              data: breakdownDetail.toJson())
                                          : null, // Disable the button if status is not 'checkin'
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: (breakdownDetail
                                                    .status ==
                                                'Check In')
                                            ? Colors.red
                                            : Colors
                                                .grey, // Disable color change
                                      ),
                                      child: Text(
                                        'CHECK OUT',
                                        style: TextStyle(
                                            fontFamily: "Mulish",
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'Ticket details',
                                    style: TextStyle(
                                        fontFamily: "Mulish",
                                        color: Color.fromRGBO(21, 147, 159, 1),
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            SizedBox(height: 10.0),
                            Card(
                              color: Colors.white,
                              elevation: 3,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(children: [
                                  TicketInfoCardWidget(
                                    title: 'Category',
                                    value: breakdownDetail.breakdownCategory ??
                                        'N/A', // Accessing safely
                                  ),
                                  SizedBox(height: 5.0),
                                  TicketInfoCardWidget(
                                    title: 'Issue',
                                    value:
                                        breakdownDetail.breakdownSubCategory ??
                                            'N/A', // Accessing safely
                                  ),
                                  SizedBox(height: 5.0),
                                  TicketInfoCardWidget(
                                    title: 'Ticket Number',
                                    value: breakdownDetail.ticketNo ??
                                        'N/A', // Accessing safely
                                  ),
                                  SizedBox(height: 5.0),
                                  TicketInfoCardWidget(
                                    title: 'Raised By',
                                    value: breakdownDetail.createdBy ??
                                        'N/A', // Accessing safely
                                  ),
                                  SizedBox(height: 5.0),
                                  TicketInfoCardWidget(
                                    title: 'Raised Date',
                                    value: breakdownDetail.createdOn != null
                                        ? DateFormat('yyyy-MM-dd HH:mm').format(
                                            DateTime.parse(breakdownDetail
                                                    .createdOn
                                                    .toString())
                                                .toLocal())
                                        : 'N/A', // Assuming createdOn is a string
                                  ),
                                  SizedBox(height: 5.0),
                                  TicketInfoCardWidget(
                                    title: 'Status',
                                    value: breakdownDetail.status ??
                                        'N/A', // Accessing safely
                                  ),
                                  SizedBox(height: 5.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 140,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Planned Date",
                                              style: const TextStyle(
                                                  fontFamily: "Mulish",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              ":",
                                              style: const TextStyle(
                                                  fontFamily: "Mulish",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                      WidthFull(),
                                      Expanded(
                                        child: Text(
                                          breakdownDetail.planDate == ""
                                              ? "N/A"
                                              : breakdownDetail.planDate ??
                                                  "N/A",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Mulish",
                                              fontSize: 14),
                                        ),
                                      ),
                                      if (breakdownDetail.status ==
                                                  "Check In" ||
                                              breakdownDetail.status == "Accept"
                                          // ||
                                          //     breakdownDetail.status == "Pending"
                                          ) ...[
                                        InkWell(
                                            onTap: () {
                                              logger
                                                  .e(breakdownDetail.planDate);
                                              commonDialog(
                                                  context,
                                                  PlantDateDialog(
                                                    isConfirm: true,
                                                    planDate: breakdownDetail
                                                            .planDate ??
                                                        "",
                                                    TicketNumber:
                                                        widget.ticketNumber,
                                                    statusId: breakdownDetail
                                                        .statusId
                                                        .toString(),
                                                  ));
                                            },
                                            child: Icon(Icons.edit))
                                      ]
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
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
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(children: [
                                      TicketInfoCardWidget(
                                        title: 'Asset Status',
                                        value: breakdownDetail.machineStatus
                                            .toString(), // Accessing safely
                                      ),
                                      SizedBox(height: 5.0),
                                      TicketInfoCardWidget(
                                        title: 'Asset Name',
                                        value: breakdownDetail.asset ??
                                            'N/A', // Accessing safely
                                      ),
                                      SizedBox(height: 5.0),
                                      TicketInfoCardWidget(
                                        title: 'Asset Group',
                                        value: breakdownDetail.assetGroupName ??
                                            'N/A',
                                      ),
                                      SizedBox(height: 5.0),
                                      TicketInfoCardWidget(
                                        title: 'Asset Model',
                                        value: breakdownDetail.assetNo ?? 'N/A',
                                      ),
                                      SizedBox(height: 5.0),
                                      TicketInfoCardWidget(
                                        title: 'Location',
                                        value: breakdownDetail.location
                                                ?.toString() ??
                                            'N/A',
                                      ),
                                      SizedBox(height: 5.0),
                                    ])))
                          ],
                        ),
                      ),
                    );
        })
        // FutureBuilder(
        //   future: ticketFuture,
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return SingleChildScrollView(
        //         child: const Center(
        //             child: Padding(
        //           padding: EdgeInsets.all(15),
        //           child: ShimmerLists(
        //             count: 3,
        //             width: double.infinity,
        //             height: 300,
        //             shapeBorder: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.all(Radius.circular(10))),
        //           ),
        //         )),
        //       );
        //     } else if (snapshot.hasError) {
        //       return Center(child: Text('Error: ${snapshot.error}'));
        //     } else if (snapshot.hasData) {
        //       final ticketDetails = snapshot.data;

        //       if (ticketDetails == null ||
        //           ticketDetails.breakdownDetailList == null ||
        //           ticketDetails.breakdownDetailList!.isEmpty) {
        //         return Center(
        //           child: NoDataScreen(),
        //         );
        //       }

        //       // Accessing the first item of breakdownDetailList safely
        //       final breakdownDetail = ticketDetails.breakdownDetailList![0];
        //       return SingleChildScrollView(
        //         child: Padding(
        //           padding: const EdgeInsets.all(10.0),
        //           child: Column(
        //             children: <Widget>[
        //               Row(
        //                 children: [
        //                   Image.asset(
        //                     'images/machine.jpeg',
        //                     width: 150,
        //                     height: 150,
        //                   ),
        //                   SizedBox(width: 5.0),
        //                   Expanded(
        //                     child: Column(
        //                       children: [
        //                         Text(
        //                           '${breakdownDetail.breakdownCategory}',
        //                           style: TextStyle(
        //                             fontFamily: "Mulish",
        //                             color: Colors.black,
        //                           ),
        //                           textAlign: TextAlign.center,
        //                         ),
        //                         SizedBox(height: 10.0),
        //                         Text(
        //                           '${breakdownDetail.status}',
        //                           style: TextStyle(
        //                               fontFamily: "Mulish",
        //                               color: Color.fromRGBO(21, 147, 159, 1)),
        //                         ),
        //                         SizedBox(height: 10.0),
        //                         if (employee_type == "Head/Engineer")
        //                           ElevatedButton(
        //                             onPressed: breakdownDetail
        //                                     .reassignBy3!.isEmpty
        //                                 ? () {
        //                                     showDialog(
        //                                       context: context,
        //                                       builder: (BuildContext context) {
        //                                         TextEditingController
        //                                             textReassignController =
        //                                             TextEditingController();

        //                                         return AlertDialog(
        //                                           title: Text(
        //                                               'Reason for Re-Assign'),
        //                                           backgroundColor: Colors.white,
        //                                           content: TextField(
        //                                             controller:
        //                                                 textReassignController,
        //                                             decoration: InputDecoration(
        //                                               labelText: 'Enter Reason',
        //                                               border: OutlineInputBorder(
        //                                                 borderRadius:
        //                                                     BorderRadius.all(
        //                                                   Radius.circular(15.0),
        //                                                 ),
        //                                               ),
        //                                             ),
        //                                           ),
        //                                           actions: [
        //                                             TextButton(
        //                                               onPressed: () {
        //                                                 Navigator.pop(context);
        //                                               },
        //                                               child: const Text('Cancel',
        //                                                   style: TextStyle(
        //                                                       fontFamily:
        //                                                           "Mulish",
        //                                                       color:
        //                                                           Colors.black)),
        //                                             ),
        //                                             ElevatedButton(
        //                                               onPressed: () {
        //                                                 // Perform re-assign action here using textReassignController.text
        //                                                 ApiService()
        //                                                     .TicketAccept(
        //                                                         ticketNo: widget
        //                                                             .ticketNumber
        //                                                             .toString(),
        //                                                         status_id: '5',
        //                                                         priority: '',
        //                                                         assign_type: '',
        //                                                         downtime_val: '',
        //                                                         open_comment: '',
        //                                                         assigned_comment:
        //                                                             '',
        //                                                         accept_comment:
        //                                                             '',
        //                                                         reject_comment:
        //                                                             '',
        //                                                         hold_comment: '',
        //                                                         pending_comment:
        //                                                             '',
        //                                                         check_out_comment:
        //                                                             '',
        //                                                         completed_comment:
        //                                                             '',
        //                                                         reopen_comment:
        //                                                             '',
        //                                                         reassign_comment:
        //                                                             textReassignController
        //                                                                 .text,
        //                                                         solution: "",
        //                                                         comment: '')
        //                                                     .then((value) {
        //                                                   if (value.isError ==
        //                                                       false) {
        //                                                     Navigator.of(context).pushReplacement(MaterialPageRoute(
        //                                                         builder: (context) =>
        //                                                             TicketDetailsScreen(
        //                                                                 ticketNumber: widget
        //                                                                     .ticketNumber
        //                                                                     .toString())));
        //                                                   }
        //                                                   showMessage(
        //                                                       context: context,
        //                                                       isError:
        //                                                           value.isError!,
        //                                                       responseMessage:
        //                                                           value.message!);
        //                                                 });
        //                                               },
        //                                               style: ElevatedButton
        //                                                   .styleFrom(
        //                                                 backgroundColor:
        //                                                     Color.fromRGBO(
        //                                                         21, 147, 159, 1),
        //                                               ),
        //                                               child: Text('Re Assign',
        //                                                   style: TextStyle(
        //                                                       fontFamily:
        //                                                           "Mulish",
        //                                                       color:
        //                                                           Colors.white)),
        //                                             ),
        //                                           ],
        //                                         );
        //                                       },
        //                                     );
        //                                   }
        //                                 : null, // Disable button if reassignBy3 is not empty
        //                             style: ElevatedButton.styleFrom(
        //                               backgroundColor:
        //                                   Color.fromRGBO(21, 147, 159, 1),
        //                             ),
        //                             child: Text(
        //                               'Re Assign',
        //                               style: TextStyle(
        //                                   fontFamily: "Mulish",
        //                                   color: Colors.white),
        //                             ),
        //                           ),
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(height: 10.0),
        //               Center(
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   crossAxisAlignment: CrossAxisAlignment.center,
        //                   children: [
        //                     Column(
        //                       children: [
        //                         Card(
        //                           child: IconButton(
        //                             onPressed: () {
        //                               // final LoginId = SharedUtil().getLoginId;

        //                               // WorkLogRepository().getWorkLogList(context, {
        //                               //   "user_login_id": LoginId,
        //                               //   "ticket_id": widget.ticketNumber
        //                               // }).then((value) {
        //                               Navigator.push(
        //                                   context,
        //                                   MaterialPageRoute(
        //                                     builder: (context) => WorkLogScreen(
        //                                         ticketNo: widget.ticketNumber,
        //                                         status:
        //                                             breakdownDetail.status ?? ""),
        //                                   ));
        //                               // });
        //                             },
        //                             icon: const Icon(Icons.description_sharp),
        //                             color:
        //                                 Color.fromRGBO(30, 152, 165, 1),
        //                           ),
        //                         ),
        //                         const Text('Work Log')
        //                       ],
        //                     ),
        //                     if (is_mttr == 'yes' &&
        //                         breakdownDetail.status != 'Accept') ...[
        //                       SizedBox(width: 20.0),
        //                       Column(
        //                         mainAxisSize: MainAxisSize.min,
        //                         children: [
        //                           Card(
        //                             child: IconButton(
        //                               onPressed: () {
        //                                 Navigator.push(
        //                                   context,
        //                                   MaterialPageRoute(
        //                                     builder: (context) => MTTRScreen(
        //                                       asset_group_id: breakdownDetail
        //                                           .assetGroupId
        //                                           .toString(),
        //                                       ticketNumber:
        //                                           breakdownDetail.id.toString(),
        //                                       downTime: breakdownDetail
        //                                           .downtimeDuration
        //                                           .toString(),
        //                                       status: breakdownDetail.status
        //                                           .toString(),
        //                                     ),
        //                                   ),
        //                                 );
        //                               },
        //                               icon: Icon(Icons.timelapse_sharp),
        //                               color:
        //                                   Color.fromRGBO(30, 152, 165, 1),
        //                             ),
        //                           ),
        //                           Text('MTTR'),
        //                         ],
        //                       ),
        //                     ],
        //                     if (breakdownDetail.status != 'Accept') ...[
        //                       SizedBox(width: 20.0),
        //                       Column(
        //                         children: [
        //                           Card(
        //                             child: IconButton(
        //                               onPressed: () {
        //                                 Navigator.push(
        //                                   context,
        //                                   MaterialPageRoute(
        //                                     builder: (context) => SpareEditScreen(
        //                                       ticketNumber:
        //                                           breakdownDetail.id!.toString(),
        //                                       asset_id: breakdownDetail.assetId!
        //                                           .toString(),
        //                                       asset_group_id: breakdownDetail
        //                                           .assetGroupId!
        //                                           .toString(),
        //                                     ),
        //                                   ),
        //                                 );
        //                               },
        //                               icon: Icon(Icons.handyman_outlined),
        //                               color:
        //                                   Color.fromRGBO(30, 152, 165, 1),
        //                             ),
        //                           ),
        //                           Text('Replace Spares'),
        //                         ],
        //                       ),
        //                     ],
        //                   ],
        //                 ),
        //               ),
        //               SizedBox(height: 16.0),
        //               Center(
        //                 child: SizedBox(
        //                   width:
        //                       300, // Adjust this width based on design requirements
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     children: [
        //                       Flexible(
        //                         fit: FlexFit.loose,
        //                         child: TicketInfoCardWidget(
        //                           title: 'Check In Time',
        //                           value: DateFormat('yyyy-MM-dd HH:mm').format(
        //                             DateTime.parse(
        //                                 breakdownDetail.checkInTime.toString()),
        //                           ),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //               SizedBox(height: 10.0),
        //               Center(
        //                 child: SizedBox(
        //                   width: MediaQuery.of(context).size.width * 0.9,
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     children: [
        //                       ElevatedButton(
        //                         onPressed: (breakdownDetail.status == 'Accept' ||
        //                                 breakdownDetail.status == 'On Hold' ||
        //                                 breakdownDetail.status == 'Pending')
        //                             ? () {
        //                                 ApiService()
        //                                     .TicketAccept(
        //                                         ticketNo: widget.ticketNumber
        //                                             .toString(),
        //                                         status_id: '6',
        //                                         priority: '',
        //                                         assign_type: '',
        //                                         downtime_val: '',
        //                                         open_comment: '',
        //                                         assigned_comment: '',
        //                                         accept_comment: '',
        //                                         reject_comment: '',
        //                                         hold_comment: '',
        //                                         pending_comment: '',
        //                                         check_out_comment: '',
        //                                         completed_comment: '',
        //                                         reopen_comment: '',
        //                                         reassign_comment: '',
        //                                         solution: "",
        //                                         comment: '')
        //                                     .then((value) {
        //                                   if (value.isError == false) {
        //                                     Navigator.of(context)
        //                                         .pushAndRemoveUntil(
        //                                       MaterialPageRoute(
        //                                         builder: (ctx) =>
        //                                             const BottomNavScreen(),
        //                                       ),
        //                                       (route) => false,
        //                                     );
        //                                   }
        //                                   showMessage(
        //                                       context: context,
        //                                       isError: value.isError!,
        //                                       responseMessage: value.message!);
        //                                   value.message;
        //                                 });
        //                               }
        //                             : null, // Disable the button if the status is not 'accept' or 'on hold'
        //                         style: ElevatedButton.styleFrom(
        //                           backgroundColor: (breakdownDetail.status ==
        //                                       'Accept' ||
        //                                   breakdownDetail.status == 'On Hold' ||
        //                                   breakdownDetail.status == 'Pending')
        //                               ? Colors.red
        //                               : Colors.grey, // Disable color change
        //                         ),
        //                         child: Text(
        //                           'CHECK IN',
        //                           style: TextStyle(
        //                               fontFamily: "Mulish", color: Colors.white),
        //                         ),
        //                       ),
        //                       SizedBox(width: 10.0),
        //                       ElevatedButton(
        //                         onPressed: (breakdownDetail.status == 'Check In')
        //                             ? () => selectStatus(context,
        //                                 data: breakdownDetail.toJson())
        //                             : null, // Disable the button if status is not 'checkin'
        //                         style: ElevatedButton.styleFrom(
        //                           backgroundColor:
        //                               (breakdownDetail.status == 'Check In')
        //                                   ? Colors.red
        //                                   : Colors.grey, // Disable color change
        //                         ),
        //                         child: Text(
        //                           'CHECK OUT',
        //                           style: TextStyle(
        //                               fontFamily: "Mulish", color: Colors.white),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //               SizedBox(height: 10.0),
        //               Align(
        //                   alignment: Alignment.topLeft,
        //                   child: Padding(
        //                     padding: const EdgeInsets.only(left: 10.0),
        //                     child: Text(
        //                       'Ticket details',
        //                       style: TextStyle(
        //                           fontFamily: "Mulish",
        //                           color: Color.fromRGBO(21, 147, 159, 1),
        //                           fontWeight: FontWeight.bold),
        //                     ),
        //                   )),
        //               SizedBox(height: 10.0),
        //               Card(
        //                 color: Colors.white,
        //                 elevation: 3,
        //                 margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        //                 child: Padding(
        //                   padding: EdgeInsets.all(10),
        //                   child: Column(children: [
        //                     TicketInfoCardWidget(
        //                       title: 'Category',
        //                       value: breakdownDetail.breakdownCategory ??
        //                           'N/A', // Accessing safely
        //                     ),
        //                     SizedBox(height: 5.0),
        //                     TicketInfoCardWidget(
        //                       title: 'Issue',
        //                       value: breakdownDetail.breakdownCategory ??
        //                           'N/A', // Accessing safely
        //                     ),
        //                     SizedBox(height: 5.0),
        //                     TicketInfoCardWidget(
        //                       title: 'Ticket Number',
        //                       value: breakdownDetail.ticketNo ??
        //                           'N/A', // Accessing safely
        //                     ),
        //                     SizedBox(height: 5.0),
        //                     TicketInfoCardWidget(
        //                       title: 'Raised By',
        //                       value: breakdownDetail.createdBy ??
        //                           'N/A', // Accessing safely
        //                     ),
        //                     SizedBox(height: 5.0),
        //                     TicketInfoCardWidget(
        //                       title: 'Raised Date',
        //                       value: breakdownDetail.createdOn != null
        //                           ? DateFormat('yyyy-MM-dd HH:mm').format(
        //                               DateTime.parse(breakdownDetail.createdOn
        //                                       .toString())
        //                                   .toLocal())
        //                           : 'N/A', // Assuming createdOn is a string
        //                     ),
        //                     SizedBox(height: 5.0),
        //                     TicketInfoCardWidget(
        //                       title: 'Status',
        //                       value: breakdownDetail.status ??
        //                           'N/A', // Accessing safely
        //                     ),
        //                   ]),
        //                 ),
        //               ),
        //               const SizedBox(height: 10.0),
        //               const Align(
        //                   alignment: Alignment.topLeft,
        //                   child: Padding(
        //                     padding: const EdgeInsets.only(left: 10.0),
        //                     child: Text(
        //                       'Asset details',
        //                       style: TextStyle(
        //                           fontFamily: "Mulish",
        //                           color: Color.fromRGBO(21, 147, 159, 1),
        //                           fontWeight: FontWeight.bold),
        //                     ),
        //                   )),
        //               const SizedBox(height: 10.0),
        //               Card(
        //                   color: Colors.white,
        //                   elevation: 3,
        //                   margin:
        //                       EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        //                   child: Padding(
        //                       padding: EdgeInsets.all(10),
        //                       child: Column(children: [
        //                         TicketInfoCardWidget(
        //                           title: 'Asset Status',
        //                           value: breakdownDetail.machineStatus
        //                               .toString(), // Accessing safely
        //                         ),
        //                         SizedBox(height: 5.0),
        //                         TicketInfoCardWidget(
        //                           title: 'Asset Name',
        //                           value: breakdownDetail.asset ??
        //                               'N/A', // Accessing safely
        //                         ),
        //                         SizedBox(height: 5.0),
        //                         TicketInfoCardWidget(
        //                           title: 'Asset Group',
        //                           value: breakdownDetail.assetGroupName ?? 'N/A',
        //                         ),
        //                         SizedBox(height: 5.0),
        //                         TicketInfoCardWidget(
        //                           title: 'Asset Model',
        //                           value: breakdownDetail.assetNo ?? 'N/A',
        //                         ),
        //                         SizedBox(height: 5.0),
        //                         TicketInfoCardWidget(
        //                           title: 'Location',
        //                           value: breakdownDetail.location?.toString() ??
        //                               'N/A',
        //                         ),
        //                         SizedBox(height: 5.0),
        //                       ])))
        //             ],
        //           ),
        //         ),
        //       );
        //     } else {
        //       return Center(
        //         child: NoDataScreen(),
        //       );
        //     }
        //   },
        // ),
        );
  }

  TextEditingController textCategoryController = TextEditingController();
  TextEditingController textSubCategoryController = TextEditingController();
  String selectedMainCategoryId = '';
  String selectedSubCategoryId = '';

  Future<dynamic> selectStatus(BuildContext context,
      {required Map<String, dynamic> data}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.6),
      builder: (BuildContext context) {
        TextEditingController textFieldController = TextEditingController();
        String selectedStatus = '8';
        // List<MainBreakdownCategoryLists> filteredItems =
        //     MainBreakdownCategoryLists();
        // textCategoryController.text=
        return Consumer<BreakkdownProvider>(
          builder: (context, breakDown, _) {
            List<MainBreakdownCategoryLists> mainCategoryList =
                breakDown.mainCategoryData?.breakdownCategoryLists ?? [];
            List<BreakdownCategoryLists> subCategoryList =
                breakDown.subCategoryData?.breakdownCategoryLists ?? [];

            for (var category in mainCategoryList) {
              if (category.breakdownCategoryId.toString() ==
                  data["breakdown_category_id"].toString()) {
                textCategoryController.text =
                    category.breakdownCategoryName ?? '';
                selectedMainCategoryId = "${category.breakdownCategoryId}";
                break;
              }
            }
            for (var category in subCategoryList) {
              if (category.breakdownSubCategoryId.toString() ==
                  data["breakdown_sub_category_id"].toString()) {
                textSubCategoryController.text =
                    category.breakdownSubCategory ?? '';
                selectedSubCategoryId = "${category.breakdownSubCategoryId}";
                break;
              }
            }

            return Container(
              width: context.widthFull(),
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Select Status',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Mulish")),
                      HeightFull(),
                      DropdownButtonFormField<String>(
                        value: selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value!;
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            // value: '17',
                            // child: Text('Await RCA'),
                            value: '8',
                            child: Text('Hold'),
                          ),
                          DropdownMenuItem(
                            value: '9',
                            child: Text('Pending'),
                          ),
                          DropdownMenuItem(
                            value: 'Completed',
                            child: Text('Completed'),
                          ),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.black)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(
                            fontFamily: "Mulish", color: Colors.black),
                        iconEnabledColor: Colors.black,
                      ),
                      SizedBox(height: 10.0),
                      // TextField(
                      //   controller: textCategoryController,
                      //   readOnly: true,
                      //   onTap: () async {
                      //     final MainBreakdownCategoryLists? result =
                      //         await showDialog<MainBreakdownCategoryLists>(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return MainCategoryDialog();
                      //       },
                      //     );
                      //     if (result != null) {
                      //       setState(() {
                      //         textCategoryController.text =
                      //             result.breakdownCategoryName ?? '';
                      //         selectedMainCategoryId =
                      //             result.breakdownCategoryId.toString();
                      //       });
                      //       SharedPreferences prefs =
                      //           await SharedPreferences.getInstance();
                      //       await prefs.setString('breakdown_category_id',
                      //           result.breakdownCategoryId.toString());
                      //     }
                      //   },
                      //   decoration: const InputDecoration(
                      //     // labelText: 'Select Breakdown Category',
                      //     hintText: "Select Breakdown Category",
                      //     border: OutlineInputBorder(
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(15.0)),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 10.0),
                      // TextField(
                      //   controller: textSubCategoryController,
                      //   readOnly: true,
                      //   onTap: () async {
                      //     final BreakdownCategoryLists? result =
                      //         await showDialog<BreakdownCategoryLists>(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return SubCategoryDialog();
                      //       },
                      //     );
                      //     if (result != null) {
                      //       setState(() {
                      //         textSubCategoryController.text =
                      //             result.breakdownSubCategory ?? '';
                      //         selectedSubCategoryId =
                      //             result.breakdownSubCategoryId.toString();
                      //       });
                      //     }
                      //   },
                      //   decoration: const InputDecoration(
                      //     // labelText: 'Select Breakdown',
                      //     hintText: "Select Breakdown",
                      //     border: OutlineInputBorder(
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(15.0)),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 10.0),
                      TextField(
                        controller: textFieldController,
                        decoration: InputDecoration(
                          labelText: 'Enter Reason',
                          labelStyle: TextStyle(
                              fontFamily: "Mulish", color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(
                            fontFamily: "Mulish", color: Colors.black),
                      ),
                      HeightFull(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  fontFamily: "Mulish", color: Colors.black),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (textFieldController.text.isEmpty &&
                                  selectedStatus != 'Completed') {
                                return showMessage(
                                    context: context,
                                    isError: true,
                                    responseMessage: "Kindly enter reason");
                              }

                              if (selectedStatus == 'Completed') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WhyWhyScreen(
                                        ticketNumber: widget.ticketNumber,
                                        comment: textFieldController.text,
                                        categoryId: selectedMainCategoryId,
                                        subCategoryId: selectedSubCategoryId, ticketFrom: data["ticket_from"]),
                                  ),
                                );
                                // commonDialog(
                                //     context,
                                //     MyWidget(
                                //       ticketNumber: widget.ticketNumber,
                                //       comment: textFieldController.text,
                                //       categoryId: selectedMainCategoryId,
                                //       subCategoryId: selectedSubCategoryId,
                                //     ));
                              } else {
                                ApiService()
                                    .TicketAccept(
                                        ticketNo:
                                            widget.ticketNumber.toString(),
                                        status_id: selectedStatus == 'completed'
                                            ? ''
                                            : selectedStatus,
                                        priority: '',
                                        assign_type: '',
                                        downtime_val: '',
                                        open_comment: '',
                                        assigned_comment: '',
                                        accept_comment: '',
                                        reject_comment: '',
                                        hold_comment: textFieldController.text,
                                        pending_comment:
                                            textFieldController.text,
                                        check_out_comment:
                                            textFieldController.text,
                                        completed_comment:
                                            textFieldController.text,
                                        reopen_comment: '',
                                        reassign_comment: '',
                                        solution: "",
                                        comment: '',
                                        breakdown_category_id: '',
                                        breakdown_subcategory_id: '',
                                        checkin_comment: '',
                                        planned_Date: '')
                                    .then((value) {
                                  if (value.isError == false) {
                                    Navigator.of(context).pushAndRemoveUntil(
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
                                      responseMessage: value.message!);
                                  value.message;
                                });
                              }
                              // if (textFieldController.text.isEmpty) {
                              //   return showMessage(
                              //       context: context,
                              //       isError: true,
                              //       responseMessage: "Kindly enter reason");
                              // }
                              // logger.w(selectedStatus == 'Completed');
                              // if (selectedStatus == 'Completed') {
                              //   // Navigate to WhyWhyScreen if selectedStatus is 'Completed'

                              //   commonDialog(
                              //       context,
                              //       MyWidget(
                              //         ticketNumber: widget.ticketNumber,
                              //         comment: textFieldController.text,
                              //         categoryId: selectedMainCategoryId,
                              //         subCategoryId: selectedSubCategoryId,
                              //       ));
                              // } else {
                              //   // Call your API here for other statuses

                              //   ApiService()
                              //       .TicketAccept(
                              //           ticketNo:
                              //               widget.ticketNumber.toString(),
                              //           status_id: selectedStatus == 'completed'
                              //               ? ''
                              //               : selectedStatus,
                              //           priority: '',
                              //           assign_type: '',
                              //           downtime_val: '',
                              //           open_comment: '',
                              //           assigned_comment: '',
                              //           accept_comment: '',
                              //           reject_comment: '',
                              //           hold_comment: textFieldController.text,
                              //           pending_comment:
                              //               textFieldController.text,
                              //           check_out_comment:
                              //               textFieldController.text,
                              //           completed_comment:
                              //               textFieldController.text,
                              //           reopen_comment: '',
                              //           reassign_comment: '',
                              //           solution: "",
                              //           comment: '',
                              //           breakdown_category_id: '',
                              //           breakdown_subcategory_id: '')
                              //       .then((value) {
                              //     if (value.isError == false) {
                              //       Navigator.of(context).pushAndRemoveUntil(
                              //         MaterialPageRoute(
                              //           builder: (ctx) =>
                              //               const BottomNavScreen(),
                              //         ),
                              //         (route) => false,
                              //       );
                              //     }
                              //     showMessage(
                              //         context: context,
                              //         isError: value.isError!,
                              //         responseMessage: value.message!);
                              //     value.message;
                              //   });
                              // }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(21, 147, 159, 1),
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontFamily: "Mulish", color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// class TicketCheckIn extends ConsumerStatefulWidget {
//   final String ticketNumber;

//   TicketCheckIn({required this.ticketNumber});

//   @override
//   _TicketCheckInState createState() => _TicketCheckInState();
// }

// class _TicketCheckInState extends ConsumerState<TicketCheckIn> {
//   String? is_mttr;

//   @override
//   void initState() {
//     checkConnection(context);
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       BreakdownRepository()
//           .getBreakDownDetailList(context, ticket_no: widget.ticketNumber);
//     });

//     print('type -> ${employee_type}');
//     _loadSharedPreferences();
//     setState(() {});
//     super.initState();
//   }

//   Future<void> _loadSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       is_mttr = prefs.getString('is_mttr') ?? "";
//     });
//   }

//   final employee_type = SharedUtil().getEmployeeType;
//   @override
//   Widget build(BuildContext context) {
//     final ticketFuture = ref.watch(apiServiceProvider).getBreakDownDetailList(
//           ticket_no: widget.ticketNumber,
//         );

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Ticket Details',
//           style: TextStyle(fontFamily: "Mulish", color: Colors.white),
//         ),
//         backgroundColor: Color.fromRGBO(30, 152, 165, 1),
//         iconTheme: IconThemeData(
//           color: Colors.white, //change your color here
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: FutureBuilder(
//         future: ticketFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return SingleChildScrollView(
//               child: const Center(
//                   child: Padding(
//                 padding: EdgeInsets.all(15),
//                 child: ShimmerLists(
//                   count: 3,
//                   width: double.infinity,
//                   height: 300,
//                   shapeBorder: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10))),
//                 ),
//               )),
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             final ticketDetails = snapshot.data;

//             if (ticketDetails == null ||
//                 ticketDetails.breakdownDetailList == null ||
//                 ticketDetails.breakdownDetailList!.isEmpty) {
//               return Center(
//                 child: NoDataScreen(),
//               );
//             }

//             // Accessing the first item of breakdownDetailList safely
//             final breakdownDetail = ticketDetails.breakdownDetailList![0];
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   children: <Widget>[
//                     Row(
//                       children: [
//                         Image.asset(
//                           'images/machine.jpeg',
//                           width: 150,
//                           height: 150,
//                         ),
//                         SizedBox(width: 5.0),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Text(
//                                 '${breakdownDetail.breakdownCategory}',
//                                 style: TextStyle(
//                                   fontFamily: "Mulish",
//                                   color: Colors.black,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(height: 10.0),
//                               Text(
//                                 '${breakdownDetail.status}',
//                                 style: TextStyle(
//                                     fontFamily: "Mulish",
//                                     color: Color.fromRGBO(21, 147, 159, 1)),
//                               ),
//                               SizedBox(height: 10.0),
//                               if (employee_type == "Head/Engineer")
//                                 ElevatedButton(
//                                   onPressed: breakdownDetail
//                                           .reassignBy3!.isEmpty
//                                       ? () {
//                                           showDialog(
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               TextEditingController
//                                                   textReassignController =
//                                                   TextEditingController();

//                                               return AlertDialog(
//                                                 title: Text(
//                                                     'Reason for Re-Assign'),
//                                                 backgroundColor: Colors.white,
//                                                 content: TextField(
//                                                   controller:
//                                                       textReassignController,
//                                                   decoration: InputDecoration(
//                                                     labelText: 'Enter Reason',
//                                                     border: OutlineInputBorder(
//                                                       borderRadius:
//                                                           BorderRadius.all(
//                                                         Radius.circular(15.0),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 actions: [
//                                                   TextButton(
//                                                     onPressed: () {
//                                                       Navigator.pop(context);
//                                                     },
//                                                     child: const Text('Cancel',
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                                 "Mulish",
//                                                             color:
//                                                                 Colors.black)),
//                                                   ),
//                                                   ElevatedButton(
//                                                     onPressed: () {
//                                                       // Perform re-assign action here using textReassignController.text
//                                                       ApiService()
//                                                           .TicketAccept(
//                                                               ticketNo: widget
//                                                                   .ticketNumber
//                                                                   .toString(),
//                                                               status_id: '5',
//                                                               priority: '',
//                                                               assign_type: '',
//                                                               downtime_val: '',
//                                                               open_comment: '',
//                                                               assigned_comment:
//                                                                   '',
//                                                               accept_comment:
//                                                                   '',
//                                                               reject_comment:
//                                                                   '',
//                                                               hold_comment: '',
//                                                               pending_comment:
//                                                                   '',
//                                                               check_out_comment:
//                                                                   '',
//                                                               completed_comment:
//                                                                   '',
//                                                               reopen_comment:
//                                                                   '',
//                                                               reassign_comment:
//                                                                   textReassignController
//                                                                       .text,
//                                                               solution: "",
//                                                               comment: '')
//                                                           .then((value) {
//                                                         if (value.isError ==
//                                                             false) {
//                                                           Navigator.of(context).pushReplacement(MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   TicketDetailsScreen(
//                                                                       ticketNumber: widget
//                                                                           .ticketNumber
//                                                                           .toString())));
//                                                         }
//                                                         showMessage(
//                                                             context: context,
//                                                             isError:
//                                                                 value.isError!,
//                                                             responseMessage:
//                                                                 value.message!);
//                                                       });
//                                                     },
//                                                     style: ElevatedButton
//                                                         .styleFrom(
//                                                       backgroundColor:
//                                                           Color.fromRGBO(
//                                                               21, 147, 159, 1),
//                                                     ),
//                                                     child: Text('Re Assign',
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                                 "Mulish",
//                                                             color:
//                                                                 Colors.white)),
//                                                   ),
//                                                 ],
//                                               );
//                                             },
//                                           );
//                                         }
//                                       : null, // Disable button if reassignBy3 is not empty
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor:
//                                         Color.fromRGBO(21, 147, 159, 1),
//                                   ),
//                                   child: Text(
//                                     'Re Assign',
//                                     style: TextStyle(
//                                         fontFamily: "Mulish",
//                                         color: Colors.white),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10.0),
//                     Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Column(
//                             children: [
//                               Card(
//                                 child: IconButton(
//                                   onPressed: () {
//                                     // final LoginId = SharedUtil().getLoginId;

//                                     // WorkLogRepository().getWorkLogList(context, {
//                                     //   "user_login_id": LoginId,
//                                     //   "ticket_id": widget.ticketNumber
//                                     // }).then((value) {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => WorkLogScreen(
//                                               ticketNo: widget.ticketNumber,
//                                               status:
//                                                   breakdownDetail.status ?? ""),
//                                         ));
//                                     // });
//                                   },
//                                   icon: const Icon(Icons.description_sharp),
//                                   color:
//                                       Color.fromRGBO(30, 152, 165, 1),
//                                 ),
//                               ),
//                               const Text('Work Log')
//                             ],
//                           ),
//                           if (is_mttr == 'yes' &&
//                               breakdownDetail.status != 'Accept') ...[
//                             SizedBox(width: 20.0),
//                             Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Card(
//                                   child: IconButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => MTTRScreen(
//                                             asset_group_id: breakdownDetail
//                                                 .assetGroupId
//                                                 .toString(),
//                                             ticketNumber:
//                                                 breakdownDetail.id.toString(),
//                                             downTime: breakdownDetail
//                                                 .downtimeDuration
//                                                 .toString(),
//                                             status: breakdownDetail.status
//                                                 .toString(),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     icon: Icon(Icons.timelapse_sharp),
//                                     color:
//                                         Color.fromRGBO(30, 152, 165, 1),
//                                   ),
//                                 ),
//                                 Text('MTTR'),
//                               ],
//                             ),
//                           ],
//                           if (breakdownDetail.status != 'Accept') ...[
//                             SizedBox(width: 20.0),
//                             Column(
//                               children: [
//                                 Card(
//                                   child: IconButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => SpareEditScreen(
//                                             ticketNumber:
//                                                 breakdownDetail.id!.toString(),
//                                             asset_id: breakdownDetail.assetId!
//                                                 .toString(),
//                                             asset_group_id: breakdownDetail
//                                                 .assetGroupId!
//                                                 .toString(),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     icon: Icon(Icons.handyman_outlined),
//                                     color:
//                                         Color.fromRGBO(30, 152, 165, 1),
//                                   ),
//                                 ),
//                                 Text('Replace Spares'),
//                               ],
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 16.0),
//                     Center(
//                       child: SizedBox(
//                         width:
//                             300, // Adjust this width based on design requirements
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Flexible(
//                               fit: FlexFit.loose,
//                               child: TicketInfoCardWidget(
//                                 title: 'Check In Time',
//                                 value: DateFormat('yyyy-MM-dd HH:mm').format(
//                                   DateTime.parse(
//                                       breakdownDetail.checkInTime.toString()),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10.0),
//                     Center(
//                       child: SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.9,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             ElevatedButton(
//                               onPressed: (breakdownDetail.status == 'Accept' ||
//                                       breakdownDetail.status == 'On Hold' ||
//                                       breakdownDetail.status == 'Pending')
//                                   ? () {
//                                       ApiService()
//                                           .TicketAccept(
//                                               ticketNo: widget.ticketNumber
//                                                   .toString(),
//                                               status_id: '6',
//                                               priority: '',
//                                               assign_type: '',
//                                               downtime_val: '',
//                                               open_comment: '',
//                                               assigned_comment: '',
//                                               accept_comment: '',
//                                               reject_comment: '',
//                                               hold_comment: '',
//                                               pending_comment: '',
//                                               check_out_comment: '',
//                                               completed_comment: '',
//                                               reopen_comment: '',
//                                               reassign_comment: '',
//                                               solution: "",
//                                               comment: '')
//                                           .then((value) {
//                                         if (value.isError == false) {
//                                           Navigator.of(context)
//                                               .pushAndRemoveUntil(
//                                             MaterialPageRoute(
//                                               builder: (ctx) =>
//                                                   const BottomNavScreen(),
//                                             ),
//                                             (route) => false,
//                                           );
//                                         }
//                                         showMessage(
//                                             context: context,
//                                             isError: value.isError!,
//                                             responseMessage: value.message!);
//                                         value.message;
//                                       });
//                                     }
//                                   : null, // Disable the button if the status is not 'accept' or 'on hold'
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: (breakdownDetail.status ==
//                                             'Accept' ||
//                                         breakdownDetail.status == 'On Hold' ||
//                                         breakdownDetail.status == 'Pending')
//                                     ? Colors.red
//                                     : Colors.grey, // Disable color change
//                               ),
//                               child: Text(
//                                 'CHECK IN',
//                                 style: TextStyle(
//                                     fontFamily: "Mulish", color: Colors.white),
//                               ),
//                             ),
//                             SizedBox(width: 10.0),
//                             ElevatedButton(
//                               onPressed: (breakdownDetail.status == 'Check In')
//                                   ? () => selectStatus(context,
//                                       data: breakdownDetail.toJson())
//                                   : null, // Disable the button if status is not 'checkin'
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor:
//                                     (breakdownDetail.status == 'Check In')
//                                         ? Colors.red
//                                         : Colors.grey, // Disable color change
//                               ),
//                               child: Text(
//                                 'CHECK OUT',
//                                 style: TextStyle(
//                                     fontFamily: "Mulish", color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10.0),
//                     Align(
//                         alignment: Alignment.topLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 10.0),
//                           child: Text(
//                             'Ticket details',
//                             style: TextStyle(
//                                 fontFamily: "Mulish",
//                                 color: Color.fromRGBO(21, 147, 159, 1),
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         )),
//                     SizedBox(height: 10.0),
//                     Card(
//                       color: Colors.white,
//                       elevation: 3,
//                       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                       child: Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Column(children: [
//                           TicketInfoCardWidget(
//                             title: 'Category',
//                             value: breakdownDetail.breakdownCategory ??
//                                 'N/A', // Accessing safely
//                           ),
//                           SizedBox(height: 5.0),
//                           TicketInfoCardWidget(
//                             title: 'Issue',
//                             value: breakdownDetail.breakdownCategory ??
//                                 'N/A', // Accessing safely
//                           ),
//                           SizedBox(height: 5.0),
//                           TicketInfoCardWidget(
//                             title: 'Ticket Number',
//                             value: breakdownDetail.ticketNo ??
//                                 'N/A', // Accessing safely
//                           ),
//                           SizedBox(height: 5.0),
//                           TicketInfoCardWidget(
//                             title: 'Raised By',
//                             value: breakdownDetail.createdBy ??
//                                 'N/A', // Accessing safely
//                           ),
//                           SizedBox(height: 5.0),
//                           TicketInfoCardWidget(
//                             title: 'Raised Date',
//                             value: breakdownDetail.createdOn != null
//                                 ? DateFormat('yyyy-MM-dd HH:mm').format(
//                                     DateTime.parse(breakdownDetail.createdOn
//                                             .toString())
//                                         .toLocal())
//                                 : 'N/A', // Assuming createdOn is a string
//                           ),
//                           SizedBox(height: 5.0),
//                           TicketInfoCardWidget(
//                             title: 'Status',
//                             value: breakdownDetail.status ??
//                                 'N/A', // Accessing safely
//                           ),
//                         ]),
//                       ),
//                     ),
//                     const SizedBox(height: 10.0),
//                     const Align(
//                         alignment: Alignment.topLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 10.0),
//                           child: Text(
//                             'Asset details',
//                             style: TextStyle(
//                                 fontFamily: "Mulish",
//                                 color: Color.fromRGBO(21, 147, 159, 1),
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         )),
//                     const SizedBox(height: 10.0),
//                     Card(
//                         color: Colors.white,
//                         elevation: 3,
//                         margin:
//                             EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                         child: Padding(
//                             padding: EdgeInsets.all(10),
//                             child: Column(children: [
//                               TicketInfoCardWidget(
//                                 title: 'Asset Status',
//                                 value: breakdownDetail.machineStatus
//                                     .toString(), // Accessing safely
//                               ),
//                               SizedBox(height: 5.0),
//                               TicketInfoCardWidget(
//                                 title: 'Asset Name',
//                                 value: breakdownDetail.asset ??
//                                     'N/A', // Accessing safely
//                               ),
//                               SizedBox(height: 5.0),
//                               TicketInfoCardWidget(
//                                 title: 'Asset Group',
//                                 value: breakdownDetail.assetGroupName ?? 'N/A',
//                               ),
//                               SizedBox(height: 5.0),
//                               TicketInfoCardWidget(
//                                 title: 'Asset Model',
//                                 value: breakdownDetail.assetNo ?? 'N/A',
//                               ),
//                               SizedBox(height: 5.0),
//                               TicketInfoCardWidget(
//                                 title: 'Location',
//                                 value: breakdownDetail.location?.toString() ??
//                                     'N/A',
//                               ),
//                               SizedBox(height: 5.0),
//                             ])))
//                   ],
//                 ),
//               ),
//             );
//           } else {
//             return Center(
//               child: NoDataScreen(),
//             );
//           }
//         },
//       ),
//     );
//   }

//   TextEditingController textCategoryController = TextEditingController();
//   TextEditingController textSubCategoryController = TextEditingController();
//   String selectedMainCategoryId = '';
//   String selectedSubCategoryId = '';

//   Future<dynamic> selectStatus(BuildContext context,
//       {required Map<String, dynamic> data}) {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierColor: Colors.black.withOpacity(.6),
//       builder: (BuildContext context) {
//         TextEditingController textFieldController = TextEditingController();
//         String selectedStatus = '8';
//         logger.d(data["breakdown_category_id"]);
//         logger.d(data["breakdown_sub_category_id"]);
//         // List<MainBreakdownCategoryLists> filteredItems =
//         //     MainBreakdownCategoryLists();
//         // textCategoryController.text=
//         return Container(
//           width: context.widthFull(),
//           child: Dialog(
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text('Select Status',
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: "Mulish")),
//                   HeightFull(),
//                   DropdownButtonFormField<String>(
//                     value: selectedStatus,
//                     onChanged: (value) {
//                       logger.e(data);
//                       setState(() {
//                         selectedStatus = value!;
//                       });
//                     },
//                     items: [
//                       DropdownMenuItem(
//                         // value: '17',
//                         // child: Text('Await RCA'),
//                         value: '8',
//                         child: Text('Hold'),
//                       ),
//                       DropdownMenuItem(
//                         value: '9',
//                         child: Text('Pending'),
//                       ),
//                       DropdownMenuItem(
//                         value: 'Completed',
//                         child: Text('Completed'),
//                       ),
//                     ],
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                           borderSide: BorderSide(color: Colors.black)),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide(color: Colors.black),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide(color: Colors.black),
//                       ),
//                     ),
//                     style: TextStyle(fontFamily: "Mulish", color: Colors.black),
//                     iconEnabledColor: Colors.black,
//                   ),
//                   SizedBox(height: 10.0),
//                   TextField(
//                     controller: textCategoryController,
//                     readOnly: true,
//                     onTap: () async {
//                       // Show the CustomSearchDialog and get the selected asset
//                       final MainBreakdownCategoryLists? result =
//                           await showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return MainCategoryDialog();
//                         },
//                       );
//                       if (result != null) {
//                         setState(() {
//                           textCategoryController.text =
//                               result.breakdownCategoryName.toString();
//                           selectedMainCategoryId =
//                               result.breakdownCategoryId.toString();
//                         });
//                         logger.i(
//                             'Breakdown Category ID: ${result.breakdownCategoryId}');
//                       }
//                     },
//                     decoration: const InputDecoration(
//                       // labelText: 'Select Breakdown Category',
//                       hintText: "Select Breakdown Category",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                   TextField(
//                     controller: textSubCategoryController,
//                     readOnly: true,
//                     onTap: () async {
//                       final BreakdownCategoryLists? result = await showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return SubCategoryDialog();
//                         },
//                       );
//                       if (result != null) {
//                         setState(() {
//                           textSubCategoryController.text =
//                               result.breakdownSubCategory.toString();
//                           selectedSubCategoryId =
//                               result.breakdownSubCategoryId.toString();
//                         });
//                         logger.i(
//                             'Breakdown SubCategory ID: ${result.breakdownCategoryId}');
//                       }
//                     },
//                     decoration: const InputDecoration(
//                       // labelText: 'Select Breakdown',
//                       hintText: "Select Breakdown",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                   TextField(
//                     controller: textFieldController,
//                     decoration: InputDecoration(
//                       labelText: 'Enter Reason',
//                       labelStyle:
//                           TextStyle(fontFamily: "Mulish", color: Colors.black),
//                       border: OutlineInputBorder(
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(15.0))),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide(color: Colors.black),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide(color: Colors.black),
//                       ),
//                     ),
//                     style: TextStyle(fontFamily: "Mulish", color: Colors.black),
//                   ),
//                   HeightFull(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(
//                               fontFamily: "Mulish", color: Colors.black),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (textFieldController.text.isEmpty) {
//                             return showMessage(
//                                 context: context,
//                                 isError: true,
//                                 responseMessage: "Kindly enter reason");
//                           }
//                           logger.w(selectedStatus == 'Completed');
//                           if (selectedStatus == 'Completed') {
//                             // Navigate to WhyWhyScreen if selectedStatus is 'Completed'

//                             commonDialog(
//                                 context,
//                                 MyWidget(
//                                     ticketNumber: widget.ticketNumber,
//                                     comment: textFieldController.text));
//                           } else {
//                             // Call your API here for other statuses

//                             ApiService()
//                                 .TicketAccept(
//                                     ticketNo: widget.ticketNumber.toString(),
//                                     status_id: selectedStatus == 'completed'
//                                         ? ''
//                                         : selectedStatus,
//                                     priority: '',
//                                     assign_type: '',
//                                     downtime_val: '',
//                                     open_comment: '',
//                                     assigned_comment: '',
//                                     accept_comment: '',
//                                     reject_comment: '',
//                                     hold_comment: textFieldController.text,
//                                     pending_comment: textFieldController.text,
//                                     check_out_comment: textFieldController.text,
//                                     completed_comment: textFieldController.text,
//                                     reopen_comment: '',
//                                     reassign_comment: '',
//                                     solution: "",
//                                     comment: '')
//                                 .then((value) {
//                               if (value.isError == false) {
//                                 Navigator.of(context).pushAndRemoveUntil(
//                                   MaterialPageRoute(
//                                     builder: (ctx) => const BottomNavScreen(),
//                                   ),
//                                   (route) => false,
//                                 );
//                               }
//                               showMessage(
//                                   context: context,
//                                   isError: value.isError!,
//                                   responseMessage: value.message!);
//                               value.message;
//                             });
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color.fromRGBO(21, 147, 159, 1),
//                         ),
//                         child: Text(
//                           'Submit',
//                           style: TextStyle(
//                               fontFamily: "Mulish", color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class MyWidget extends StatefulWidget {
  const MyWidget(
      {super.key,
      required this.ticketNumber,
      required this.comment,
      required this.categoryId,
      required this.subCategoryId, required this.ticketFrom});
  final String ticketNumber, categoryId, subCategoryId,ticketFrom;
  final String comment;

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(Icons.crisis_alert, color: Colors.red.withOpacity(.5), size: 28),
      HeightHalf(),
      TextCustom(
        "Alert!",
        color: Palette.dark,
        size: 20,
        fontWeight: FontWeight.w600,
      ),
      HeightHalf(),
      TextCustom(
        "Do you want to Enter the Solution Bank ?",
        size: 16,
        fontWeight: FontWeight.w600,
      ),
      HeightFull(),
      Row(children: [
        WidthFull(),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WhyWhyScreen(
                      ticketNumber: widget.ticketNumber,
                      comment: widget.comment,
                      categoryId: widget.categoryId,
                      subCategoryId: widget.subCategoryId, ticketFrom: widget.ticketFrom),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.green),
              padding: EdgeInsets.all(8),
              child: Center(
                  child: TextCustom("Enter Now",
                      size: 15, color: Colors.white, align: TextAlign.center)),
            ),
          ),
        ),
        WidthFull(),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WhyWhyScreen(
                    ticketNumber: widget.ticketNumber,
                    categoryId: widget.categoryId,
                    subCategoryId: widget.subCategoryId,
                    comment: widget.comment,
                    isSolution: true, ticketFrom: widget.ticketFrom,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Palette.primary),
              padding: EdgeInsets.all(8),
              child: Center(
                  child: TextCustom(
                "Enter Later",
                size: 15,
                color: Colors.white,
                align: TextAlign.center,
              )),
            ),
          ),
        ),
        WidthFull(),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WhyWhyScreen(
                    ticketNumber: widget.ticketNumber,
                    categoryId: widget.categoryId,
                    subCategoryId: widget.subCategoryId,
                    comment: widget.comment,
                    isComment: true,
                    isSolution: true, ticketFrom:widget.ticketFrom,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Palette.red),
              padding: EdgeInsets.all(8),
              child: Center(
                  child: TextCustom("No Need",
                      size: 15, color: Colors.white, align: TextAlign.center)),
            ),
          ),
        ),
        WidthFull(),
      ]),
      // DoubleButton(
      //     primaryLabel: "Ok",
      //     secondarylabel: "Cancel",
      //     primaryOnTap: () {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => WhyWhyScreen(
      //         ticketNumber: widget.ticketNumber,
      //         comment: widget.comment,
      //         categoryId: widget.categoryId,
      //         subCategoryId: widget.subCategoryId),
      //   ),
      // );
      //     },
      //     secondaryOnTap: () {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => WhyWhyScreen(
      //       ticketNumber: widget.ticketNumber,
      //       categoryId: widget.categoryId,
      //       subCategoryId: widget.subCategoryId,
      //       comment: widget.comment,
      //       isSolution: true,
      //     ),
      //   ),
      // );
      //     })
    ]);
  }
}
