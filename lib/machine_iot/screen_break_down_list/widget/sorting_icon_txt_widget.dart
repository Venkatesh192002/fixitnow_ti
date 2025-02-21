import 'package:auscurator/machine_iot/section_bottom_sheet/widget/text_widget.dart';
import 'package:flutter/material.dart';

class SortingIconTextWidget extends StatelessWidget {
  const SortingIconTextWidget(
      {super.key,
      required this.iconData,
      required this.value,
      required this.onTab});

  final IconData iconData;
  final String value;
  final Function(String) onTab;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        onTab(value);
      },
      child: Row(
        children: [
          Icon(iconData),
          TextWidget(
            title: value.toString(),
            fontSize: 13,
            textAlign: Alignment.centerLeft,
          )
        ],
      ),
    );
  }
}
