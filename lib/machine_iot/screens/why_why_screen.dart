import 'dart:convert';

import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/bottom_navigation/bottomnavscreen.dart';
import 'package:auscurator/machine_iot/screens/MTTRScreen.dart';
import 'package:auscurator/machine_iot/screens/custom_search_dialog.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/model/root_cause_model.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/widgets/context_extension.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WhyWhyScreen extends ConsumerStatefulWidget {
  final String ticketNumber, categoryId, subCategoryId, ticketFrom;
  final String comment;
  final bool? isSolution, isComment;

  const WhyWhyScreen({
    super.key,
    required this.ticketNumber,
    required this.ticketFrom,
    required this.comment,
    this.isComment,
    required this.categoryId,
    required this.subCategoryId,
    this.isSolution,
  });
  @override
  ConsumerState<WhyWhyScreen> createState() => _WhyWhyScreenState();
}

class _WhyWhyScreenState extends ConsumerState<WhyWhyScreen> {
  // List to hold TextEditingControllers for Why and Answer pairs
  final List<TextEditingController> whyControllers = [];
  final List<TextEditingController> answerControllers = [];

  // TextEditingControllers for Root Cause, Solution, and Remark
  late TextEditingController rootCauseController;
  late TextEditingController abnormalityController;
  late TextEditingController solutionController;
  late TextEditingController remarkController;
  TextEditingController checkoutSolutionController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 5; i++) {
      whyControllers.add(TextEditingController());
      answerControllers.add(TextEditingController());
    }

    rootCauseController = TextEditingController();
    abnormalityController = TextEditingController();
    solutionController = TextEditingController();
    remarkController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in whyControllers) {
      controller.dispose();
    }
    for (var controller in answerControllers) {
      controller.dispose();
    }
    rootCauseController.dispose();
    abnormalityController.dispose();
    solutionController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  String selectedRootCauseId = "";
  String selectedAbnormality = "";

  final isMttr = SharedUtil().getisMttr;
  final isDownTime = SharedUtil().getisdowntime;

  @override
  Widget build(BuildContext context) {
    bool isSoln = widget.isSolution ?? false;
    bool iscomment = widget.isComment ?? false;
    logger.e(widget.ticketFrom);
    final ticketFuture = ref.watch(apiServiceProvider).getBreakDownDetailList(
          ticket_no: widget.ticketNumber,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSoln ? "Check Out" : 'Why-Why ',
          style: TextStyle(fontFamily: "Mulish", color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        leading: InkWell(
            onTap: () {
              // if (isSoln) {
              Navigator.of(context)
                ..pop()
                ..pop();
              // }
            },
            child: Icon(Icons.arrow_back)),
        actions: [
          // IconButton(
          //     onPressed: isSoln && checkoutSolutionController.text.isEmpty
          //         ? () {
          //             showMessage(
          //                 context: context,
          //                 isError: true,
          //                 responseMessage: "Kindly enter the solution");
          //           }
          //         : isSoln && commentController.text.isEmpty && iscomment
          //             ? () {
          //                 showMessage(
          //                     context: context,
          //                     isError: true,
          //                     responseMessage: "Kindly enter the comment");
          //               }
          //             : () {
          //                 showDialog(
          //                   context: context,
          //                   builder: (BuildContext context) {
          //                     return AlertDialog(
          //                       backgroundColor: Colors.white,
          //                       title: const Text('Check out'),
          //                       content: const Text(
          //                           'Are you sure you want Check out ?'),
          //                       actions: [
          //                         TextButton(
          //                           onPressed: () {
          //                             Navigator.of(context).pop();
          //                           },
          //                           child: const Text('Cancel'),
          //                         ),
          //                         TextButton(
          //                           onPressed: () {
          //                             ApiService()
          //                                 .TicketAccept(
          //                                     ticketNo: widget.ticketNumber
          //                                         .toString(),
          //                                     status_id: '10',
          //                                     priority: '',
          //                                     assign_type: '',
          //                                     downtime_val: '',
          //                                     open_comment: '',
          //                                     assigned_comment: '',
          //                                     accept_comment: '',
          //                                     reject_comment: '',
          //                                     hold_comment: '',
          //                                     pending_comment: '',
          //                                     check_out_comment: widget.comment,
          //                                     completed_comment: widget.comment,
          //                                     reopen_comment: '',
          //                                     reassign_comment: '',
          //                                     solution:
          //                                         checkoutSolutionController
          //                                             .text,
          //                                     comment: '',
          //                                     breakdown_category_id:
          //                                         widget.categoryId,
          //                                     breakdown_subcategory_id:
          //                                         widget.subCategoryId)
          //                                 .then((value) {
          //                               if (value.isError == false) {
          //                                 Navigator.of(context)
          //                                     .pushAndRemoveUntil(
          //                                   MaterialPageRoute(
          //                                     builder: (ctx) =>
          //                                         const BottomNavScreen(),
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
          //                           },
          //                           child: const Text('Check out'),
          //                         ),
          //                       ],
          //                     );
          //                   },
          //                 );
          //               },
          //     icon: const Icon(Icons.logout, color: Colors.red))
        ],
      ),
      backgroundColor: const Color(0xF5F5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: FutureBuilder(
            future: ticketFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SingleChildScrollView(
                  child: const Center(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: ShimmerLists(
                      count: 10,
                      width: double.infinity,
                      height: 65,
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
                  return const Center(child: Text('No data available'));
                }

                // Accessing the first item of breakdownDetailList safely
                final breakdownDetail = ticketDetails.breakdownDetailList![0];
                // // Update controllers with data from API
                // whyControllers[0].text = breakdownDetail.why1 ?? '';
                // answerControllers[0].text = breakdownDetail.action1 ?? '';
                // whyControllers[1].text = breakdownDetail.why2 ?? '';
                // answerControllers[1].text = breakdownDetail.action2 ?? '';
                // whyControllers[2].text = breakdownDetail.why3 ?? '';
                // answerControllers[2].text = breakdownDetail.action3 ?? '';
                // whyControllers[3].text = breakdownDetail.why4 ?? '';
                // answerControllers[3].text = breakdownDetail.action4 ?? '';
                // whyControllers[4].text = breakdownDetail.why5 ?? '';
                // answerControllers[4].text = breakdownDetail.action5 ?? '';
                // if (breakdownDetail.rootCause != "") {
                //   rootCauseController.text = breakdownDetail.rootCause ?? '';
                // }
                // solutionController.text = breakdownDetail.solution ?? '';
                // remarkController.text = breakdownDetail.remarks ?? '';
                return isSoln
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            TextField(
                              controller: checkoutSolutionController,
                              decoration: InputDecoration(
                                  labelText: "Solution",
                                  labelStyle: TextStyle(
                                    fontFamily: "Mulish",
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                            HeightFull(),
                            isSoln && iscomment
                                ? Column(children: [
                                    TextField(
                                      controller: commentController,
                                      decoration: InputDecoration(
                                          labelText: "Comment",
                                          labelStyle: TextStyle(
                                            fontFamily: "Mulish",
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                    ),
                                    HeightFull(),
                                  ])
                                : SizedBox.shrink(),
                            SizedBox(
                              width: context.widthFull(),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (checkoutSolutionController.text.isEmpty) {
                                    showMessage(
                                        context: context,
                                        isError: true,
                                        responseMessage:
                                            "kindly enter solution");
                                  } else {
                                    showMessage(
                                        context: context,
                                        isError: false,
                                        responseMessage:
                                            "You Can Now Check-Out...!");
                                    setState(() {});
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(30, 152, 165, 1),
                                ),
                                child: const Text('Save',
                                    style: TextStyle(
                                        fontFamily: "Mulish",
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 50),
                                  child: Text(
                                    "Why",
                                    style: TextStyle(
                                        fontFamily: "Mulish",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 50),
                                  child: Text(
                                    "Answer",
                                    style: TextStyle(
                                        fontFamily: "Mulish",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          for (int i = 0; i < 5; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: whyControllers[i],
                                      decoration: InputDecoration(
                                          labelText:
                                              '${i + 1}) ${i == 0 ? "Why*" : "Why"}',
                                          labelStyle: TextStyle(
                                            fontFamily: "Mulish",
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      cursorColor: const Color(0xFF018786),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: answerControllers[i],
                                      decoration: InputDecoration(
                                          labelText:
                                              '${i + 1}) ${i == 0 ? "Answer*" : "Answer"}',
                                          labelStyle: TextStyle(
                                            fontFamily: "Mulish",
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      cursorColor: const Color(0xFF018786),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 20),
                          // Additional fields
                          TextField(
                            controller: rootCauseController,
                            decoration: InputDecoration(
                                labelText: "Root Cause*",
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(20))),
                            readOnly: true,
                            onTap: () async {
                              // Show the CustomSearchDialog and get the selected asset
                              final RootCauseList? result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomdDropdownDialog();
                                },
                              );
                              // Check if a result was returned
                              if (result != null) {
                                rootCauseController.text =
                                    "${result.rootCauseCode} - ${result.rootCauseName}";
                                selectedRootCauseId = result.refId.toString();
                                setState(() {}); // Force UI update
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          // _buildTextField(rootCauseController, 'Root Cause*'),
                          _buildTextField(solutionController, 'Solution*'),
                          _buildTextField(remarkController, 'Remark'),
                          if (widget.ticketFrom != "CMMS") ...[
                            SizedBox(height: 10),
                            TextField(
                              controller: abnormalityController,
                              decoration: InputDecoration(
                                  labelText: "Abnormality Due To",
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(20))),
                              readOnly: true,
                              onTap: () async {
                                // Show the CustomSearchDialog and get the selected asset
                                final result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomAbnormalityDialog();
                                  },
                                );
                                // Check if a result was returned
                                if (result != null) {
                                  logger.i(result);
                                  abnormalityController.text =
                                      capitalizeFirstLetter(
                                          "${result["value"]}");
                                  selectedAbnormality =
                                      result["value"].toString();
                                  setState(() {}); // Force UI update
                                }
                              },
                            ),
                          ],
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (whyControllers[0].text.isEmpty ||
                                  answerControllers[0].text.isEmpty ||
                                  rootCauseController.text.isEmpty ||
                                  solutionController.text.isEmpty) {
                                if (mounted) {
                                  showMessage(
                                    context: context,
                                    isError: true,
                                    responseMessage:
                                        'Please Fill Mandatory Fields',
                                  );
                                }
                              } else {
                                final jsonString = _generateJson();
                                print(jsonString);
                                print(widget.ticketNumber.toString());
                                ApiService()
                                    .SaveSolutionBank(
                                        ticketNo:
                                            widget.ticketNumber.toString(),
                                        solution_bank: jsonString)
                                    .then((value) {
                                  if (mounted) {
                                    if (isMttr == "yes" ||
                                        isDownTime == "yes") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MTTRScreen(
                                            asset_group_id: breakdownDetail
                                                .assetGroupId
                                                .toString(),
                                            ticketNumber:
                                                breakdownDetail.id.toString(),
                                            downTime: breakdownDetail
                                                .downtimeDuration
                                                .toString(),
                                            status: breakdownDetail.status
                                                .toString(),
                                            isMttr: isMttr ?? '',
                                          ),
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              title: const Text('Check out'),
                                              content: const Text(
                                                  'Are you sure you want Check out ?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    ApiService()
                                                        .TicketAccept(
                                                            ticketNo: widget
                                                                .ticketNumber
                                                                .toString(),
                                                            status_id: '10',
                                                            priority: '',
                                                            assign_type: '',
                                                            downtime_val: '',
                                                            open_comment: '',
                                                            assigned_comment:
                                                                '',
                                                            accept_comment: '',
                                                            reject_comment: '',
                                                            hold_comment: '',
                                                            pending_comment: '',
                                                            check_out_comment:
                                                                widget.comment,
                                                            completed_comment:
                                                                widget.comment,
                                                            reopen_comment: '',
                                                            reassign_comment:
                                                                '',
                                                            solution:
                                                                checkoutSolutionController
                                                                    .text,
                                                            comment: '',
                                                            breakdown_category_id:
                                                                widget
                                                                    .categoryId,
                                                            breakdown_subcategory_id:
                                                                widget
                                                                    .subCategoryId,
                                                            checkin_comment: '',
                                                            abnormality:
                                                                selectedAbnormality,
                                                            planned_Date: '')
                                                        .then((value) {
                                                      if (mounted) {
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
                                                            isError:
                                                                value.isError!,
                                                            responseMessage:
                                                                value.message!);
                                                      }

                                                      value.message;
                                                    });
                                                  },
                                                  child:
                                                      const Text('Check out'),
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                  }

                                  // if (value.isError == false) {}
                                  // showMessage(
                                  //     context: context,
                                  //     isError: value.isError!,
                                  //     responseMessage:
                                  //         "${value.message!}\nYou Can NowCheck-Out...!");
                                  // value.message;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(30, 152, 165, 1),
                            ),
                            child: Text(isMttr == "yes" ? 'Save' : "Checkout",
                                style: TextStyle(
                                    fontFamily: "Mulish", color: Colors.white)),
                          ),
                        ],
                      );
              } else {
                return const Center(child: Text('No data available'));
              }
            }),
      ),
    );
  }

  

  // Helper function to create TextFields for single values
  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20))),
      ),
    );
  }

  // Method to generate the JSON from input data
  String _generateJson() {
    final data = {
      "why1": whyControllers[0].text,
      "why2": whyControllers[1].text,
      "why3": whyControllers[2].text,
      "why4": whyControllers[3].text,
      "why5": whyControllers[4].text,
      "action1": answerControllers[0].text,
      "action2": answerControllers[1].text,
      "action3": answerControllers[2].text,
      "action4": answerControllers[3].text,
      "action5": answerControllers[4].text,
      "issue": remarkController.text,
      "root_cause": selectedRootCauseId,
      "solution": solutionController.text,
      "remark": remarkController.text,
      "abnormality_due_to": selectedAbnormality
    };

    return jsonEncode([data]);
  }
}
String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }