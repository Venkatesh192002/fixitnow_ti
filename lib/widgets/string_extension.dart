import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';


extension StringExtension on String {
  bool get isEmail {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  String hideMobile() {
    String input = this;
    if (input.length != 10) {
      throw ArgumentError('Input string must be exactly 10 characters long');
    }

    const String hidden = '******';
    final String prefix = input.substring(0, 2);
    final String suffix = input.substring(8, 10);

    return '$prefix$hidden$suffix';
  }

  String money() {
    return "\u{20B9}$this";
  }

  String get onlyNumbers {
    return replaceAll(RegExp('[^-0-9]'), '');
  }

  String ifEmpty(String val) {
    if (isNullOrEmpty) return val;
    return this;
  }

  int get toInt {
    return int.parse(onlyNumbers);
  }

 

  Color get toColor {
    String temp = this;
    if (contains('#')) temp = substring(1, 7);
    return Color(int.parse(temp, radix: 16) + 0xFF000000);
  }

  Uint8List get base64Decode => const Base64Decoder().convert(this);

  String get camelToNormal {
    if (isEmpty || this == 'null') {
      return '';
    }
    try {
      List<String> words = split(RegExp(r"(?=[A-Z])"));
      String updatedString = words.join(' ');
      updatedString = updatedString.substring(0, 1).toUpperCase() +
          updatedString.substring(1);
      return updatedString;
    } on Exception {
      return this;
    }
  }

  String get snakeToNormal {
    return "${this[0].toUpperCase()}${substring(1)}"
        .replaceAll(RegExp(r'(_|-)+'), ' ');
  }

  

  String? get nullIfEmpty {
    String? result = isEmpty ? null : this;
    return result;
  }

  String get emptyIfNull {
    String result = this == 'null' ? '' : this;
    return result;
  }

  bool get isNullOrEmpty {
    bool result = this == 'null' || isEmpty;
    return result;
  }

  

  String prefix(String val) {
    return isNullOrEmpty ? '' : '$val$this';
  }

  
}