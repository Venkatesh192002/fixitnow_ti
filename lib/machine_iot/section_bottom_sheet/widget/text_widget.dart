import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {super.key,
      required this.title,
      required this.fontSize,
      required this.textAlign,
      this.isDefaultPadding = true,
      this.textColor = Colors.black,
      this.isBold = false});

  final String title;
  final double fontSize;
  final AlignmentGeometry textAlign;
  final bool isDefaultPadding;
  final Color textColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(isDefaultPadding ? 8.0 : 0),
      child: Align(
        alignment: textAlign,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: "Mulish",
            color: textColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
