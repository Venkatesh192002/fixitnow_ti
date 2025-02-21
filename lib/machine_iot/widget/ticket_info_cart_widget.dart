import 'package:flutter/material.dart';

class TicketInfoCardWidget extends StatelessWidget {
  final String title;
  final String value;

  const TicketInfoCardWidget(
      {super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${title}",
                style: const TextStyle(
                    fontFamily: "Mulish",
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
              Text(
                ":",
                style: const TextStyle(
                    fontFamily: "Mulish",
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            "${value}",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: "Mulish",
                fontSize: 14),
          ),
        ),
      ],
    );
  }
}
