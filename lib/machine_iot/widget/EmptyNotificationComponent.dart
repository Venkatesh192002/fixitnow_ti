import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyNotificationComponent extends StatelessWidget {
  const EmptyNotificationComponent({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('images/notification_emty.svg'),
        const SizedBox(
          height: 5,
        ),
        const Text('No notification found...!')
      ],
    ));
  }
}
