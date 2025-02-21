import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatDate {
  static String formattedTimeStr(String date, String format) {
    if (date.isEmpty || date == 'null') return '';
    String result;
    DateTime? formattedDate = getFormattedDate(date);
    if (formattedDate == null) return '';
    result = DateFormat(format).format(formattedDate);
    return result;
  }

  static TimeOfDay? strToTime(String date) {
    TimeOfDay? result;
    if (date.isEmpty) return result;
    DateTime? formattedDate = getFormattedDate(date);
    if (formattedDate == null) return result;
    // DateTime temp = DateFormat('hh:mm a').parse(formattedDate);
    result = TimeOfDay.fromDateTime(formattedDate);
    return result;
  }

  static bool isGreater(String date1, String date2) {
    bool result = false;
    if (date1.isEmpty || date2.isEmpty) return result;
    DateTime? formattedDate1 = getFormattedDate(date1);
    DateTime? formattedDate2 = getFormattedDate(date2);
    if (formattedDate1 == null || formattedDate2 == null) return result;
    result = formattedDate2.isAfter(formattedDate1);
    return result;
  }

  static String formattedStr(String date) {
    if (date.isEmpty) return '';
    String result;
    DateTime? formattedDate = getFormattedDate(date);
    if (formattedDate == null) return '';
    result = DateFormat('dd:MM:yyyy').format(formattedDate);
    return result;
  }

  static DateTime? getFormattedDate(String date) {
    DateTime parseDate;
    DateTime? inputDate;
    try {
      parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
      inputDate = DateTime.parse(parseDate.toString());
    } on Exception {
      try {
        parseDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(date);
        inputDate = DateTime.parse(parseDate.toString());
      } on Exception {
        try {
          parseDate = DateFormat("HH:mm:ss").parse(date);
          inputDate = DateTime.parse(parseDate.toString());
        } on Exception {
          try {
            parseDate = DateFormat("hh:mm a").parse(date);
            inputDate = DateTime.parse(parseDate.toString());
          } on Exception {
            //
          }
        }
      }
    }
    return inputDate;
  }

  String dobFormat(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(date);
    DateTime inputDate = DateTime.parse(parseDate.toString());
    String outputDate = DateFormat('MMM-dd-yyyy').format(inputDate);
    return outputDate;
  }

  static String time(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    DateTime inputDate = DateTime.parse(parseDate.toString());
    String outputDate = DateFormat("HH:mm a'").format(inputDate);
    return outputDate;
  }

  static String ddMMMyyyy(String date) {
    try {
      DateTime parseDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
      DateTime inputDate = DateTime.parse(parseDate.toString());
      String outputDate = DateFormat('dd MMM yyyy').format(inputDate);
      return outputDate;
    } on Exception {
      try {
        DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(date);
        DateTime inputDate = DateTime.parse(parseDate.toString());
        String outputDate = DateFormat('dd MMM yyyy').format(inputDate);
        return outputDate;
      } on Exception {
        return date;
      }
    }
  }

  static String hhmmddMMMyyyy(String date) {
    try {
      DateTime parseDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
      DateTime inputDate = DateTime.parse(parseDate.toString());
      String outputDate = DateFormat('hh:mm a, dd MMM yyyy').format(inputDate);
      return outputDate;
    } on Exception {
      try {
        DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(date);
        DateTime inputDate = DateTime.parse(parseDate.toString());
        String outputDate =
            DateFormat('hh:mm a, dd MMM yyyy').format(inputDate);
        return outputDate;
      } on Exception {
        return date;
      }
    }
  }

  static String hhmmssddMMMyyyy(String date) {
    try {
      DateTime parseDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
      DateTime inputDate = DateTime.parse(parseDate.toString());
      String outputDate = DateFormat('hh:mm a, dd MMM yyyy').format(inputDate);
      return outputDate;
    } on Exception {
      try {
        DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(date);
        DateTime inputDate = DateTime.parse(parseDate.toString());
        String outputDate =
            DateFormat('hh:mm:ss a, dd MMM yyyy').format(inputDate);
        return outputDate;
      } on Exception {
        return date;
      }
    }
  }

  String mMMDD(DateTime? date) {
    if (date == null) return "";
    String outputDate = DateFormat('MMM dd').format(date);
    return outputDate;
  }

  String getFormatedDateNew(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    DateTime inputDate = DateTime.parse(parseDate.toString());
    String outputDate = DateFormat('dd MMM yy').format(inputDate);
    return outputDate;
  }

  String getFormatedMonthYear(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    DateTime inputDate = DateTime.parse(parseDate.toString());
    String outputDate = DateFormat('MMM yyyy').format(inputDate);
    return outputDate;
  }

  String getFormatedDateTime(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        .parse(date)
        .add(const Duration(hours: 5, minutes: 30));
    DateTime inputDate = DateTime.parse(parseDate.toString());
    String outputDate = DateFormat('dd-MM-yyyy - hh:mm a').format(inputDate);
    return outputDate;
  }
}