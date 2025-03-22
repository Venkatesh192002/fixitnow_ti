import 'dart:convert';
import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/bottom_navigation/bottomnavscreen.dart';
import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/model/TicketDetailModel.dart';
import 'package:auscurator/model/employee_engineer_model.dart';
import 'package:auscurator/provider/asset_provider.dart';
import 'package:auscurator/repository/asset_repository.dart';
import 'package:auscurator/screens/breakdown/widgets/accept_dialog.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/widgets/dialogs.dart';
import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:auscurator/widgets/text_field.dart';
import 'package:auscurator/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:auscurator/machine_iot/widget/ticket_info_cart_widget.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssignMultipleTechnician extends StatefulWidget {
  const AssignMultipleTechnician(
      {super.key,
      required this.ticketDetails,
      this.companyId,
      this.buId,
      this.plantId,
      this.deptId});

  final BreakdownDetailList ticketDetails;
  final String? companyId, buId, plantId, deptId;

  @override
  State<AssignMultipleTechnician> createState() =>
      _AssignMultipleTechnicianState();
}

class _AssignMultipleTechnicianState extends State<AssignMultipleTechnician> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AssetRepository().getOverallEngineer(
        context,
        companyId: widget.companyId.toString(),
        buId: widget.buId.toString(),
        plantId: widget.plantId.toString(),
        deptId: widget.deptId.toString(),
      );
    });
    checkConnection(context); // Assuming this checks for internet connection
    // searchController.addListener(_filterEmployees); // Add listener for search
    searchController.addListener(() {
      filterItems();
    });
  }

  final loginId = SharedUtil().getLoginId;

  void filterItems() {
    setState(() {}); // Trigger a rebuild to filter in the UI
  }

  int? selectedIndex; // Tracks the currently selected checkbox index
  List<ValueNotifier<bool>> checkboxes = []; // List to hold checkbox states
  String? selectedEmployeeId; // Store the currently selected employee ID
  List<Map<String, String>> selectedEmployees = [];
  String selectedPriority = 'Low';

  TextEditingController searchController = TextEditingController();
  List<EmployeeList> employeeList = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final employeeListFuture = ref
    //     .watch(apiServiceProvider)
    //     .getEngineerOverallList(
    //         companyId: widget.companyId ?? '',
    //         buId: widget.buId ?? "",
    //         plantId: widget.plantId ?? '',
    //         deptId: widget.deptId ?? '');
    return Consumer<AssetProvider>(
      builder: (context, value, child) {
        employeeList = value.overallEngineerId?.employeeLists ?? [];

        if (searchController.text.isNotEmpty) {
          employeeList = employeeList
              .where((employee) =>
                  employee.employeeName != null &&
                  employee.employeeName!
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()))
              .toList();
        }

        checkboxes = List.generate(
          employeeList.length,
          (index) => ValueNotifier(
            selectedEmployeeId == employeeList[index].employeeId,
          ),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Assign Multiple Technician',
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
                        // Align(
                        //     alignment: Alignment.topLeft,
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(left: 10.0),
                        //       child: Text(
                        //         'Priority',
                        //         style: TextStyle(
                        //             fontFamily: "Mulish",
                        //             fontSize: 16,
                        //             fontWeight: FontWeight.bold,
                        //             color: Color.fromRGBO(21, 147, 159, 1)),
                        //       ),
                        //     )),
                        // SizedBox(height: 10.0),
                        // SegmentedControlPriority(
                        //   onPriorityChanged: (String priority) {
                        //     setState(() {
                        //       selectedPriority =
                        //           priority; // Update the selected priority
                        //     });
                        //   },
                        // ),
                        TextFormFieldCustom(
                            controller: searchController, hint: "Search"),
                        HeightFull(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom("Engineer",
                                size: 16,
                                fontWeight: FontWeight.bold,
                                color: Palette.primary),
                            TextCustom("Owner",
                                size: 16,
                                fontWeight: FontWeight.bold,
                                color: Palette.primary)
                          ],
                        ),

                        value.isLoading
                            ? SingleChildScrollView(
                                child: const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: ShimmerLists(
                                    count: 3,
                                    width: double.infinity,
                                    height: 300,
                                    shapeBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                )),
                              )
                            : employeeList.isEmpty
                                ? Center(
                                    child: NoDataScreen(),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                vertical: 8,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              StateSetter
                                                                  setCheckboxState) {
                                                            return Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              value: selectedIndex ==
                                                                      index ||
                                                                  selectedEmployees.any((employee) =>
                                                                      employee[
                                                                              'engineer_id'] ==
                                                                          employeeList[index]
                                                                              .employeeId
                                                                              .toString() &&
                                                                      employee[
                                                                              'is_owner'] ==
                                                                          'no'),
                                                              onChanged: (bool?
                                                                  newValue) {
                                                                setCheckboxState(
                                                                    () {
                                                                  if (newValue ==
                                                                      true) {
                                                                    if (selectedEmployees
                                                                            .length <
                                                                        3) {
                                                                      if (!selectedEmployees
                                                                          .any(
                                                                        (employee) =>
                                                                            employee['engineer_id'] ==
                                                                            employeeList[index].employeeId.toString(),
                                                                      )) {
                                                                        selectedEmployees
                                                                            .add({
                                                                          'engineer_id': employeeList[index]
                                                                              .employeeId
                                                                              .toString(),
                                                                          'is_owner':
                                                                              'no', // Always set 'is_owner' to 'no'
                                                                        });
                                                                      }
                                                                    } else {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          content: TextCustom(
                                                                              'You can only select up to 3 technicians.',
                                                                              color: Palette.pureWhite),
                                                                          duration:
                                                                              Duration(seconds: 2),
                                                                        ),
                                                                      );
                                                                    }
                                                                  } else {
                                                                    // Remove from selectedEmployees list if unselected
                                                                    selectedEmployees
                                                                        .removeWhere(
                                                                      (employee) =>
                                                                          employee[
                                                                              'engineer_id'] ==
                                                                          employeeList[index]
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
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Expanded(
                                                          child: Text(
                                                            "${employeeList[index].employeeName.toString()}",
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  "Mulish",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14,
                                                            ),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        ValueListenableBuilder<
                                                            bool>(
                                                          valueListenable:
                                                              checkboxes[index],
                                                          builder: (context,
                                                              value, child) {
                                                            return Radio<int>(
                                                              value: index,
                                                              groupValue:
                                                                  selectedIndex,
                                                              onChanged: (int?
                                                                  newIndex) {
                                                                if (newIndex !=
                                                                    null) {
                                                                  // Update the selected employee list
                                                                  if (newIndex !=
                                                                      selectedIndex) {
                                                                    for (int i =
                                                                            0;
                                                                        i < checkboxes.length;
                                                                        i++) {
                                                                      checkboxes[i]
                                                                              .value =
                                                                          (i ==
                                                                              newIndex);
                                                                    }

                                                                    // Update the selected employee with 'is_owner' = 'yes'
                                                                    selectedEmployees
                                                                        .clear();
                                                                    selectedEmployees
                                                                        .add({
                                                                      'engineer_id': employeeList[
                                                                              index]
                                                                          .employeeId
                                                                          .toString(),
                                                                      'is_owner':
                                                                          'yes',
                                                                    });

                                                                    // Update the index
                                                                    selectedIndex =
                                                                        newIndex;

                                                                    print(
                                                                        selectedEmployees); // Debug: print the current list
                                                                  }
                                                                }
                                                              },
                                                            );
                                                          },
                                                        )
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
                                                        value:
                                                            employeeList[index]
                                                                .department
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
                    bool Ischeckin = selectedEmployees.any((element) =>
                        "${element['engineer_id']}" == loginId.toString());
                    Ischeckin
                        ? commonDialog(context, CheckInAndCheckoutDialog())
                        : ApiService()
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
      },
    );
  }
}

// class AssignMultipleTechnician extends ConsumerStatefulWidget {
//   final BreakdownDetailList ticketDetails;
//   final String? companyId, buId, plantId, deptId;

//   AssignMultipleTechnician({
//     required this.ticketDetails,
//     this.companyId,
//     this.buId,
//     this.plantId,
//     this.deptId,
//   });
//   @override
//   ConsumerState createState() => _AssignScreenState();
// }

// class _AssignScreenState extends ConsumerState<AssignMultipleTechnician> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((t) {
//       AssetRepository().getOverallEngineer(context,
//           companyId: widget.companyId.toString(),
//           buId: widget.buId.toString(),
//           plantId: widget.plantId.toString(),
//           deptId: widget.deptId.toString());
//     });
//     checkConnection(context);
//     searchController.addListener(_filterEmployees);
//     // Assuming this checks for internet connection
//   }

//   int? selectedIndex; // Tracks the currently selected checkbox index
//   List<ValueNotifier<bool>> checkboxes = []; // List to hold checkbox states
//   String? selectedEmployeeId; // Store the currently selected employee ID
//   List<Map<String, String>> selectedEmployees = [];
//   String selectedPriority = 'Low';

//   TextEditingController searchController = TextEditingController();
//   List<DepartmentEngineerLists> filteredEmployeeList = [];
//   List<DepartmentEngineerLists> employeeList = [];

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   /// 🔎 Filter employees based on search input
//   void _filterEmployees() {
//     String query = searchController.text.toLowerCase();

//     setState(() {
//       filteredEmployeeList = employeeList.where((employee) {
//         // Ensure that both employee name and ID are properly checked
//         logger.i(employee.employee);
//         return (employee.employee != null &&
//             employee.employee!.toLowerCase().contains(query));
//         //     ||
//         // (employee.employeeId != null &&
//         //     employee.employeeId!.toLowerCase().contains(query));
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final employeeListFuture = ref
//     //     .watch(apiServiceProvider)
//     //     .getEngineerOverallList(
//     //         companyId: widget.companyId ?? '',
//     //         buId: widget.buId ?? "",
//     //         plantId: widget.plantId ?? '',
//     //         deptId: widget.deptId ?? '');
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Assign Technician',
//           style: TextStyle(fontFamily: "Mulish", color: Colors.white),
//         ),
//         backgroundColor: Color.fromRGBO(30, 152, 165, 1),
//         iconTheme: IconThemeData(
//           color: Colors.white,
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   children: <Widget>[
//                     Row(children: [
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 10.0),
//                           child: Text(
//                             'TicketNumber :',
//                             style: TextStyle(
//                                 fontFamily: "Mulish",
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color.fromRGBO(21, 147, 159, 1)),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10.0),
//                       Align(
//                         alignment: Alignment.topRight,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 5.0),
//                           child: Text(
//                             '${widget.ticketDetails.ticketNo}',
//                             style: TextStyle(
//                                 fontFamily: "Mulish", color: Colors.black),
//                           ),
//                         ),
//                       )
//                     ]),
//                     Row(children: [
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 10.0),
//                           child: Text(
//                             'issue :',
//                             style: TextStyle(
//                                 fontFamily: "Mulish",
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color.fromRGBO(21, 147, 159, 1)),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10.0),
//                       Align(
//                         alignment: Alignment.topRight,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 5.0),
//                           child: Text(
//                             '${widget.ticketDetails.breakdownCategory}',
//                             style: TextStyle(
//                                 fontFamily: "Mulish", color: Colors.black),
//                           ),
//                         ),
//                       )
//                     ]),
//                     SizedBox(height: 10.0),
//                     // Align(
//                     //     alignment: Alignment.topLeft,
//                     //     child: Padding(
//                     //       padding: const EdgeInsets.only(left: 10.0),
//                     //       child: Text(
//                     //         'Priority',
//                     //         style: TextStyle(
//                     //             fontFamily: "Mulish",
//                     //             fontSize: 16,
//                     //             fontWeight: FontWeight.bold,
//                     //             color: Color.fromRGBO(21, 147, 159, 1)),
//                     //       ),
//                     //     )),
//                     // SizedBox(height: 10.0),
//                     // SegmentedControlPriority(
//                     //   onPriorityChanged: (String priority) {
//                     //     setState(() {
//                     //       selectedPriority =
//                     //           priority; // Update the selected priority
//                     //     });
//                     //   },
//                     // ),
//                     TextFormFieldCustom(
//                         controller: searchController, hint: "Search"),
//                     HeightFull(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TextCustom("Engineer",
//                             size: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Palette.primary),
//                         TextCustom("Owner",
//                             size: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Palette.primary)
//                       ],
//                     ),
//                     FutureBuilder(
//                       future: employeeListFuture,
//                       builder: (context, snapshot) {
//                         if (snapshot.hasError) {
//                           return Center(child: Text(snapshot.error.toString()));
//                         }

