// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:auscurator/widgets/palette.dart';
import 'package:flutter/material.dart';

commonDialog(BuildContext context, Widget child) {
  return showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        var size = MediaQuery.of(context).size;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Scaffold(
              backgroundColor: Colors.black.withOpacity(.5),
              body: SizedBox(
                height: size.height,
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Palette.pureWhite,
                            borderRadius: BorderRadius.circular(12)),
                        width: size.width - 24,
                        child:
                            Padding(padding: EdgeInsets.all(16), child: child)),
                  ],
                ),
              )),
        );
      });
}

commonDialog1(BuildContext context, Widget child) {
  return showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        var size = MediaQuery.of(context).size;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Scaffold(
              backgroundColor: Palette.backgroundLight.withOpacity(0.25),
              body: SizedBox(
                height: size.height,
                width: size.width,
                // decoration: const BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage('assets/mesh.png'),
                //         opacity: .5,
                //         fit: BoxFit.fill)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: size.width - 24, child: child),
                  ],
                ),
              )),
        );
      });
}

commonBottomSheetReport(BuildContext context, Widget child) =>
    showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          // Wrap your content in SingleChildScrollView
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: child,
          ),
        );
      },
    );
