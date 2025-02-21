// ignore_for_file: unused_local_variable

import 'package:auscurator/machine_iot/section_bottom_sheet/widget/text_widget.dart';
import 'package:auscurator/machine_iot/widget/ticket_info_cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/machine_iot/util.dart';

class TicketListItem extends StatelessWidget {
  TicketListItem({
    super.key,
    required this.width,
    required this.titleSize,
    required this.ticketNumber,
    required this.ticketStatus,
    required this.machineName,
    required this.machineIssue,
    required this.machineLocation,
    required this.machineRaisedBy,
    required this.machineAssinedTo,
    required this.dateAndTime,
  });

  final double width;
  final double titleSize;
  final String ticketNumber;
  final String ticketStatus;
  final String machineName;
  final String machineIssue;
  final String machineLocation;
  final String machineRaisedBy;
  final String machineAssinedTo;
  final String dateAndTime;
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            left: BorderSide(
              width: 5,
              color: Colors.blue,
            ),
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                title: ticketNumber,
                fontSize: titleSize,
                textAlign: Alignment.centerLeft,
                isDefaultPadding: false,
                textColor: Theme.of(context).colorScheme.primary,
              ),
              Row(
                children: [
                  const TextWidget(
                    title: ("on progress"),
                    fontSize: 16,
                    textAlign: Alignment.centerLeft,
                    isDefaultPadding: false,
                    textColor: Colors.red,
                    isBold: false,
                  ),
                  const Text(' | '),
                  TextWidget(
                    title: ticketStatus.split('|')[0],
                    fontSize: 16,
                    textAlign: Alignment.centerLeft,
                    isDefaultPadding: false,
                    textColor: Colors.blue,
                    isBold: false,
                  ),
                ],
              ),
            ],
          ),
          Text(machineName),
          const Gap(5),
          Text(
            machineIssue == '' ? 'no issue' : machineIssue,
            style: const TextStyle(fontFamily: "Mulish", fontSize: 16),
          ),
          const Gap(10),
          TicketInfoCardWidget(title: 'Location:', value: machineLocation),
          const Gap(10),
          TicketInfoCardWidget(title: 'Raised By:', value: machineRaisedBy),
          const Gap(10),
          TicketInfoCardWidget(title: 'Assigned To:', value: machineAssinedTo),
          const Gap(10),
          TicketInfoCardWidget(title: 'Date And Time:', value: dateAndTime),
          const Gap(10),
          const Divider(),
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
                              backgroundColor: Colors.white,
                              title: const Text(
                                'Please enter your valid reason...',
                                style: TextStyle(
                                    fontFamily: "Mulish",
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Enter Reason',
                                      labelStyle: const TextStyle(
                                          fontFamily: "Mulish",
                                          color: Colors.black),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0))),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
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
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(21, 147, 159, 1),
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
                      icon: const Icon(Icons.chat_outlined),
                      color: Colors.black,
                      iconSize: 24),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: const Text(
                                'Are you sure you  want to Acknowledge this ticket?',
                                style: TextStyle(
                                    fontFamily: "Mulish",
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
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
                                    // Perform re-assign action here using textFieldController.text
                                    String reassignComment =
                                        _textFieldController.text;
                                    ApiService()
                                        .ReAssignEngineer(
                                            ticketNo: ticketNumber,
                                            employee_id: "1",
                                            reassign_comment: "",
                                            status_id: "18")
                                        .then((value) {
                                      if (value.isError == false) {
                                        Navigator.pop(context);
                                      }
                                      showMessage(
                                          context: context,
                                          isError: value.isError!,
                                          responseMessage: value.message!);
                                      value.message;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(21, 147, 159, 1),
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
                      icon: const Icon(Icons.thumb_up_alt_outlined),
                      color: Colors.black,
                      iconSize: 24),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: const Text('Reason For Re-Open...',
                                  style: TextStyle(
                                      fontFamily: "Mulish",
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Enter Reason',
                                      labelStyle: const TextStyle(
                                          fontFamily: "Mulish",
                                          color: Colors.black),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0))),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
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
                                    // Perform re-assign action here using textFieldController.text
                                    String reassignComment =
                                        _textFieldController.text;
                                    ApiService()
                                        .ReAssignEngineer(
                                            ticketNo: ticketNumber,
                                            employee_id: "1",
                                            reassign_comment: reassignComment,
                                            status_id: "19")
                                        .then((value) {
                                      if (value.isError == false) {
                                        Navigator.pop(context);
                                      }
                                      showMessage(
                                          context: context,
                                          isError: value.isError!,
                                          responseMessage: value.message!);
                                      value.message;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(21, 147, 159, 1),
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
                      icon: const Icon(Icons.thumb_down_off_alt_sharp),
                      color: Colors.black,
                      iconSize: 24),
                ]),
          ),
        ],
      ),
    );
  }
}