//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return SingleChildScrollView(
//                             child: const Center(
//                                 child: Padding(
//                               padding: EdgeInsets.all(15),
//                               child: ShimmerLists(
//                                 count: 3,
//                                 width: double.infinity,
//                                 height: 300,
//                                 shapeBorder: RoundedRectangleBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10))),
//                               ),
//                             )),
//                           );
//                         }

//                         if (snapshot.data == null ||
//                             snapshot.data!.departmentEngineerLists == null ||
//                             snapshot.data!.departmentEngineerLists!.isEmpty) {
//                           return Center(
//                             child: NoDataScreen(),
//                           );
//                         }

//                         // ✅ Load employee list once and apply filtering
//                         if (employeeList.isEmpty) {
//                           employeeList =
//                               snapshot.data!.departmentEngineerLists!;
//                           filteredEmployeeList = List.from(
//                               employeeList); // Initialize with full list
//                         }
//                         // Initialize ValueNotifiers for each employee
//                         checkboxes = List.generate(
//                           employeeList.length,
//                           (index) => ValueNotifier(
//                             selectedEmployeeId ==
//                                 employeeList[index].employeeId,
//                           ),
//                         );
//                         return ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: filteredEmployeeList.length,
//                           itemBuilder: (context, index) {
//                             return StatefulBuilder(
//                               builder: (BuildContext context,
//                                   StateSetter setItemState) {
//                                 return GestureDetector(
//                                   onTap: () {},
//                                   child: Card(
//                                     color: Colors.white,
//                                     elevation: 3,
//                                     margin: EdgeInsets.symmetric(
//                                       vertical: 8,
//                                     ),
//                                     child: Padding(
//                                       padding: EdgeInsets.all(16),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               StatefulBuilder(
//                                                 builder: (BuildContext context,
//                                                     StateSetter
//                                                         setCheckboxState) {
//                                                   return Checkbox(
//                                                     checkColor: Colors.white,
//                                                     value: selectedIndex ==
//                                                             index ||
//                                                         selectedEmployees.any((employee) =>
//                                                             employee[
//                                                                     'engineer_id'] ==
//                                                                 employeeList[
//                                                                         index]
//                                                                     .employeeId
//                                                                     .toString() &&
//                                                             employee[
//                                                                     'is_owner'] ==
//                                                                 'no'),
//                                                     onChanged:
//                                                         (bool? newValue) {
//                                                       setCheckboxState(() {
//                                                         if (newValue == true) {
//                                                           // Add to selectedEmployees if not already in the list
//                                                           if (!selectedEmployees
//                                                               .any(
//                                                             (employee) =>
//                                                                 employee[
//                                                                     'engineer_id'] ==
//                                                                 employeeList[
//                                                                         index]
//                                                                     .employeeId
//                                                                     .toString(),
//                                                           )) {
//                                                             selectedEmployees
//                                                                 .add({
//                                                               'engineer_id':
//                                                                   employeeList[
//                                                                           index]
//                                                                       .employeeId
//                                                                       .toString(),
//                                                               'is_owner':
//                                                                   'no', // Left-side checkboxes will always set 'is_owner' to 'no'
//                                                             });
//                                                           }
//                                                         } else {
//                                                           // Remove from selectedEmployees list if unselected
//                                                           selectedEmployees
//                                                               .removeWhere(
//                                                             (employee) =>
//                                                                 employee[
//                                                                     'engineer_id'] ==
//                                                                 employeeList[
//                                                                         index]
//                                                                     .employeeId
//                                                                     .toString(),
//                                                           );
//                                                         }

