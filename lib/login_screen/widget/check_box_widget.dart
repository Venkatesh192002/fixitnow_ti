import 'package:flutter/material.dart';

class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget({super.key});

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool isCheckBoxChecked = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          isCheckBoxChecked = !isCheckBoxChecked;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Colors.grey),
                  color: isCheckBoxChecked ? Colors.green : Colors.transparent),
              child: Center(
                child: Icon(
                  isCheckBoxChecked ? Icons.check : null,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "Remember me",
              style: TextStyle(
                fontFamily: "Mulish",
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
    // return Row(
    //   children: [
    //     SizedBox(
    //       width: 14,
    //       height: 13,
    //       child: Checkbox(
    //         value: isCheckBoxChecked,
    //         onChanged: (isChecked) {
    //           setState(() {
    //             if (isChecked != null) {
    //               isCheckBoxChecked = isChecked;
    //               SharedUtil().setRememberUser(isChecked);
    //             } else {
    //               print("check_box_value_null");
    //             }
    //           });
    //         },
    //         checkColor: Colors.green,
    //         activeColor: Color.fromRGBO(30, 152, 165, 1),
    //       ),
    //     ),
    //     const SizedBox(
    //       width: 10,
    //     ),
    //     const Text(
    //       "Remember me",
    //       style: TextStyle(fontFamily: "Mulish",color: Colors.grey, fontSize: 15),
    //     ),
    //   ],
    // );
  }
}
