// ignore_for_file: unused_element

import 'dart:convert';
import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/bottom_navigation/bottomnavscreen.dart';
import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/model/MTTRUpdateListModel.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:auscurator/provider/mttr_provider.dart';
import 'package:auscurator/repository/mttr_repository.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/widgets/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MTTREditScreen extends StatefulWidget {
  const MTTREditScreen(
      {super.key,
      required this.asset_group_id,
      required this.ticketNumber,
      required this.downTime,
      required this.status});
  final String asset_group_id;
  final String ticketNumber;
  final String downTime;
  final String status;

  @override
  State<MTTREditScreen> createState() => _MTTREditScreenState();
}

class _MTTREditScreenState extends State<MTTREditScreen> {
  TextEditingController downtimeController = TextEditingController();

  TextEditingController searchController = TextEditingController();
  List<TextEditingController> quantityControllers =
      []; // Controller for search input
  List<MttrData> filteredMttrUpdateDetails = [];
  List<MttrData> mttrUpdateDetails = [];

  List<MttrData> filteredMttrDetails = [];

  String downTime1 = "";

  bool _isLoading = false;
  // Method to convert total seconds to HH:MM:SS format
  String _convertToHHMMSS(String downtime) {
    int totalSeconds = int.tryParse(downtime) ?? 0;

    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  List<MttrData> mttrListDetails = mttrProvider.mttrUpdateData?.mttrData ?? [];

  @override
  void initState() {
    checkConnection(context);
    downTime1 = widget.downTime;

    downtimeController.addListener(() {
      setData();
    });
    searchController = TextEditingController();
    downtimeController =
        TextEditingController(text: _convertToHHMMSS(widget.downTime));
    quantityControllers = List.generate(mttrListDetails.length,
        (index) => TextEditingController(text: '00:00:00'));
    quantityControllers = List.generate(
        mttrListDetails.length,
        (index) => TextEditingController(
              text: convertSecondsToHHMMSS(
                  mttrListDetails[index].mttrValue ?? 0.0),
            ));
    filteredMttrDetails = mttrListDetails;
    searchController.addListener(() {
      _filterMttrList();
    });
    setState(() {});
    super.initState();
  }

  setData() {
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    downtimeController.dispose();
    totalController.dispose();
    for (var controller in quantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _filterMttrList() {
    setState(() {});
  }

  // Method to convert HH:MM:SS to total seconds
  int _convertToSeconds(String time) {
    final parts = time.split(':');
    if (parts.length != 3) return 0; // Return 0 if format is incorrect
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = int.tryParse(parts[2]) ?? 0;
    return (hours * 3600) + (minutes * 60) + seconds;
  }

  TextEditingController totalController = TextEditingController();
  final isDownTime = SharedUtil().getisdowntime;
  final isMttr = SharedUtil().getisMttr;

  @override
  Widget build(BuildContext context) {
    return Consumer<MttrProvider>(
      builder: (context, mttr, _) {
        List<MttrData> mttrList = mttr.mttrUpdateData?.mttrData ?? [];
        if (searchController.text.isNotEmpty) {
          filteredMttrDetails = filteredMttrDetails
              .where((mttr) =>
                  mttr.mttrName != null &&
                  mttr.mttrName!
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()))
              .toList();
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'MTTR',
              style: TextStyle(fontFamily: "Mulish", color: Colors.white),
            ),
            backgroundColor: Color.fromRGBO(30, 152, 165, 1),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      color: const Color(0xF5F5F5F5),
                      child: Center(
                        child: Column(
                          children: [
                            _buildDowntimeRow(
                                _convertToHHMMSS(widget.downTime)),
                            _buildSearchField(),
                            SizedBox(
                                height: context.heightFull() + 150,
                                child: _buildSparePartsList()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              mttrList.isEmpty
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: const Color(0xF5F5F5F5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Total',
                                style: const TextStyle(
                                  fontFamily: "Mulish",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: totalController,
                                readOnly: true,
                                decoration: InputDecoration(
                                    hintText: "00:00:00",
                                    hintStyle: TextStyle(
                                      fontFamily: "Mulish",
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  // Optionally handle changes here, e.g., validation
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              widget.status == "Fixed"
                  ? SizedBox.shrink()
                  : _buildSaveButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDowntimeRow(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Downtime: $label',
              style: const TextStyle(
                fontFamily: "Mulish",
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 10),
          widget.status == "Fixed"
              ? Expanded(
                  flex: 1,
                  child: TextField(
                    controller: downtimeController,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'HH',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          fontFamily: "Mulish",
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(20))),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      // Optionally handle changes here, e.g., validation
                    },
                  ),
                )
              :
              // TextField for entering hours
              Expanded(
                  flex: 1,
                  child: TextField(
                    controller: downtimeController,
                    readOnly: isDownTime == 'yes' ? false : true,
                    decoration: InputDecoration(
                        labelText: 'HH',
                        labelStyle: TextStyle(
                          fontFamily: "Mulish",
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(20))),
                    onChanged: (value) {
                      downTime1 =
                          _convertToSeconds(downtimeController.text).toString();
                      setState(() {});
                      // Optionally handle changes here, e.g., validation
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController, // Bind controller to TextField
        style: const TextStyle(fontFamily: "Mulish", color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            fontFamily: "Mulish",
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.black),
        ),
        cursorColor: const Color(0xFF018786),
      ),
    );
  }

  Widget _buildSparePartsList() {
    return Consumer<MttrProvider>(builder: (context, mttr, _) {
      // Update mttrUpdateDetails and filteredMttrUpdateDetails based on provider data
      mttrUpdateDetails = mttr.mttrUpdateData?.mttrData ?? [];
      filteredMttrUpdateDetails = mttrUpdateDetails;

      // Check if quantityControllers need to be recreated based on the filtered data
      if (quantityControllers.length != filteredMttrUpdateDetails.length) {
        // Recreate quantityControllers with initial values
        quantityControllers = List.generate(
          filteredMttrUpdateDetails.length,
          (index) => TextEditingController(
            text: filteredMttrUpdateDetails[index].mttrName ?? '00:00:00',
          ),
        );
      }

      // Check if loading, display loading shimmer or content
      return mttr.isLoading
          ? SingleChildScrollView(
              child: const Center(
                  child: Padding(
                padding: EdgeInsets.all(15),
                child: ShimmerLists(
                  count: 10,
                  width: double.infinity,
                  height: 100,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              )),
            )
          : filteredMttrUpdateDetails.isEmpty
              ? Center(child: NoDataScreen())
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredMttrUpdateDetails
                      .length, // Use filtered list length
                  itemBuilder: (context, index) {
                    // Apply search filter to the filteredMttrUpdateDetails list
                    if (searchController.text.isNotEmpty) {
                      filteredMttrUpdateDetails =
                          filteredMttrUpdateDetails.where((mttr) {
                        return mttr.mttrName != null &&
                            mttr.mttrName!
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase());
                      }).toList();
                    }
                    int total = 0;

                    // Sum the values in the quantityControllers to calculate the total
                    for (var controller in quantityControllers) {
                      total += _convertToSeconds(controller.text);
                    }

                    // Use addPostFrameCallback to delay the update of the total
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      totalController.text = _convertToHHMMSS(total.toString());
                    });

                    return _buildSpareCard(
                        filteredMttrUpdateDetails[index], index);
                  },
                );
    });
  }

  String convertSecondsToHHMMSS(double seconds) {
    int totalSeconds = seconds.toInt();
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int secs = totalSeconds % 60;

    // Format as HH:MM:SS
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildSpareCard(MttrData spare, int index) {
    // Print the original mttrValue for debugging
    print('Original mttrValue: ${spare.mttrValue}');

    // Convert mttrValue to integer seconds
    int mttrValueInSeconds = (spare.mttrValue as num).toInt();

    // Convert mttrValue to HH:mm:ss format
    String formattedMttrValue = _convertToHHMMSS(mttrValueInSeconds.toString());

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            // Pass the formatted value to _buildTextRow
            _buildTextRow(spare.mttrName.toString(), formattedMttrValue, index),
          ],
        ),
      ),
    );
  }

  Widget _buildTextRow(String label, String value, int index) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: "Mulish",
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(width: 10),
        widget.status == "Fixed"
            ? Expanded(
                flex: 1,
                child: TextField(
                  controller: quantityControllers[index],
                  readOnly: true,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(20))),
                  onChanged: (value) {
                    // Calculate the total whenever a value changes
                    int total = 0;
                    for (var controller in quantityControllers) {
                      total += _convertToSeconds(controller.text);
                    }
                    setState(() {
                      totalController.text = _convertToHHMMSS(total.toString());
                    });
                  },
                ),
              )
            :
            // TextField for entering quantity
            Expanded(
                flex: 1,
                child: TextField(
                  controller: quantityControllers[index],
                  readOnly: isMttr == 'yes' ? false : true,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(20))),
                  onChanged: (value) {
                    // Calculate the total whenever a value changes
                    int total = 0;
                    for (var controller in quantityControllers) {
                      total += _convertToSeconds(controller.text);
                    }
                    setState(() {
                      totalController.text = _convertToHHMMSS(total.toString());
                    });
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading
          ? null // Disable button if loading
          : () {
              // Convert the downtime value to seconds
              // String downtime = _convertToHHMMSS(widget.downTime);
              int downtimeInSeconds = int.parse(downTime1);

              int totalEnteredTimeInSeconds = 0;
              List<Map<String, dynamic>> jsonList = [];

              for (var i = 0; i < mttrUpdateDetails.length; i++) {
                String enteredQuantity = quantityControllers[i].text;
                int enteredTimeInSeconds = _convertToSeconds(enteredQuantity);
                totalEnteredTimeInSeconds += enteredTimeInSeconds;
                // Check if the entered time exceeds the downtime

                Map<String, dynamic> mttrJson = {
                  'mttr_name': mttrUpdateDetails[i].mttrName,
                  'mttr_id': mttrUpdateDetails[i].mttrId,
                  'mttr_value': enteredTimeInSeconds, // Use total seconds
                };

                jsonList.add(mttrJson);
              }

              if (totalEnteredTimeInSeconds != downtimeInSeconds) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Entered time exceeds downtime value.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
                return;
              }

              // If canSave is still true, proceed with saving
              // if (canSave) {
              // Convert the list of maps to a JSON string
              String jsonString = jsonEncode(jsonList);
              print(widget.ticketNumber.toString());
              ApiService()
                  .SaveMTTR(
                      ticketNo: widget.ticketNumber.toString(),
                      solution_bank: jsonString)
                  .then((value) {
                if (value.isError == false) {
                  FocusScope.of(context).unfocus();

                  // Simulating save success:
                  // Future.delayed(const Duration(seconds: 1), () {
                  //   // Once saved successfully, clear all the text fields
                  //   _clearAllTextFields();
                  // });

                  showMessage(
                      context: context,
                      isError: value.isError!,
                      responseMessage: value.message!);
                  value.message;
                  MttrRepository()
                      .MTTRUpdatedLists(context, ticketId: widget.ticketNumber)
                      .then((value) {
                    ApiService()
                        .TicketAccept(
                            ticketNo: widget.ticketNumber.toString(),
                            status_id: '',
                            priority: '',
                            assign_type: '',
                            downtime_val:
                                _convertToHHMMSS(downtimeInSeconds.toString()),
                            open_comment: '',
                            assigned_comment: '',
                            accept_comment: '',
                            reject_comment: '',
                            hold_comment: '',
                            pending_comment: '',
                            check_out_comment: "",
                            completed_comment: "",
                            reopen_comment: '',
                            reassign_comment: '',
                            solution: "",
                            comment: '',
                            breakdown_category_id: "",
                            breakdown_subcategory_id: "",
                            checkin_comment: '', planned_Date: '')
                        .then((value) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (ctx) => const BottomNavScreen()),
                        (route) => false,
                      );
                    });
                  });
                } else {
                  showMessage(
                      context: context,
                      isError: value.isError!,
                      responseMessage: value.message!);
                  value.message;
                }
              });
            },
      // },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
      ),
      child:
          // _isLoading
          //     ? const CircularProgressIndicator(
          //         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          //       )
          //     :
          const Text('Save', style: TextStyle(color: Colors.white)),
    );
  }

  // Method to clear all the TextFields
  void _clearAllTextFields() {
    for (var controller in quantityControllers) {
      controller.clear();
    }
  }
}

