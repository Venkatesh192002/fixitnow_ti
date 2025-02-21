import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double widthFull() => MediaQuery.of(this).size.width;
  double heightFull() => MediaQuery.of(this).size.height;
  double widthHalf() => MediaQuery.of(this).size.width / 2;
  double heightHalf() => MediaQuery.of(this).size.height / 2;
  double widthQuarter() => MediaQuery.of(this).size.width / 3;
  double heightQuarter() => MediaQuery.of(this).size.height / 3;

  ///[isMobile] Returns true if the screen width is less than 650
  bool isMobile({bool isRotated = false}) =>
      isRotated ? heightFull() < 650 : widthFull() < 650;

  ///[isTablet] Returns true if the screen width is greater than or equal to 650
  bool isTablet() => MediaQuery.of(this).size.width >= 650;

  ///[isDesktop] Returns true if the screen width is greater than or equal to 1100
  bool isDesktop() => MediaQuery.of(this).size.width >= 1100;

  ///[isKeyBoardOpened] Returns true if the screen keyboard is Opened
  bool get isKeyBoardOpened => MediaQuery.of(this).viewInsets.bottom != 0;
}