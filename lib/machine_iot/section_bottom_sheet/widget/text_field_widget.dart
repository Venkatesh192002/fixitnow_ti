import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {super.key,
      required this.width,
      required this.value,
      required this.onChange,
      required this.isSearch});

  final double width;
  final String value;
  final Function(String value) onChange;
  final bool isSearch;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: decoration(context),
          focusedBorder: decoration(context),
          prefixIcon: isSearch ? const Icon(Icons.search) : null,
          floatingLabelBehavior: isSearch ? null : FloatingLabelBehavior.always,
          label: Text(value),
        ),
        maxLines: isSearch ? null : 3,
        onChanged: (value) {
          print('query_inside_text_field');
          onChange(value);
        },
      ),
    );
  }

  OutlineInputBorder decoration(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(35),
      borderSide: BorderSide(
        width: 2,
        color: Color.fromRGBO(30, 152, 165, 1),
      ),
    );
  }
}