// class MTTREditScreen extends ConsumerStatefulWidget {
//   final String asset_group_id;
//   final String ticketNumber;
//   final String downTime;
//   final String status;

//   const MTTREditScreen(
//       {super.key,
//       required this.asset_group_id,
//       required this.ticketNumber,
//       required this.downTime,
//       required this.status});

//   @override
//   ConsumerState<MTTREditScreen> createState() => _MTTRScreenState();
// }

// class _MTTRScreenState extends ConsumerState<MTTREditScreen> {
//   late TextEditingController downtimeController;
//   TextEditingController searchController =
//       TextEditingController(); // Search controller
//   List<MttrData> mttrDetails = [];
//   List<TextEditingController> quantityControllers =
//       []; // Controller for search input
//   List<MttrData> filteredMttrDetails = [];
//   bool _isLoading = false;
//   // Method to convert total seconds to HH:MM:SS format
//   String _convertToHHMMSS(String downtime) {
//     int totalSeconds = int.tryParse(downtime) ?? 0;

//     int hours = totalSeconds ~/ 3600;
//     int minutes = (totalSeconds % 3600) ~/ 60;
//     int seconds = totalSeconds % 60;

//     String formattedTime =
//         '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

//     return formattedTime;
//   }

//   @override
//   void initState() {
//     super.initState();
//     checkConnection(context);
//     searchController = TextEditingController();
//     downtimeController =
//         TextEditingController(text: _convertToHHMMSS(widget.downTime));
//     // Initialize quantity controllers for each spare part
//     quantityControllers = List.generate(
//         mttrDetails.length, (index) => TextEditingController(text: '00:00:00'));
//     // Initialize filtered list with all items
//     filteredMttrDetails = mttrDetails;

