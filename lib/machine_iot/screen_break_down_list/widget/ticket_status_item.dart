import 'package:flutter/material.dart';

class TicketStatusItem extends StatelessWidget {
  const TicketStatusItem(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.itemId,
      required this.onTab});

  final String title;
  final bool isSelected;
  final String itemId;
  final Function(String selectedId) onTab;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () {
        onTab(title);
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isSelected ? Color.fromRGBO(30, 152, 165, 1) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 1)]),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: "Mulish",
              color: isSelected == false
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
