import 'package:auscurator/widgets/palette.dart';
import 'package:flutter/material.dart';

class TextCustom extends StatelessWidget {
  final String value;
  final double? size;
  final Color? color;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? align;
  final TextDecoration? decoration;
  final double? height;
  const TextCustom(
    this.value, {
    super.key,
    this.size,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.align,
    this.decoration,
    this.height,
  });
  @override
  Widget build(BuildContext context) {
    double fontSize = (size ?? 14);
    return Text(
      value,
      maxLines: maxLines ?? 10000,
      overflow: TextOverflow.ellipsis,
      textAlign: align,
      style: TextStyle(
          fontFamily: "Mulish",
          fontSize: fontSize,
          color: color??Palette.dark,
          fontWeight: fontWeight,
          decoration: decoration,
          height: height),
    );
  }
}