//     // Add listener to search controller
//     searchController.addListener(() {
//       _filterMttrList(); // Call filtering method on input change
//     });
//   }

//   @override
//   void dispose() {
//     // Dispose controllers to avoid memory leaks
//     searchController.dispose();
//     downtimeController.dispose();
//     for (var controller in quantityControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   void _filterMttrList() {
//     final query = searchController.text.toLowerCase();
//     setState(() {
//       filteredMttrDetails = mttrDetails.where((mttr) {
//         return mttr.mttrName!.toLowerCase().contains(query); // Filter logic
//       }).toList();
//     });
//   }

//   // Method to convert HH:MM:SS to total seconds
//   int _convertToSeconds(String time) {
//     final parts = time.split(':');
//     if (parts.length != 3) return 0; // Return 0 if format is incorrect
//     final hours = int.tryParse(parts[0]) ?? 0;
//     final minutes = int.tryParse(parts[1]) ?? 0;
//     final seconds = int.tryParse(parts[2]) ?? 0;
//     return (hours * 3600) + (minutes * 60) + seconds;
//   }

//   TextEditingController totalController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'MTTR',
//           style: TextStyle(fontFamily: "Mulish", color: Colors.white),
//         ),
//         backgroundColor: Color.fromRGBO(30, 152, 165, 1),
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               children: [
//                 Container(
//                   color: const Color(0xF5F5F5F5),
//                   child: Center(
//                     child: Column(
//                       children: [
//                         _buildDowntimeRow(_convertToHHMMSS(widget.downTime)),
//                         _buildSearchField(),
//                         SizedBox(
//                             height: context.heightFull(),
//                             child: _buildSparePartsList()),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(24),
//                 color: const Color(0xF5F5F5F5),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: Text(
//                       'Total',
//                       style: const TextStyle(
//                         fontFamily: "Mulish",
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   // TextField for entering hours
//                   Expanded(
//                     flex: 1,
//                     child: TextField(
//                       controller: totalController,
//                       readOnly: true,
//                       decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(20))),
//                       keyboardType: TextInputType.number,
//                       onChanged: (value) {
//                         // Optionally handle changes here, e.g., validation
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           _buildSaveButton(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildDowntimeRow(String label) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 1,
//             child: Text(
//               'Downtime: $label',
//               style: const TextStyle(
//                 fontFamily: "Mulish",
//                 fontWeight: FontWeight.w600,
//                 fontSize: 15,
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           // TextField for entering hours
//           Expanded(
//             flex: 1,
//             child: TextField(
//               controller: downtimeController,
//               // enabled: false,
//               decoration: InputDecoration(
//                   labelText: 'HH',
//                   filled: true,
//                   fillColor: Colors.white,
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   disabledBorder: UnderlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.transparent),
//                       borderRadius: BorderRadius.circular(20))),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 // Optionally handle changes here, e.g., validation
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: searchController, // Bind controller to TextField
//         style: const TextStyle(fontFamily: "Mulish", color: Colors.black),
//         decoration: InputDecoration(
//           hintText: 'Search',
//           filled: true,
//           fillColor: Colors.white,
//           enabledBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.transparent),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.transparent),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           prefixIcon: const Icon(Icons.search, color: Colors.black),
//         ),
//         cursorColor: const Color(0xFF018786),
//       ),
//     );
//   }

//   Widget _buildSparePartsList() {
//     final spareFuture = ref
//         .watch(apiServiceProvider)
//         .MTTRUpdatedLists(ticketId: widget.ticketNumber);

//     return FutureBuilder(
//       future: spareFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return SingleChildScrollView(
//             child: const Center(
//                 child: Padding(
//               padding: EdgeInsets.all(15),
//               child: ShimmerLists(
//                 count: 10,
//                 width: double.infinity,
//                 height: 100,
//                 shapeBorder: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10))),
//               ),
//             )),
//           );
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (snapshot.hasData && snapshot.data?.mttrData != null) {
//           mttrDetails = snapshot.data!.mttrData!;
//           filteredMttrDetails = mttrDetails; // Initialize filtered list

//           // Re-initialize quantity controllers
//           if (quantityControllers.length != mttrDetails.length) {
//             quantityControllers = List.generate(
//               mttrDetails.length,
//               (index) => TextEditingController(text: '00:00:00'),
//             );
//           }
//         } else {
//           return Center(
//             child: NoDataScreen(),
//           );
//         }

//         return ListView.builder(
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: filteredMttrDetails.length, // Use filtered list length
//           itemBuilder: (context, index) {
//             int total = 0;
//             for (var controller in quantityControllers) {
//               total += _convertToSeconds(controller.text);
//             }

// // Use addPostFrameCallback to delay the update
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               totalController.text = _convertToHHMMSS(total.toString());
//             });

//             quantityControllers = List.generate(
//                 filteredMttrDetails.length,
//                 (index) => TextEditingController(
//                       text: convertSecondsToHHMMSS(
//                           filteredMttrDetails[index].mttrValue ?? 0.0),
//                     ));
//             return _buildSpareCard(
//                 filteredMttrDetails[index], index); // Use filtered items
//           },
//         );
//       },
//     );
//   }

//   String convertSecondsToHHMMSS(double seconds) {
//     int totalSeconds = seconds.toInt();
//     int hours = totalSeconds ~/ 3600;
//     int minutes = (totalSeconds % 3600) ~/ 60;
//     int secs = totalSeconds % 60;

//     // Format as HH:MM:SS
//     return '${hours.toString().padLeft(2, '0')}:'
//         '${minutes.toString().padLeft(2, '0')}:'
//         '${secs.toString().padLeft(2, '0')}';
//   }

//   Widget _buildSpareCard(MttrData spare, int index) {
//     // Print the original mttrValue for debugging
//     print('Original mttrValue: ${spare.mttrValue}');

//     // Convert mttrValue to integer seconds
//     int mttrValueInSeconds = (spare.mttrValue as num).toInt();

//     // Convert mttrValue to HH:mm:ss format
//     String formattedMttrValue = _convertToHHMMSS(mttrValueInSeconds.toString());

//     return Card(
//       elevation: 5,
//       margin: const EdgeInsets.all(10),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 5),
//             // Pass the formatted value to _buildTextRow
//             _buildTextRow(spare.mttrName.toString(), formattedMttrValue, index),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextRow(String label, String value, int index) {
//     return Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontFamily: "Mulish",
//               fontWeight: FontWeight.w600,
//               fontSize: 15,
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         // TextField for entering quantity
//         Expanded(
//           flex: 1,
//           child: TextField(
//             controller: quantityControllers[index],
//             // readOnly: widget.isMttr == 'yes' ? false : true,
//             decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.white,
//                 enabledBorder: UnderlineInputBorder(
//                   borderSide: const BorderSide(color: Colors.transparent),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 focusedBorder: UnderlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.transparent),
//                     borderRadius: BorderRadius.circular(20))),
//             onChanged: (value) {
//               // Calculate the total whenever a value changes
//               int total = 0;
//               for (var controller in quantityControllers) {
//                 total += _convertToSeconds(controller.text);
//               }
//               setState(() {
//                 totalController.text = _convertToHHMMSS(total.toString());
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSaveButton(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: ElevatedButton(
//         onPressed: _isLoading
//             ? null // Disable button if loading
//             : () {
//                 setState(() {
//                   _isLoading = true; // Start loading
//                 });

//                 // Convert the downtime value to seconds
//                 int downtimeInSeconds = int.parse(widget.downTime);
//                 List<Map<String, dynamic>> jsonList = [];
//                 bool canSave = true; // Flag to check if save is allowed

//                 for (var i = 0; i < mttrDetails.length; i++) {
//                   String enteredQuantity = quantityControllers[i].text;
//                   int enteredTimeInSeconds = _convertToSeconds(enteredQuantity);
//                   // logger.e(enteredTimeInSeconds);
//                   // logger.e(downtimeInSeconds);
//                   // Check if the entered time exceeds the downtime
//                   if (enteredTimeInSeconds > downtimeInSeconds) {
//                     canSave = false; // Set flag to false
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: const Text('Error'),
//                         content:
//                             const Text('Entered time exceeds downtime value.'),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: const Text('OK'),
//                           ),
//                         ],
//                       ),
//                     );
//                     break; // Exit the loop if we found an error
//                   }

//                   // Create a map for each spare part
//                   Map<String, dynamic> mttrJson = {
//                     'mttr_name': mttrDetails[i].mttrName,
//                     'mttr_id': mttrDetails[i].mttrId,
//                     'mttr_value': enteredTimeInSeconds, // Use total seconds
//                   };
//                   // logger.wtf(mttrJson);

//                   jsonList.add(mttrJson);
//                   // logger.wtf(jsonList);
//                 }
//                 setState(() {});

//                 // If canSave is still true, proceed with saving
//                 if (canSave) {
//                   // Convert the list of maps to a JSON string
//                   String jsonString = jsonEncode(jsonList);
//                   print(jsonString);
//                   print(widget.ticketNumber.toString());
//                   ApiService()
//                       .SaveMTTR(
//                           ticketNo: widget.ticketNumber.toString(),
//                           solution_bank: jsonString)
//                       .then((value) {
//                     setState(() {
//                       _isLoading = false; // Stop loading when save is done
//                     });

//                     if (value.isError == false) {
//                       FocusScope.of(context).unfocus();
//                       // Simulating save success:
//                       Future.delayed(const Duration(seconds: 1), () {
//                         _clearAllTextFields(); // Clear all fields after saving
//                       });
//                       showMessage(
//                           context: context,
//                           isError: value.isError!,
//                           responseMessage: value.message!);
//                       Navigator.of(context).pop();
//                     } else {
//                       showMessage(
//                           context: context,
//                           isError: value.isError!,
//                           responseMessage: value.message!);
//                     }
//                   }).catchError((error) {
//                     setState(() {
//                       _isLoading = false; // Stop loading on error
//                     });
//                   });
//                 }
//               },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color.fromRGBO(30, 152, 165, 1),
//         ),
//         child: _isLoading
//             ? const CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               )
//             : const Text('Save',
//                 style: TextStyle(fontFamily: "Mulish", color: Colors.white)),
//       ),
//     );
//   }

//   // Method to clear all the TextFields
//   void _clearAllTextFields() {
//     for (var controller in quantityControllers) {
//       controller.clear();
//     }
//   }
// }