//                                                         print(
//                                                             selectedEmployees); // Debug: print the current list
//                                                       });
//                                                     },
//                                                   );
//                                                 },
//                                               ),
//                                               Container(
//                                                 width: 24,
//                                                 height: 24,
//                                                 decoration: BoxDecoration(
//                                                     shape: BoxShape.circle,
//                                                     color: Colors.red),
//                                               ),
//                                               SizedBox(width: 8),
//                                               Expanded(
//                                                 child: Text(
//                                                   "${employeeList[index].employee.toString()}",
//                                                   style: const TextStyle(
//                                                     fontFamily: "Mulish",
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 14,
//                                                   ),
//                                                   maxLines: 2,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                               Spacer(),
//                                               ValueListenableBuilder<bool>(
//                                                 valueListenable:
//                                                     checkboxes[index],
//                                                 builder:
//                                                     (context, value, child) {
//                                                   return Radio<int>(
//                                                     value: index,
//                                                     groupValue: selectedIndex,
//                                                     onChanged: (int? newIndex) {
//                                                       if (newIndex != null) {
//                                                         // Update the selected employee list
//                                                         if (newIndex !=
//                                                             selectedIndex) {
//                                                           for (int i = 0;
//                                                               i <
//                                                                   checkboxes
//                                                                       .length;
//                                                               i++) {
//                                                             checkboxes[i]
//                                                                     .value =
//                                                                 (i == newIndex);
//                                                           }

