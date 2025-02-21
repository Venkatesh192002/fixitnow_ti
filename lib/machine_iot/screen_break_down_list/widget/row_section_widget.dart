import 'package:auscurator/machine_iot/section_bottom_sheet/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RowSectionWidget extends StatelessWidget {
  const RowSectionWidget(
      {super.key,
      required this.title,
      required this.value,
      this.isSpaceBetween = false});

  final String title;
  final String value;
  final bool isSpaceBetween;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isSpaceBetween
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextWidget(
          title: title,
          fontSize: 16,
          textAlign: Alignment.centerLeft,
          isDefaultPadding: false,
        ),
        const Gap(10),
        Text(value),
      ],
    );
  }
}
