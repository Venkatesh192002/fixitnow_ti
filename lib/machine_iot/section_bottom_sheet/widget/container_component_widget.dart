import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContainerComponent extends StatelessWidget {
  const ContainerComponent({
    super.key,
    required this.width,
    required this.height,
    required this.value,
  });

  final double width;
  final double height;
  final String value;

  @override
  Widget build(BuildContext context) {
    dateAndTime();
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          width: 2,
          color: Color.fromRGBO(30, 152, 165, 1),
        ),
      ),
      child: Center(
        child: Text(
          value.contains(':') && value.contains('-') ? dateAndTime() : value,
          style: const TextStyle(fontFamily: "Mulish", fontSize: 15),
        ),
      ),
    );
  }

  String dateAndTime() {
    DateTime dateTime = DateTime.now();
    final formatter = DateFormat('dd-MM-yyyy hh:mm:ss');
    String formattedDateTime = formatter.format(dateTime);
    print('dateAndTime:- $formattedDateTime');
    return formattedDateTime;
  }
}