//                                                           // Update the selected employee with 'is_owner' = 'yes'
//                                                           selectedEmployees
//                                                               .clear();
//                                                           selectedEmployees
//                                                               .add({
//                                                             'engineer_id':
//                                                                 employeeList[
//                                                                         index]
//                                                                     .employeeId
//                                                                     .toString(),
//                                                             'is_owner': 'yes',
//                                                           });

//                                                           // Update the index
//                                                           selectedIndex =
//                                                               newIndex;

//                                                           print(
//                                                               selectedEmployees); // Debug: print the current list
//                                                         }
//                                                       }
//                                                     },
//                                                   );
//                                                 },
//                                               )
//                                             ],
//                                           ),
//                                           SizedBox(height: 4),
//                                           // TicketInfoCardWidget(
//                                           //     title: 'Skill set',
//                                           //     value: employeeList[index]
//                                           //         .employeeSkill
//                                           //         .toString()),
//                                           // SizedBox(height: 8),
//                                           TicketInfoCardWidget(
//                                               title: 'Department',
//                                               value: employeeList[index]
//                                                   .departmentName
//                                                   .toString()),
//                                           SizedBox(height: 8),
//                                           // TicketInfoCardWidget(
//                                           //     title: 'Completed', value: '3'),
//                                           // SizedBox(height: 8),
//                                           // TicketInfoCardWidget(
//                                           //     title: 'Accept', value: '2'),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         );
//                       },
//                     ),
//                     SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 String engineerIdsJson = jsonEncode(selectedEmployees);
//                 ApiService()
//                     .AssignEngineer(
//                   ticketNo: widget.ticketDetails.id.toString(),
//                   status_id: '2',
//                   priority: selectedPriority,
//                   engineer_id: engineerIdsJson.toString(),
//                   assign_type: 'Multiple',
//                   downtime_val: '',
//                   open_comment: '',
//                   assigned_comment: '',
//                   accept_comment: '',
//                   reject_comment: '',
//                   hold_comment: '',
//                   pending_comment: '',
//                   check_out_comment: '',
//                   completed_comment: '',
//                   reopen_comment: '',
//                   reassign_comment: '',
//                   comment: '',
//                 )
//                     .then((value) {
//                   if (value.isError == false) {
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(
//                         builder: (ctx) => const BottomNavScreen(),
//                       ),
//                       (route) => false,
//                     );
//                   }
//                   showMessage(
//                       context: context,
//                       isError: value.isError!,
//                       responseMessage: value.message!);
//                   value.message;
//                 });
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color.fromRGBO(21, 147, 159, 1),
//               ),
//               child: Text(
//                 'Submit',
//                 style: TextStyle(fontFamily: "Mulish", color: Colors.white),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
