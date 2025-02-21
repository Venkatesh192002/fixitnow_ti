import 'package:auscurator/machine_iot/widget/ticket_info_cart_widget.dart';
import 'package:auscurator/model/worklogdetail_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailCardWidget extends StatelessWidget {
  final bool isPast;
  final BreakdownWorkLogList data;
  // final brea data;
  const DetailCardWidget({
    super.key,
    required this.isPast,
    required this.data,
  });
  @override
  Widget build(BuildContext context) {
    // logger.w(data);
    return Container(
      margin: const EdgeInsets.all(20),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color:
              isPast ? const Color.fromARGB(255, 174, 172, 172) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.grey)]),
      child: Column(
        children: [
          TicketInfoCardWidget(
              title: "${data.type} Date",
              value:
                  "${DateFormat("yyyy-MM-dd").format(DateTime.parse(data.dateTime.toString()))}"),
          const SizedBox(height: 4),
          TicketInfoCardWidget(
              title: "${data.type} Time",
              value:
                  "${DateFormat("hh:mm").format(DateTime.parse(data.dateTime.toString()))}"),
          const SizedBox(height: 4),
          TicketInfoCardWidget(title: 'Status', value: "${data.type}"),
          const SizedBox(height: 4),
          TicketInfoCardWidget(
              title: "Action Done By", value: "${data.loginUserName}"),
          const SizedBox(height: 4),
          TicketInfoCardWidget(
              title: "Engineer", value: "${data.assignedToEngineerName}"),
          const SizedBox(height: 4),
          TicketInfoCardWidget(
              title: 'Comments',
              value: "${data.comment == "" ? "-" : data.comment}"),
        ],
      ),
    );
    // Container(
    //   margin: const EdgeInsets.all(20),
    //   padding: EdgeInsets.all(12),
    //   decoration: BoxDecoration(
    //       color:
    //           isPast ? const Color.fromARGB(255, 174, 172, 172) : Colors.white,
    //       borderRadius: BorderRadius.circular(8),
    //       boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.grey)]),
    //   child: Column(
    //     children: [
    //       TicketInfoCardWidget(
    //         title: data["head1"],
    //         value: data["date"] == null ||
    //                 data["date"] == "" ||
    //                 data["date"] == "1900-01-01T00:00:00"
    //             ? ""
    //             : "${DateFormat("yyyy-MM-dd").format(DateTime.parse(data["date"]))} - ${DateFormat("hh:mm").format(DateTime.parse(data["date"]))}",
    //       ),
    //       const SizedBox(height: 4),
    //       TicketInfoCardWidget(title: 'Status', value: data["status"]),
    //       const SizedBox(height: 4),
    //       TicketInfoCardWidget(
    //           title: 'Comments', value: "${data["comment"] ?? ""}"),
    //       const SizedBox(height: 4),
    //       TicketInfoCardWidget(title: data["head2"], value: data["by"]),
    //     ],
    //   ),
    // );
  }
}
