import 'package:flutter/material.dart';

class SqliteListItem extends StatefulWidget {
  const SqliteListItem(
      this.title, this.description, this.id, this.dateTime, this.isChecked,
      {super.key});

  final String title;
  final String description;
  final String id;
  final String dateTime;
  final Function(String checkedBoxId, bool isChecked) isChecked;

  @override
  State<SqliteListItem> createState() => _SqliteListItemState();
}

class _SqliteListItemState extends State<SqliteListItem> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 10,
            )
          ],
        ),
        child: Card(
          margin: const EdgeInsets.all(5),
          surfaceTintColor: Colors.white,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: widget.title == "Running Alert"
                                    ? const Color.fromARGB(255, 1, 121, 5)
                                    : const Color.fromARGB(255, 255, 17, 0),
                                fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: Checkbox(
                                                checkColor: Colors.white,

                        value: isChecked,
                        onChanged: (value) {
                          setState(
                            () {
                              if (value != null) {
                                isChecked = value;
                                widget.isChecked(widget.id.toString(), value);
                              }
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.description)),
                const SizedBox(
                  height: 5,
                ),
                Text("DateAndTime: ${widget.dateTime}")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
