import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

class CustomImagePicker {
  final ImagePicker picker = ImagePicker();
  Future<File?> pickImage() async {
    File? result;
    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null) return result;
      result = File(file.path);
      return result;
    } on Exception {
      return result;
    }
  }

  Future<bool> getPermission(BuildContext context) async {
    // Map<Permission, PermissionStatus> permissionStatus = await [
    //   Permission.photos,
    //   Permission.camera,
    //   Permission.videos
    // ].request();
    // bool isPermissionDenied = permissionStatus.entries
    //     .any((e) => e.value == PermissionStatus.permanentlyDenied);
    // if (isPermissionDenied) {
    //   showDialog(context: context, builder: (context) => const SettingScreen());
    //   return false;
    // }
    return true;
  }

  Future<File?> pickMedia() async {
    File? result;
    try {
      XFile? file = await picker.pickMedia();
      if (file == null) return result;
      result = File(file.path);
      return result;
    } on Exception {
      return result;
    }
  }

  Future<File?> pickVideo() async {
    File? result;
    try {
      XFile? file = await picker.pickVideo(source: ImageSource.gallery);
      if (file == null) return result;
      result = File(file.path);
      return result;
    } on Exception {
      return result;
    }
  }
}