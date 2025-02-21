// ignore_for_file: unused_local_variable

import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/bottom_navigation/bottomnavscreen.dart';
import 'package:auscurator/components/no_data_animation.dart';

import 'package:auscurator/machine_iot/util.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/model/TicketDetailModel.dart';
import 'package:auscurator/model/engineer_overall_model.dart';
import 'package:auscurator/screens/breakdown/widgets/segmented_priority.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auscurator/machine_iot/widget/ticket_info_cart_widget.dart';

class AssignTechnician extends ConsumerStatefulWidget {
  final BreakdownDetailList ticketDetails;
  final String? companyId, buId, plantId, deptId;

  const AssignTechnician({
    super.key,
    required this.ticketDetails,
    this.companyId,
    this.buId,
    this.plantId,
    this.deptId,
  });
  @override
  ConsumerState createState() => _AssignScreenState();
}

class _AssignScreenState extends ConsumerState<AssignTechnician> {
  List<ValueNotifier<bool>> checkboxes = []; // List to hold checkbox states
  String? selectedEmployeeId; // Store the currently selected employee ID
  String selectedPriority = 'Low';
  @override
  void initState() {
    super.initState();
    checkConnection(context); // Assuming this checks for internet connection
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final employeeListFuture = ref
        .watch(apiServiceProvider)
        .getEngineerOverallList(
            companyId: widget.companyId ?? '',
            buId: widget.buId ?? "",
            plantId: widget.plantId ?? '',
            deptId: widget.deptId ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assign Technician',
          style: TextStyle(fontFamily: "Mulish", color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    // Ticket and issue information
                    Row(children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'TicketNumber :',
                          style: TextStyle(
                              fontFamily: "Mulish",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(21, 147, 159, 1)),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          '${widget.ticketDetails.ticketNo}',
                          style: const TextStyle(
                              fontFamily: "Mulish", color: Colors.black),
                        ),
                      ),
                    ]),
                    // Issue and priority information
                    Row(children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'issue :',
                          style: TextStyle(
                              fontFamily: "Mulish",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(21, 147, 159, 1)),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          '${widget.ticketDetails.breakdownCategory}',
                          style: const TextStyle(
                              fontFamily: "Mulish", color: Colors.black),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10.0),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Priority',
                          style: TextStyle(
                              fontFamily: "Mulish",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(21, 147, 159, 1)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SegmentedControlPriority(
                      onPriorityChanged: (String priority) {
                        setState(() {
                          selectedPriority = priority;
                        });
                      },
                    ),
                    // Employee list
                    FutureBuilder(
                      future: employeeListFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: ShimmerLists(
                                count: 3,
                                width: double.infinity,
                                height: 200,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                            ),
                          );
                        }
                        if (snapshot.data == null ||
                            snapshot.data!.departmentEngineerLists == null ||
                            snapshot.data!.departmentEngineerLists!.isEmpty) {
                          return Center(
                            child: NoDataScreen(),
                          );
                        }

                        List<DepartmentEngineerLists> employeeList =
                            snapshot.data!.departmentEngineerLists!;

                        // Initialize checkboxes for each employee
                        checkboxes = List.generate(
                          employeeList.length,
                          (index) => ValueNotifier(
                            selectedEmployeeId ==
                                employeeList[index].employeeId,
                          ),
                        );

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: employeeList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                color: Colors.white,
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          ValueListenableBuilder<bool>(
                                            valueListenable: checkboxes[index],
                                            builder: (context, value, child) {
                                              return Checkbox(
                                                checkColor: Colors.white,
                                                value: value,
                                                onChanged: (bool? newValue) {
                                                  if (newValue != null) {
                                                    // Uncheck all other checkboxes
                                                    for (int i = 0;
                                                        i < checkboxes.length;
                                                        i++) {
                                                      if (i != index) {
                                                        checkboxes[i].value =
                                                            false;
                                                      }
                                                    }
                                                    // Update the selected employee ID
                                                    selectedEmployeeId =
                                                        newValue
                                                            ? employeeList[
                                                                    index]
                                                                .employeeId
                                                                .toString()
                                                            : null;
                                                    checkboxes[index].value =
                                                        newValue;
                                                    print(selectedEmployeeId);
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              "${employeeList[index].employee.toString()}",
                                              style: const TextStyle(
                                                fontFamily: "Mulish",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      // TicketInfoCardWidget(
                                      //     title: 'Skill set',
                                      //     value: employeeList[index]
                                      //         .employeeSkill
                                      //         .toString()),
                                      // const SizedBox(height: 8),
                                      TicketInfoCardWidget(
                                          title: 'Department',
                                          value: employeeList[index]
                                              .departmentName
                                              .toString()),
                                      const SizedBox(height: 8),
                                      // TicketInfoCardWidget(
                                      //     title: 'Completed', value: '3'),
                                      // const SizedBox(height: 8),
                                      // TicketInfoCardWidget(
                                      //     title: 'Accept', value: '2'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                ApiService()
                    .AssignEngineer(
                        ticketNo: widget.ticketDetails.id.toString(),
                        status_id: '2',
                        priority: selectedPriority,
                        engineer_id: selectedEmployeeId.toString(),
                        assign_type: 'Single',
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
                        comment: '')
                    .then((value) {
                  if (value.isError == false) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (ctx) => const BottomNavScreen(),
                      ),
                      (route) => false,
                    );
                  }
                  showMessage(
                      context: context,
                      isError: value.isError!,
                      responseMessage: value.message!);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(21, 147, 159, 1),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontFamily: "Mulish", color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
