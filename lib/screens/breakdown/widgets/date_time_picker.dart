
import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key});
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.day.toString()}-${now.month.toString()}-${now.year.toString()}";
    // String formattedTime = "${now.hour}:${now.minute}";
    return Text(
      formattedDate,
      style: const TextStyle(fontFamily: "Mulish", fontSize: 16.0),
    );
  }
}

class TimePicker extends StatelessWidget {
  const TimePicker({super.key});
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    // String formattedDate =
    //     "${now.day.toString()}-${now.month.toString()}-${now.year.toString()}";
    // String formattedTime = "${now.hour}:${now.minute}";
    var minute = '';
    if (now.minute.toString().length == 1) {
      minute = '0${now.minute.toString()}';
    } else {
      minute = now.minute.toString();
    }
    return Text(
      '${now.hour}:$minute',
      style: const TextStyle(fontFamily: "Mulish", fontSize: 16.0),
    );
  }
}