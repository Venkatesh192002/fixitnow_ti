import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeLineWidget extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final dynamic detailsCard;

  const MyTimeLineWidget({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.detailsCard,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
          color: isPast ? Color.fromRGBO(30, 152, 165, 1) : Colors.grey),
      indicatorStyle: IndicatorStyle(
          width: 40,
          color: isPast ? Color.fromRGBO(30, 152, 165, 1) : Colors.grey,
          iconStyle: IconStyle(
              iconData: Icons.done,
              color: isPast ? Colors.white : Colors.grey)),
      endChild: detailsCard,
    );
  }
}

var logger = Logger(
  filter: null,
  printer: PrettyPrinter(),
  output: null,
);
