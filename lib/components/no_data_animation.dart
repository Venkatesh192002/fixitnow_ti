import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoDataScreen extends StatelessWidget {
  final String message;
  final bool? isHeight;

  NoDataScreen(
      {this.message = "No data available at the moment.", this.isHeight});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie Animation
          SizedBox(
            height: isHeight == true ? 150 : 300,
            width: 400,
            child: Lottie.asset('images/no_data_animation.json'),
          ),
          SizedBox(height: 10),
          // Text Message
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Mulish",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
