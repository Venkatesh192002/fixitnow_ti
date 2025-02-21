import 'package:flutter/material.dart';

class DropdownMenuWidget extends StatelessWidget {
  const DropdownMenuWidget(
      {super.key,
      required this.listOfItem,
      required this.selectedItemFun,
      required this.label,
      this.enableSearch = false});
  final List<DropdownMenuEntry> listOfItem;
  final Function(String) selectedItemFun;
  final String label;
  final bool enableSearch;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DropdownMenu(
      width: size.width * 0.95,
      //enableSearch: true,
      enableFilter: true,
      requestFocusOnTap: enableSearch,
      onSelected: (selectedItem) {
        String selectedId = selectedItem.toString();
        selectedItemFun(selectedId);
      },
      label: Text(
        label,
        style: const TextStyle(
            fontFamily: "Mulish", fontSize: 15, color: Colors.black),
      ),
      initialSelection: 'all',
      dropdownMenuEntries: listOfItem,
      inputDecorationTheme: InputDecorationTheme(
          enabledBorder: decration(context), focusedBorder: decration(context)),
      menuHeight: size.height * 0.30,
    );
  }

  OutlineInputBorder decration(BuildContext context) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Color.fromRGBO(30, 152, 165, 1),
      ),
      borderRadius: BorderRadius.circular(25),
    );
  }

  List<DropdownMenuEntry> dummyEntry() {
    List<DropdownMenuEntry> listOfDummy = [];
    listOfDummy.clear();
    listOfDummy.add(const DropdownMenuEntry(value: 0, label: "All"));
    for (var i = 1; i <= 5; i++) {
      listOfDummy.add(DropdownMenuEntry(
        value: i,
        label: 'item $i',
      ));
    }
    return listOfDummy;
  }
}
