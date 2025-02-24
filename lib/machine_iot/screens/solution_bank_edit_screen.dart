import 'dart:convert';

import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/screens/custom_search_dialog.dart';
import 'package:auscurator/machine_iot/screens/why_why_screen.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/model/TicketDetailModel.dart';
import 'package:auscurator/model/root_cause_model.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:auscurator/provider/breakkdown_provider.dart';
import 'package:auscurator/repository/breakdown_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SolutionBankEditScreen extends StatefulWidget {
  const SolutionBankEditScreen(
      {super.key, required this.ticketNumber, this.status, required this.ticketFrom});
  final String ticketNumber,ticketFrom;
  final String? status;

  @override
  State<SolutionBankEditScreen> createState() => _SolutionBankEditScreenState();
}

class _SolutionBankEditScreenState extends State<SolutionBankEditScreen> {
  // List to hold TextEditingControllers for Why and Answer pairs
  final List<TextEditingController> whyControllers = [];
  final List<TextEditingController> answerControllers = [];

  // TextEditingControllers for Root Cause, Solution, and Remark
  TextEditingController rootCauseController = TextEditingController();
   TextEditingController solutionController = TextEditingController();
   TextEditingController remarkController = TextEditingController();

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((callback) {
    //   BreakdownRepository()
    //       .getBreakDownDetailList(context, ticket_no: widget.ticketNumber);
    // });
    List<RootCauseList> data =
        breakProvider.rootCauseData?.rootCauseLists ?? [];
    final rootCause = data.isNotEmpty
        ? data.firstWhere(
            (e) =>
                "${e.refId}" ==
                "${breakProvider.ticketDetailData?.breakdownDetailList?[0].rootCauseId}",
            orElse: () => RootCauseList(),
          )
        : null;
    logger.e(rootCause?.toJson());
    rootCauseController.text =rootCause?.rootCauseCode==null||rootCause?.rootCauseName==null?"":
        "${rootCause?.rootCauseCode} - ${rootCause?.rootCauseName}";

try {
            var rootCause = breakProvider.rootCauseData?.rootCauseLists
                .firstWhere((e) =>
                    "${e.refId}" ==
                    "${breakProvider.ticketDetailData?.breakdownDetailList?[0].rootCauseId}");
            logger.e(rootCause?.toJson());
            rootCauseController.text =
                "${rootCause?.rootCauseCode} - ${rootCause?.rootCauseName}";

                selectedRootCauseId="${rootCause?.refId}";
          } catch (e) {
            // logger.e("No matching RootCauseList found.");
          }

    // Initialize 5 controllers for Why and Answer pairs
    for (int i = 0; i < 5; i++) {
      whyControllers.add(TextEditingController());
      answerControllers.add(TextEditingController());
    }

    super.initState();
  }

  String selectedRootCauseId = "";
  String selectedAbnormality = "";
   TextEditingController abnormalityController = TextEditingController();



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

  bool isEdit = true;

  void isAction() {
    isEdit = !isEdit;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final ticketFuture = ref.watch(apiServiceProvider).getBreakDownDetailList(
    //       ticket_no: widget.ticketNumber,
    //     );

    return Consumer<BreakkdownProvider>(
      builder: (context, break1, child) {
        BreakdownDetailList breakdownDetail =
            break1.ticketDetailData?.breakdownDetailList?[0] ??
                BreakdownDetailList();
                logger.e(breakdownDetail.toJson());
        // Update controllers with data from API
        whyControllers[0].text = breakdownDetail.why1 ?? '';
        answerControllers[0].text = breakdownDetail.action1 ?? '';
        whyControllers[1].text = breakdownDetail.why2 ?? '';
        answerControllers[1].text = breakdownDetail.action2 ?? '';
        whyControllers[2].text = breakdownDetail.why3 ?? '';
        answerControllers[2].text = breakdownDetail.action3 ?? '';
        whyControllers[3].text = breakdownDetail.why4 ?? '';
        answerControllers[3].text = breakdownDetail.action4 ?? '';
        whyControllers[4].text = breakdownDetail.why5 ?? '';
        answerControllers[4].text = breakdownDetail.action5 ?? '';
        if (widget.status == "Fixed") {
          rootCauseController.text = breakdownDetail.rootCause ?? '';
        } 
        solutionController.text = breakdownDetail.solution ?? '';
        remarkController.text = breakdownDetail.remarks ?? '';
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Why-Why Analysis',
              style: TextStyle(fontFamily: "Mulish", color: Colors.white),
            ),
            backgroundColor: Color.fromRGBO(30, 152, 165, 1),
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            actions: [
              // InkWell(
              //   splashFactory: NoSplash.splashFactory,
              //   splashColor: Colors.transparent,
              //   highlightColor: Colors.transparent,
              //   onTap: () => isAction(),
              //   child: Container(
              //     margin: EdgeInsets.only(right: 12),
              //     padding: EdgeInsets.all(2),
              //     width: 55,
              //     height: 30,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(16),
              //         color: isEdit ? Colors.green : Colors.white),
              //     child: Row(
              //       mainAxisAlignment:
              //           isEdit ? MainAxisAlignment.end : MainAxisAlignment.start,
              //       children: [
              //         Container(
              //           height: 26,
              //           width: 26,
              //           decoration: BoxDecoration(
              //               shape: BoxShape.circle,
              //               color: isEdit ? Colors.white : Colors.grey),
              //         )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
          backgroundColor: const Color(0xF5F5F5F5),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: break1.isLoading
                ? SingleChildScrollView(
                    child: const Center(
                        child: Padding(
                      padding: EdgeInsets.all(15),
                      child: ShimmerLists(
                        count: 10,
                        width: double.infinity,
                        height: 65,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    )),
                  )
                : break1.ticketDetailData!.breakdownDetailList!.isEmpty
                    ? Center(child: NoDataScreen())
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
                                      enabled: widget.status == "Fixed"
                                          ? false
                                          : true,
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
                                          disabledBorder: UnderlineInputBorder(
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
                                      enabled: widget.status == "Fixed"
                                          ? false
                                          : true,
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
                                          disabledBorder: UnderlineInputBorder(
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
                          if (widget.status == "Fixed") ...[
                            _buildTextField(rootCauseController, 'Root Cause*'),
                          ] else ...[
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
                          ],
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
                          widget.status == "Fixed"
                              ? SizedBox.shrink()
                              : ElevatedButton(
                                  onPressed: () {
                                    if (whyControllers[0].text.isEmpty ||
                                        answerControllers[0].text.isEmpty ||
                                        rootCauseController.text.isEmpty ||
                                        solutionController.text.isEmpty) {
                                      showMessage(
                                          context: context,
                                          isError: true,
                                          responseMessage:
                                              'Please Fill Mandatory Fields');
                                    } else {
                                      final jsonString = _generateJson();
                                      print(jsonString);
                                      print(widget.ticketNumber.toString());
                                      ApiService()
                                          .SaveSolutionBank(
                                              ticketNo: widget.ticketNumber
                                                  .toString(),
                                              solution_bank: jsonString)
                                          .then((value) {
                                        if (value.isError == false) {}
                                        Navigator.of(context).pop();
                                        BreakdownRepository().getBreakDownDetailList(context,ticket_no: widget.ticketNumber.toString());
                                        showMessage(
                                            context: context,
                                            isError: value.isError!,
                                            responseMessage:
                                                "Data Saved Successfully...!");
                                        value.message;
                                      });
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
                        ],
                      ),
          ),
        );
      },
    );
  }

  // Helper function to create TextFields for single values
  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        enabled: widget.status == "Fixed" ? false : true,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              fontFamily: "Mulish",
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(20),
            ),
            disabledBorder: UnderlineInputBorder(
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
