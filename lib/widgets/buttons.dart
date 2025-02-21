import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/size_unit.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:auscurator/widgets/text_widget.dart';
import 'package:auscurator/widgets/theme_guided.dart';
import 'package:flutter/material.dart';

import 'loaders.dart';

class ButtonPrimary extends ElevatedButton {
  /// Creates a Material Design elevated button.
  ButtonPrimary({
    super.key,
    required void Function()? onPressed,
    required String label,
    double? size,
    bool isLoading = false,
    Color backgroundColor = Colors.blue, // Default color
  }) : super(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Color.fromRGBO(30, 152, 165, 1), // Set background color
            foregroundColor: Colors.white, // Set text/icon color
            // ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(SizeUnit.lg),
            child: isLoading
                ? const Loader(color: Palette.pureWhite)
                : TextCustom(
                    label,
                    size: size ?? 16,
                    color: Palette.pureWhite,
                    fontWeight: FontWeight.w700,
                  ),
          ),
          onPressed: isLoading ? null : onPressed,
        );
}

class ButtonOutlined extends OutlinedButton {
  /// Creates a Material Design outlined button.
  ButtonOutlined(
      {super.key,
      required void Function()? onPressed,
      required String label,
      Widget? icon,
      double? padding,
      double? size,
      bool isLoading = false})
      : super(
            child: Padding(
              padding: const EdgeInsets.all(SizeUnit.lg),
              child: isLoading
                  ? const Loader()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[icon, const WidthFull()],
                        TextCustom(
                          label,
                          size: size ?? 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
            ),
            onPressed: isLoading ? () {} : onPressed);
}

class DoubleButton extends StatelessWidget {
  const DoubleButton(
      {super.key,
      required this.primaryLabel,
      required this.secondarylabel,
      required this.primaryOnTap,
      required this.secondaryOnTap,
      this.isLoading = false});
  final String primaryLabel, secondarylabel;
  final VoidCallback primaryOnTap, secondaryOnTap;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        height: 54,
        duration: const Duration(milliseconds: 400),
        decoration: ThemeGuide.cardDecoration(color: color),
        alignment: Alignment.center,
        padding: EdgeInsets.all(isLoading ? SizeUnit.lg : 0),
        child: isLoading
            ? const Loader(color: Palette.pureWhite)
            : Row(children: [
                Expanded(
                  child: ButtonOutlined(
                      onPressed: secondaryOnTap,
                      label: secondarylabel,
                      isLoading: isLoading),
                ),
                const WidthFull(),
                Expanded(
                  child: ButtonPrimary(
                      onPressed: primaryOnTap,
                      label: primaryLabel,
                      isLoading: isLoading),
                ),
              ]));
  }

  Color get color => isLoading ? Palette.primary : Colors.transparent;
}

class ButtonSecondary extends FilledButton {
  /// Creates a Material Design filled button.
  ButtonSecondary(
      {super.key,
      required void Function()? onPressed,
      required String label,
      bool isLoading = false})
      : super(
            child: Padding(
              padding: const EdgeInsets.all(SizeUnit.lg),
              child: isLoading
                  ? const Loader()
                  : TextCustom(label,
                      size: 16,
                      fontWeight: FontWeight.bold,
                      color: Palette.pureWhite),
            ),
            onPressed: isLoading ? () {} : onPressed);
}

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox(
      {super.key,
      this.title = '',
      required this.value,
      required this.onChanged});
  final String title;
  final bool value;
  final VoidCallback onChanged;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged,
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
              color: boxColor,
              border: Border.all(color: borderColor, width: 1.5),
              borderRadius: ThemeGuide.borderRadius(radius: SizeUnit.sm / 2)),
          child: const Icon(Icons.check, color: Palette.pureWhite, size: 16),
        ),
        if (title.isNotEmpty) ...[
          const WidthHalf(),
          TextCustom(title,
              color: Palette.secondary, fontWeight: FontWeight.bold)
        ]
      ]),
    );
  }

  Color get boxColor => value ? Palette.primary : Palette.pureWhite;
  Color get borderColor => value ? Palette.primary : Palette.secondary;
}

class SecondaryIconButton extends IconButton {
  SecondaryIconButton(BuildContext context,
      {super.key, required super.onPressed, required super.icon})
      : super(
          style: IconButtonTheme.of(context).style?.copyWith(
              foregroundColor: const WidgetStatePropertyAll(Palette.pureWhite),
              backgroundColor:
                  WidgetStatePropertyAll(Palette.dark.withOpacity(.2))),
        );
}
