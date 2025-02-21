import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/size_unit.dart';
import 'package:auscurator/widgets/theme_guided.dart';
import 'package:flutter/material.dart';

class DropDownCustom<T> extends DropdownButtonFormField<T> {
  /// Optional text that describes the input field.
  final String? labelText;

  final bool isNoBorder;
  final EdgeInsets? contentPadding;
  final bool isFilled;

  /// A [DropDownCustom] that contains a [DropdownButton].
  ///
  /// This is a convenience widget that wraps a [DropdownButton] widget in a
  /// [FormField].
  ///
  /// A [Form] ancestor is not required. The [Form] allows one to
  /// save, reset, or validate multiple fields at once. To use without a [Form],
  /// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
  /// save or reset the form field.
  DropDownCustom({
    super.key,
    super.value,
    required super.items,
    required super.onChanged,
    this.labelText,
    this.contentPadding,
    this.isFilled = true,
    this.isNoBorder = false,
  }) : super(
          validator: (input) {
            if (value == null && (labelText ?? '').isNotEmpty) {
              return "$labelText is required";
            }

            return null;
          },
          icon: const Icon(Icons.expand_more_rounded),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              errorStyle: const TextStyle(fontSize: 13, color: Palette.red),
              filled: isFilled,
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              labelText: labelText,
              contentPadding:
                  contentPadding ?? const EdgeInsets.all(SizeUnit.lg),
              border: isNoBorder ? InputBorder.none : ThemeGuide.focussedBorder,
              errorBorder:
                  isNoBorder ? InputBorder.none : ThemeGuide.errorBorder,
              enabledBorder:
                  isNoBorder ? InputBorder.none : ThemeGuide.defaultBorder(),
              focusedBorder:
                  isNoBorder ? InputBorder.none : ThemeGuide.focussedBorder),
        );
}