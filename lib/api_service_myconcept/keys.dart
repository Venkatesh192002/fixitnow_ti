import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

AndroidOptions _getAndroidOptions() =>
    const AndroidOptions(encryptedSharedPreferences: true);
final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

//declare logger
var logger = Logger(filter: null, printer: PrettyPrinter(), output: null);

// declare dio logger for api request and response
PrettyDioLogger dioLogger = PrettyDioLogger(
    requestHeader: false,
    requestBody: false,
    responseBody: false,
    responseHeader: false,
    error: false,
    compact: false,
    maxWidth: 200);

GlobalKey<ScaffoldState> mainKey = GlobalKey<ScaffoldState>();

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

