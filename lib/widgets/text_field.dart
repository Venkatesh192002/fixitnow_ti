import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/size_unit.dart';
import 'package:auscurator/widgets/theme_guided.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatefulWidget {
  final TextEditingController controller;

  final String? label, hint;
  final TextInputType? keyboardType;
  final bool isOptional;
  final bool? enabled;
  final int? maxLength, minLines;
  final bool isCaptalizeAll, obscured;
  final Widget? suffix, prefix;
  final String? Function(String? input)? validator;
  final BorderRadius? borderRadius;
  final Function(String)? onChanged;
  final VoidCallback? onTap;

  const TextFormFieldCustom({
    super.key,
    required this.controller,
    this.label,
    this.minLines,
    this.keyboardType,
    this.maxLength,
    this.isOptional = false,
    this.enabled,
    this.validator,
    this.isCaptalizeAll = false,
    this.obscured = false,
    this.suffix,
    required this.hint,
    this.prefix,
    this.borderRadius,
    this.onChanged,
    this.onTap,
  });

  @override
  State<TextFormFieldCustom> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      readOnly: widget.onTap != null,
      onTap: widget.onTap,
      inputFormatters: getInputFormatters,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      obscureText: widget.obscured && !isVisible,
      onChanged: widget.onChanged,
      minLines: widget.minLines,
      maxLines: widget.minLines ?? 1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // validator: (i) {
      //   String input = i ?? '';
      //   // Checks if the field is optional and input is empty
      //   if (!widget.isOptional && input.isEmpty) {
      //     return "The ${widget.label} is required";
      //   }
      //   if (!widget.isOptional &&
      //       widget.keyboardType == TextInputType.emailAddress &&
      //       !input.isEmail) {
      //     return "Kindly enter valid mail";
      //   }
      //   // If the validator is not null custom validation logic to be performed
      //   if (widget.validator != null) {
      //     return widget.validator!(input);
      //   }
      //   // No validation errors
      //   return null;
      // },
      decoration: InputDecoration(
          prefixIcon: widget.prefix,
          counterText: '',
          suffixIcon: suffix,
          errorStyle: const TextStyle(fontSize: 13, color: Palette.red),
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          labelText: widget.label,
          hintText: widget.hint,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: SizeUnit.lg, vertical: SizeUnit.lg),
          border: ThemeGuide.focussedBorder,
          errorBorder: ThemeGuide.errorBorder,
          enabledBorder: ThemeGuide.defaultBorder(color: Palette.muted),
          focusedBorder: ThemeGuide.focussedBorder),
    );
  }

  Widget? get suffix {
    return widget.obscured
        ? InkWell(
            onTap: () {
              isVisible = !isVisible;
              setState(() {});
            },
            child: !isVisible
                ? const Icon(
                    Icons.visibility_off_outlined,
                    size: 18,
                  )
                : const Icon(
                    Icons.visibility_outlined,
                    size: 18,
                  ),
          )
        : widget.suffix;
  }

  List<TextInputFormatter> get getInputFormatters {
    if (widget.keyboardType == TextInputType.number ||
        widget.keyboardType == const TextInputType.numberWithOptions()) {
      return [FilteringTextInputFormatter.digitsOnly];
    }
    if (widget.isCaptalizeAll) {
      return [UpperCaseTextFormatter()];
    }
    if (widget.keyboardType == TextInputType.emailAddress) {
      return [LowerCaseTextFormatter()];
    }
    return <TextInputFormatter>[];
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
