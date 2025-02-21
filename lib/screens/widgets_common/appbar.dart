import 'package:flutter/material.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CommonAppBar({
    Key? key,
    required this.title,
    this.leading,
    this.action,
    this.height,
  }) : super(key: key);

  final String title;
  final Widget? leading;
  final double? height;
  final Widget? action;

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}

class _CommonAppBarState extends State<CommonAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.leading,
      title: Text(
        widget.title,
        style: const TextStyle(
          fontFamily: "Mulish",
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: Color.fromRGBO(30, 152, 165, 1),
      iconTheme: const IconThemeData(
        color: Colors.white, // Change your color here
      ),
      actions: widget.action != null ? [widget.action!] : null,
    );
  }
}
