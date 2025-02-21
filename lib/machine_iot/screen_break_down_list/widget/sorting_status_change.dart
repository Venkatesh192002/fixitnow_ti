import 'package:flutter/material.dart';

class SortingStatusChange extends StatefulWidget {
  const SortingStatusChange({super.key,required this.onSortingStatusChange,});

  final Function(bool) onSortingStatusChange;

  @override
  State<SortingStatusChange> createState() => _SortingStatusChangeState();
}

class _SortingStatusChangeState extends State<SortingStatusChange> {
  bool isDescenting = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(isDescenting ? 'Desceding' : 'Ascending'),
        IconButton(
          onPressed: () {
            setState(() {
              isDescenting = !isDescenting;
              widget.onSortingStatusChange(isDescenting);
            });
          },
          icon: const Icon(
            Icons.sort,
          ),
        ),
      ],
    );
  }
}
