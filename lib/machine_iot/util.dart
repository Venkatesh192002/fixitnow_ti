import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

void showMessage({
  required BuildContext
      context, // Use rootContext instead of bottom sheet context
  required bool isError,
  required String responseMessage,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          width: 2,
          color: isError
              ? const Color.fromARGB(255, 110, 21, 15)
              : const Color.fromARGB(255, 15, 78, 18),
        ),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            isError ? Icons.thumb_down_rounded : Icons.thumb_up_off_alt_rounded,
            color: isError ? Colors.white : Colors.amber[600],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              responseMessage,
              style: const TextStyle(
                fontFamily: "Mulish",
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void showToast(String message, {bool isError = false}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: isError ? Colors.red : Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Widget expandedListItem(
    {required BuildContext context,
    required String title,
    required String value,
    bool isExpanded = true}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          fontFamily: "Mulish",
          fontWeight: FontWeight.bold,
          color: isExpanded ? Color.fromRGBO(30, 152, 165, 1) : Colors.black,
        ),
      ),
      const Gap(10),
      Text(value)
    ],
  );
}
