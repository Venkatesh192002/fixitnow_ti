import 'dart:convert';
import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/bottom_navigation/bottomnavscreen.dart';
import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/model/MTTRListModel.dart';
import 'package:auscurator/model/MTTRUpdateListModel.dart';
import 'package:auscurator/provider/mttr_provider.dart';
import 'package:auscurator/repository/mttr_repository.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/widgets/context_extension.dart';
import 'package:auscurator/widgets/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MTTRScreen extends StatefulWidget {
  const MTTRScreen(
      {super.key,
      required this.asset_group_id,
      required this.ticketNumber,
      required this.downTime,
      required this.isMttr,
      required this.status});
  final String asset_group_id;
  final String ticketNumber;
  final String downTime, isMttr;
  final String status;

  @override
  State<MTTRScreen> createState() => _MTTRScreenState();
}

class _MTTRScreenState extends State<MTTRScreen> {
  TextEditingController downtimeController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<MttrLists> mttrDetails = [];
  List<TextEditingController> quantityControllers = [];
  // List<MttrData> mttrUpdateDetails = [];
  // List<MttrData> filteredMttrUpdateDetails = [];
  List<MttrLists> filteredMttrDetails = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      MttrRepository().MTTRLists(context, assetGroupId: widget.asset_group_id);
      // MttrRepository().MTTRUpdatedLists(context, ticketId: widget.ticketNumber);
    });
    downTime1 = widget.downTime;
    checkConnection(context);
    searchController = TextEditingController();
    downtimeController = TextEditingController(
        text: _convertToHHMMSS(widget.downTime.toString()));
    quantityControllers = List.generate(
        mttrDetails.length, (index) => TextEditingController(text: '00:00:00'));
    filteredMttrDetails = mttrDetails;
    downtimeController.addListener(() {
      setData();
    });
    searchController.addListener(() {
      _filterMttrList();
    });
    setState(() {});
  }

  setData() {
    setState(() {});
  }

  final isDownTime = SharedUtil().getisdowntime;
  final isMttr = SharedUtil().getisMttr;

  String downTime1 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MTTR',
          style: TextStyle(fontFamily: "Mulish", color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
        iconTheme: const IconThemeData(
          color: const Color(0xF5F5F5F5),
        ),
      ),
      backgroundColor: const Color(0xF5F5F5F5),
      body: Consumer<MttrProvider>(
        builder: (context, mttr, _) {
          mttrDetails = mttr.mttrListsData?.mttrLists ?? [];

          // mttrUpdateDetails = mttr.mttrUpdateData?.mttrData ?? [];

          // if (mttrUpdateDetails.isEmpty) {
          filteredMttrDetails = mttrDetails;
          // Re-initialize quantity controllers
          if (quantityControllers.length != mttrDetails.length) {
            quantityControllers = List.generate(mttrDetails.length,
                (index) => TextEditingController(text: '00:00:00'));
          }
          if (searchController.text.isNotEmpty) {
            filteredMttrDetails = filteredMttrDetails
                .where((mttr) =>
                    mttr.mttrName != null &&
                    mttr.mttrName!
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                .toList();
          }
          // } else {
          //   filteredMttrUpdateDetails = mttrUpdateDetails;
          //   // logger.f(filteredMttrUpdateDetails.length);
          // }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: const Color(0xF5F5F5F5),
                    child: Center(
                      child: Column(
                        children: [
                          _buildDowntimeRow(
                              _convertToHHMMSS(widget.downTime.toString())),
                          const SizedBox(height: 10),
                          _buildSearchField(),
                          const SizedBox(height: 10),
                          Container(
                              color: const Color(0xF5F5F5F5),
                              height: context.heightFull() + 150,
                              // Set a specific height for the list
                              child: mttr.isLoading
                                  ? SingleChildScrollView(
                                      child: const Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: ShimmerLists(
                                          count: 10,
                                          width: double.infinity,
                                          height: 100,
                                          shapeBorder: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                      )),
                                    )
                                  : mttrDetails.isEmpty
                                      ? Center(
                                          child: NoDataScreen(),
                                        )
                                      :
                                      // mttrUpdateDetails.isEmpty
                                      //     ?
                                      ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: filteredMttrDetails.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              elevation: 5,
                                              margin: const EdgeInsets.all(10),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 5),
                                                    _buildTextRow(
                                                        "${filteredMttrDetails[index].mttrName}",
                                                        index),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )
                              // :
                              // ListView.builder(
                              //     physics:
                              //         NeverScrollableScrollPhysics(),
                              //     itemCount: filteredMttrUpdateDetails
                              //         .length,
                              //     itemBuilder: (context, index) {
                              //       int total = 0;
                              //       for (var controller
                              //           in quantityControllers) {
                              //         total += _convertToSeconds(
                              //             controller.text);
                              //       }

                              //       WidgetsBinding.instance
                              //           .addPostFrameCallback((_) {
                              //         totalController.text =
                              //             _convertToHHMMSS(
                              //                 total.toString());
                              //       });

                              //       quantityControllers =
                              //           List.generate(
                              //         mttrUpdateDetails.length,
                              //         (index) =>
                              //             TextEditingController(
                              //           text: convertSecondsToHHMMSS(
                              //               mttrUpdateDetails[index]
                              //                       .mttrValue ??
                              //                   0.0),
                              //         ),
                              //       );
                              //       return Card(
                              //         elevation: 5,
                              //         margin:
                              //             const EdgeInsets.all(10),
                              //         child: Padding(
                              //           padding:
                              //               const EdgeInsets.all(20),
                              //           child: Column(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment
                              //                     .start,
                              //             children: [
                              //               const SizedBox(height: 5),
                              //               _buildTextRow(
                              //                   "${filteredMttrUpdateDetails[index].mttrName}",
                              //                   index),
                              //             ],
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //   ),
                              ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              mttrDetails.isEmpty
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Palette.pureWhite),
                        child: Row(
                          children: [
                            Expanded(
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
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              widget.isMttr == 'yes'
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: _buildSaveButton(context),
                    )
                  : SizedBox.shrink()
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextRow(String label, int index) {
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
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(20))),
            onChanged: (value) {
              // Calculate the total whenever a value changes
              int total = 0;
              for (var controller in quantityControllers) {
                total += _convertToSeconds(controller.text);
              }

              totalController.text = _convertToHHMMSS(total.toString());
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  bool _isLoading = false;

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : isMttr == "no"
              ? () {
                  String downtime = _convertToHHMMSS(widget.downTime);

                  int downtimeInSeconds = _convertToSeconds(downtime);

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Check out'),
                          content:
                              const Text('Are you sure you want Check out ?'),
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
                                        ticketNo:
                                            widget.ticketNumber.toString(),
                                        status_id: '10',
                                        priority: '',
                                        assign_type: '',
                                        downtime_val: _convertToHHMMSS(
                                            downtimeInSeconds.toString()),
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
                              },
                              child: const Text('Check out'),
                            ),
                          ],
                        );
                      });
                }
              : () async {
                  setState(() {
                    _isLoading = true;
                  });

                  // String downtime = _convertToHHMMSS(downtimeController.text);
                  int downtimeInSeconds = int.parse(downTime1);
                  int totalEnteredTimeInSeconds = 0;
                  List<Map<String, dynamic>> jsonList = [];

                  for (var i = 0; i < mttrDetails.length; i++) {
                    String enteredQuantity = quantityControllers[i].text;
                    int enteredTimeInSeconds =
                        _convertToSeconds(enteredQuantity);
                    totalEnteredTimeInSeconds += enteredTimeInSeconds;

                    Map<String, dynamic> mttrJson = {
                      'mttr_name': mttrDetails[i].mttrName,
                      'mttr_id': mttrDetails[i].mttrId,
                      'mttr_value': enteredTimeInSeconds,
                    };

                    jsonList.add(mttrJson);
                  }
                  if (totalEnteredTimeInSeconds != downtimeInSeconds) {
                    setState(() {
                      _isLoading = false;
                    });

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('Error'),
                        content: const Text(
                            'Total entered time does not match downtime.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  String jsonString = jsonEncode(jsonList);
                  print(jsonString);
                  print(widget.ticketNumber.toString());
                  ApiService()
                      .SaveMTTR(
                          ticketNo: widget.ticketNumber.toString(),
                          solution_bank: jsonString)
                      .then((value) {
                    setState(() {
                      _isLoading = false;
                    });

                    if (value.isError == false) {
                      FocusScope.of(context).unfocus();
                      // Future.delayed(const Duration(seconds: 1), () {
                      //   _clearAllTextFields();
                      // });
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
                                            ticketNo:
                                                widget.ticketNumber.toString(),
                                            status_id: '10',
                                            priority: '',
                                            assign_type: '',
                                            downtime_val: _convertToHHMMSS(
                                                downtimeInSeconds.toString()),
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
                                          responseMessage: value.message!);
                                      value.message;
                                    });
                                  },
                                  child: const Text('Check out'),
                                ),
                              ],
                            );
                          });
                      // showMessage(
                      //     context: context,
                      //     isError: value.isError!,
                      //     responseMessage: value.message!);
                      // Navigator.of(context).pop();
                    } else {
                      showMessage(
                          context: context,
                          isError: value.isError!,
                          responseMessage: value.message!);
                    }
                  }).catchError((error) {
                    setState(() {
                      _isLoading = false;
                    });
                  });
                },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text('Save',
              style: TextStyle(fontFamily: "Mulish", color: Colors.white)),
    );
  }

  void clearAllTextFields() {
    for (var controller in quantityControllers) {
      controller.clear();
    }
  }

  Widget _buildDowntimeRow(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
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
          // TextField for entering hours
          Expanded(
            flex: 1,
            child: TextField(
              controller: downtimeController,
              readOnly: isDownTime == 'yes' ? false : true,
              decoration: InputDecoration(
                  labelText: 'HH:mm:ss',
                  labelStyle: TextStyle(
                    fontFamily: "Mulish",
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
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
          hintStyle: TextStyle(fontFamily: "Mulish"),
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

  Widget buildSpareCard(int index, {MttrLists? spare, MttrData? data}) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            _buildTextRow("${spare?.mttrName ?? data?.mttrName}", index),
          ],
        ),
      ),
    );
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

  int _convertToSeconds(String time) {
    final parts = time.split(':');
    if (parts.length != 3) return 0;
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = int.tryParse(parts[2]) ?? 0;
    return (hours * 3600) + (minutes * 60) + seconds;
  }

  String _convertToHHMMSS(String downtime) {
    int totalSeconds = int.tryParse(downtime) ?? 0;
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  String convertSecondsToHHMMSS(double seconds) {
    int totalSeconds = seconds.toInt();
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int secs = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }
}

// class MTTRScreen extends ConsumerStatefulWidget {
//   final String asset_group_id;
//   final String ticketNumber;
//   final String downTime, isMttr;
//   final String status;

//   const MTTRScreen({
//     super.key,
//     required this.asset_group_id,
//     required this.ticketNumber,
//     required this.downTime,
//     required this.status,
//     required this.isMttr,
//   });

//   @override
//   ConsumerState<MTTRScreen> createState() => _MTTRScreenState();
// }

// class _MTTRScreenState extends ConsumerState<MTTRScreen> {
//   TextEditingController downtimeController = TextEditingController();
//   TextEditingController searchController =
//       TextEditingController(); // Search controller
//   List<MttrLists> mttrDetails = [];
//   List<TextEditingController> quantityControllers =
//       []; // Controller for search input
//   List<MttrLists> filteredMttrDetails = [];
//   // bool isSaveButtonEnabled = false;
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       MttrRepository().MTTRLists(context, assetGroupId: widget.asset_group_id);
//     });
//     checkConnection(context);
//     searchController = TextEditingController();
//     downtimeController = TextEditingController(
//         text: _convertToHHMMSS(widget.downTime.toString()));
//     // Add listener to the downtime controller
//     // downtimeController.addListener(() {
//     //   setState(() {
//     //     // Check if the entered value matches the downtime
//     //     isSaveButtonEnabled =
//     //         downtimeController.text == _convertToHHMMSS(widget.downTime);
//     //   });
//     // });
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
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'MTTR',
//           style: TextStyle(fontFamily: "Mulish", color: Colors.white),
//         ),
//         backgroundColor: Color.fromRGBO(30, 152, 165, 1),
//         iconTheme: const IconThemeData(
//           color: const Color(0xF5F5F5F5),
//         ),
//       ),
//       backgroundColor: const Color(0xF5F5F5F5),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Container(
//                 color: const Color(0xF5F5F5F5),
//                 child: Center(
//                   child: Column(
//                     children: [
//                       _buildDowntimeRow(
//                           _convertToHHMMSS(widget.downTime.toString())),
//                       const SizedBox(height: 10),
//                       _buildSearchField(),
//                       const SizedBox(height: 10),
//                       Container(
//                         color: const Color(0xF5F5F5F5),
//                         height: 600, // Set a specific height for the list
//                         child: _buildSparePartsList(),
//                       ),
//                       const SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           widget.isMttr == 'yes'
//               ? Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: _buildSaveButton(context),
//                 )
//               : SizedBox.shrink()
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
//             flex: 2,
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
//               readOnly: widget.isMttr == 'yes' ? false : true,
//               decoration: InputDecoration(
//                   labelText: 'HH:mm:ss',
//                   filled: true,
//                   fillColor: Colors.white,
//                   enabledBorder: UnderlineInputBorder(
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
//         .MTTRLists(assetGroupId: widget.asset_group_id); // use asset_group_id

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
//         } else if (snapshot.hasData && snapshot.data?.mttrLists != null) {
//           mttrDetails = snapshot.data!.mttrLists!;
//           filteredMttrDetails = mttrDetails; // Initialize filtered list

//           // Re-initialize quantity controllers
//           if (quantityControllers.length != mttrDetails.length) {
//             quantityControllers = List.generate(mttrDetails.length,
//                 (index) => TextEditingController(text: '00:00:00'));
//           }
//         } else {
//           return Center(
//             child: NoDataScreen(),
//           );
//         }

//         return ListView.builder(
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: filteredMttrDetails.length,
//           itemBuilder: (context, index) {
//             return _buildSpareCard(filteredMttrDetails[index], index);
//           },
//         );
//       },
//     );
//   }

//   Widget _buildSpareCard(MttrLists spare, int index) {
//     return Card(
//       elevation: 5,
//       margin: const EdgeInsets.all(10),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 5),
//             _buildTextRow(spare.mttrName.toString(), index),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextRow(String label, int index) {
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
//             readOnly: widget.isMttr == 'yes' ? false : true,
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
//               // Optionally handle changes here, e.g., validation
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   bool _isLoading = false;

//   Widget _buildSaveButton(BuildContext context) {
//     return ElevatedButton(
//       onPressed: _isLoading
//           ? null
//           : () async {
//               setState(() {
//                 _isLoading = true;
//               });

//               // Convert the downtime value to seconds
//               String downtime = _convertToHHMMSS(widget.downTime);
//               int downtimeInSeconds = _convertToSeconds(downtime);
//               int totalEnteredTimeInSeconds = 0; // Sum of all entered values
//               List<Map<String, dynamic>> jsonList = [];

//               for (var i = 0; i < mttrDetails.length; i++) {
//                 String enteredQuantity = quantityControllers[i].text;
//                 int enteredTimeInSeconds = _convertToSeconds(enteredQuantity);
//                 totalEnteredTimeInSeconds += enteredTimeInSeconds;

//                 // Create a map for each spare part
//                 Map<String, dynamic> mttrJson = {
//                   'mttr_name': mttrDetails[i].mttrName,
//                   'mttr_id': mttrDetails[i].mttrId,
//                   'mttr_value': enteredTimeInSeconds, // Use total seconds
//                 };

//                 jsonList.add(mttrJson);
//               }

//               // Check if the total entered time matches the downtime
//               if (totalEnteredTimeInSeconds != downtimeInSeconds) {
//                 setState(() {
//                   _isLoading = false; // Stop loading on error
//                 });

//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     backgroundColor: Colors.white,
//                     title: const Text('Error'),
//                     content: const Text(
//                         'Total entered time does not match downtime.'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         child: const Text('OK'),
//                       ),
//                     ],
//                   ),
//                 );
//                 return; // Exit the function if times do not match
//               }

//               String jsonString = jsonEncode(jsonList);
//               print(jsonString);
//               print(widget.ticketNumber.toString());

//               // Save data if validation passes
//               ApiService()
//                   .SaveMTTR(
//                       ticketNo: widget.ticketNumber.toString(),
//                       solution_bank: jsonString)
//                   .then((value) {
//                 setState(() {
//                   _isLoading = false; // Stop loading when save is done
//                 });

//                 if (value.isError == false) {
//                   FocusScope.of(context).unfocus();
//                   // Simulating save success:
//                   Future.delayed(const Duration(seconds: 1), () {
//                     _clearAllTextFields(); // Clear all fields after saving
//                   });
//                   showMessage(
//                       context: context,
//                       isError: value.isError!,
//                       responseMessage: value.message!);
//                   Navigator.of(context).pop();
//                 } else {
//                   showMessage(
//                       context: context,
//                       isError: value.isError!,
//                       responseMessage: value.message!);
//                 }
//               }).catchError((error) {
//                 setState(() {
//                   _isLoading = false; // Stop loading on error
//                 });
//               });
//             },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Color.fromRGBO(30, 152, 165, 1),
//       ),
//       child: _isLoading
//           ? const CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//             )
//           : const Text('Save',
//               style: TextStyle(fontFamily: "Mulish", color: Colors.white)),
//     );
//   }

//   // Method to clear all the TextFields
//   void _clearAllTextFields() {
//     for (var controller in quantityControllers) {
//       controller.clear();
//     }
//   }
// }
