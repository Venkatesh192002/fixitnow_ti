import 'dart:io';
import 'package:auscurator/widgets/buttons.dart';
import 'package:auscurator/widgets/context_extension.dart';
import 'package:auscurator/widgets/custom_image_picker.dart';
import 'package:auscurator/widgets/networkimagecus.dart';
import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/size_unit.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:auscurator/widgets/text_widget.dart';
import 'package:auscurator/widgets/theme_guided.dart';
import 'package:flutter/material.dart';

class MediaPicker extends StatelessWidget {
  const MediaPicker(
      {super.key,
      required this.title,
      required this.onPicked,
      this.file,
      this.networkImage = '',
      this.onRemovedNetworkImage,
      this.size,
      this.isVideoOnly = false,
      this.isMultiMedia = false});

  final File? file;
  final bool isMultiMedia, isVideoOnly;
  final String title, networkImage;
  final Function(File?) onPicked;
  final VoidCallback? onRemovedNetworkImage;
  final double? size;

  Column imagePicker() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Palette.primary.withOpacity(.3), shape: BoxShape.circle),
        child: const Padding(
          padding: EdgeInsets.all(SizeUnit.md),
          child: Icon(Icons.add, color: Palette.primary, size: 32),
        ),
      ),
      const HeightFull(),
      TextCustom(title,
          color: Palette.secondary, size: 16, fontWeight: FontWeight.w400)
    ]);
  }

  Widget removeImage(BuildContext context) {
    if (file == null && networkImage.isEmpty) return const SizedBox();
    return SecondaryIconButton(context,
        onPressed:
            networkImage.isEmpty ? () => onPicked(null) : onRemovedNetworkImage,
        icon: const Icon(Icons.close));
  }

  void pickImage(BuildContext context) async {
    File? file = await picker(context);
    if (file == null) return;
    onPicked(file);
  }

  Future<File?> picker(BuildContext context) async {
    if (isMultiMedia) return await CustomImagePicker().pickMedia();
    if (isVideoOnly) return await CustomImagePicker().pickVideo();
    return await CustomImagePicker().pickImage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topRight, children: [
      InkWell(
        onTap: () => pickImage(context),
        child: Container(
          height: size ?? 250,
          width: size ?? context.widthFull(),
          clipBehavior: Clip.antiAlias,
          decoration: ThemeGuide.cardDecoration(),
          child: file != null
              ? Image.file(file!, fit: BoxFit.cover)
              : networkImage.isNotEmpty
                  ? NetworkImageCustom(logo: networkImage)
                  : imagePicker(),
        ),
      ),
      removeImage(context)
    ]);
  }
}