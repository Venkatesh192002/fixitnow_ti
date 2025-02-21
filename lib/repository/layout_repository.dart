import 'package:auscurator/provider/layout_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LayoutRepository {
  void changeScreen(int index, BuildContext context) {
    Provider.of<LayoutProvider>(context, listen: false).pageIndex = index;
  }
}
