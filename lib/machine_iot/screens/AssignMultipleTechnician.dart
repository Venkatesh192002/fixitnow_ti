import 'dart:convert';

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
import 'package:auscurator/machine_iot/widget/ticket_info_cart_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssignMultipleTechnician extends ConsumerStatefulWidget {
  final BreakdownDetailList ticketDetails;
  final String? companyId, buId, plantId, deptId;

  AssignMultipleTechnician({
    required this.ticketDetails,
    this.companyId,
    this.buId,
    this.plantId,
    this.deptId,
  });
  @override
  ConsumerState createState() => _AssignScreenState();
}

class _AssignScreenState extends ConsumerState<AssignMultipleTechnician> {
  @override
  void initState() {
    super.initState();
    checkConnection(context); // Assuming this checks for internet connection
  }

  int? selectedIndex; // Tracks the currently selected checkbox index
  List<ValueNotifier<bool>> checkboxes = []; // List to hold checkbox states
  String? selectedEmployeeId; // Store the currently selected employee ID
  List<Map<String, String>> selectedEmployees = [];
  String selectedPriority = 'Low';
  @override
  Widget build(BuildContext context) {
    final employeeListFuture = ref
        .watch(apiServiceProvider)
        .getEngineerOverallList(
            companyId: widget.companyId ?? '',
            buId: widget.buId ?? "",
            plantId: widget.plantId ?? '',
            deptId: widget.deptId ?? '');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assign Technician',
          style: TextStyle(fontFamily: "Mulish", color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
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
                    Row(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'TicketNumber :',
                            style: TextStyle(
                                fontFamily: "Mulish",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(21, 147, 159, 1)),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            '${widget.ticketDetails.ticketNo}',
                            style: TextStyle(
                                fontFamily: "Mulish", color: Colors.black),
                          ),
                        ),
                      )
                    ]),
                    Row(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'issue :',
                            style: TextStyle(
                                fontFamily: "Mulish",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(21, 147, 159, 1)),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            '${widget.ticketDetails.breakdownCategory}',
                            style: TextStyle(
                                fontFamily: "Mulish", color: Colors.black),
                          ),
                        ),
                      )
                    ]),
                    SizedBox(height: 10.0),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Priority',
                            style: TextStyle(
                                fontFamily: "Mulish",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(21, 147, 159, 1)),
                          ),
                        )),
                    SizedBox(height: 10.0),
                    SegmentedControlPriority(
                      onPriorityChanged: (String priority) {
                        setState(() {
                          selectedPriority =
                              priority; // Update the selected priority
                        });
                      },
                    ),
                    FutureBuilder(
                      future: employeeListFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SingleChildScrollView(
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.all(15),
                              child: ShimmerLists(
                                count: 3,
                                width: double.infinity,
                                height: 300,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                            )),
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
                        // Initialize ValueNotifiers for each employee
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
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setItemState) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 3,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter
                                                        setCheckboxState) {
                                                  return Checkbox(
                                                    checkColor: Colors.white,
                                                    value: selectedIndex ==
                                                            index ||
                                                        selectedEmployees.any((employee) =>
                                                            employee[
                                                                    'engineer_id'] ==
                                                                employeeList[
                                                                        index]
                                                                    .employeeId
                                                                    .toString() &&
                                                            employee[
                                                                    'is_owner'] ==
                                                                'no'),
                                                    onChanged:
                                                        (bool? newValue) {
                                                      setCheckboxState(() {
                                                        if (newValue == true) {
                                                          // Add to selectedEmployees if not already in the list
                                                          if (!selectedEmployees
                                                              .any(
                                                            (employee) =>
                                                                employee[
                                                                    'engineer_id'] ==
                                                                employeeList[
                                                                        index]
                                                                    .employeeId
                                                                    .toString(),
                                                          )) {
                                                            selectedEmployees
                                                                .add({
                                                              'engineer_id':
                                                                  employeeList[
                                                                          index]
                                                                      .employeeId
                                                                      .toString(),
                                                              'is_owner':
                                                                  'no', // Left-side checkboxes will always set 'is_owner' to 'no'
                                                            });
                                                          }
                                                        } else {
                                                          // Remove from selectedEmployees list if unselected
                                                          selectedEmployees
                                                              .removeWhere(
                                                            (employee) =>
                                                                employee[
                                                                    'engineer_id'] ==
                                                                employeeList[
                                                                        index]
                                                                    .employeeId
                                                                    .toString(),
                                                          );
                                                        }

                                                        print(
                                                            selectedEmployees); // Debug: print the current list
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                              Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  "${employeeList[index].employee.toString()}",
                                                  style: const TextStyle(
                                                    fontFamily: "Mulish",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Spacer(),
                                              ValueListenableBuilder<bool>(
                                                valueListenable:
                                                    checkboxes[index],
                                                builder:
                                                    (context, value, child) {
                                                  return Checkbox(
                                                    checkColor: Colors.white,
                                                    value: value,
                                                    onChanged:
                                                        (bool? newValue) {
                                                      if (newValue != null) {
                                                        // Update the selected employee list
                                                        if (newValue) {
                                                          for (int i = 0;
                                                              i <
                                                                  checkboxes
                                                                      .length;
                                                              i++) {
                                                            if (i != index) {
                                                              checkboxes[i]
                                                                      .value =
                                                                  false;
                                                            }
                                                          }
                                                          // When checked, set is_owner to 'yes'

                                                          selectedEmployees.removeWhere(
                                                              (employee) =>
                                                                  employee[
                                                                      'engineer_id'] ==
                                                                  employeeList[
                                                                          index]
                                                                      .employeeId
                                                                      .toString());
                                                          selectedEmployees
                                                              .add({
                                                            'engineer_id':
                                                                employeeList[
                                                                        index]
                                                                    .employeeId
                                                                    .toString(),
                                                            'is_owner': newValue
                                                                ? 'yes'
                                                                : 'no',
                                                          });
                                                        } else {
                                                          // When unchecked, set is_owner to 'no'
                                                          selectedEmployees.removeWhere(
                                                              (employee) =>
                                                                  employee[
                                                                      'engineer_id'] ==
                                                                  employeeList[
                                                                          index]
                                                                      .employeeId
                                                                      .toString());
                                                          selectedEmployees
                                                              .add({
                                                            'engineer_id':
                                                                employeeList[
                                                                        index]
                                                                    .employeeId
                                                                    .toString(),
                                                            'is_owner': 'no',
                                                          });
                                                        }

                                                        // Update the checkbox state
                                                        checkboxes[index]
                                                                .value =
                                                            newValue; // Update the current checkbox state
                                                        print(
                                                            selectedEmployees); // Debug: print the current list
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          // TicketInfoCardWidget(
                                          //     title: 'Skill set',
                                          //     value: employeeList[index]
                                          //         .employeeSkill
                                          //         .toString()),
                                          // SizedBox(height: 8),
                                          TicketInfoCardWidget(
                                              title: 'Department',
                                              value: employeeList[index]
                                                  .departmentName
                                                  .toString()),
                                          SizedBox(height: 8),
                                          // TicketInfoCardWidget(
                                          //     title: 'Completed', value: '3'),
                                          // SizedBox(height: 8),
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
                        );
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                String engineerIdsJson = jsonEncode(selectedEmployees);
                ApiService()
                    .AssignEngineer(
                  ticketNo: widget.ticketDetails.id.toString(),
                  status_id: '2',
                  priority: selectedPriority,
                  engineer_id: engineerIdsJson.toString(),
                  assign_type: 'Multiple',
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
                )
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
                  value.message;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(21, 147, 159, 1),
              ),
              child: Text(
                'Submit',
                style: TextStyle(fontFamily: "Mulish", color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
