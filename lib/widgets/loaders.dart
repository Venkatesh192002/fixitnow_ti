import 'package:auscurator/widgets/palette.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  /// Creates a customized [CircularProgressIndicator]
  const Loader({super.key, this.color});

  /// The color of the [CircularProgressIndicator] default color is `Colors.white`
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
          color: color ?? Palette.primary, strokeWidth: 2),
    );
  }
}