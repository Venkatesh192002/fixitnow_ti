import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/size_unit.dart';
import 'package:flutter/material.dart';

Future<void> commonBottomSheet(BuildContext context, child) {
  return showModalBottomSheet<void>(
      isScrollControlled: true,
      useRootNavigator: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Palette.bg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(SizeUnit.borderRadius * 2))),
      context: context,
      builder: (BuildContext context1) => child);
}