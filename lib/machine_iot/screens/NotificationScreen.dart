import 'package:auscurator/db/sqlite.dart';
import 'package:auscurator/machine_iot/screen_break_down_list/widget/SqliteListItem.dart';
import 'package:auscurator/model/NotificationListModel.dart';
import 'package:auscurator/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() {
    return _NotificationListState();
  }
}

Future<List<NotificationModel>> getList() async {
  final list = await Sqlite().getNotificationList();
  return list;
}

class _NotificationListState extends ConsumerState<NotificationScreen> {
  List<String> listId = [];
  void checkedBoxId(String id, bool isChecked) {
    if (isChecked == true) {
      listId.add(id);
    }
    if (isChecked == false) {
      listId.remove(id);
    }
  }

  bool isSelectAllChecked = false;
  bool isAscentingOrder = false;
  //Row rowOrColumn = const Row();
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Notification",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white, fontSize: 20),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Color.fromRGBO(30, 152, 165, 1),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      elevation: 7,
                      title: const Text(
                        "Delete",
                        style:
                            TextStyle(fontFamily: "Mulish", color: Colors.red),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Do you want to delete?"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Sqlite().deleteAll();
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text("All Notification"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    for (final element in listId) {
                                      Sqlite().deleteItem(element);
                                    }
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text(
                                  "Selected Only Notification",
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancel",
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: getList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data == null) {
              return const Center(
                child: Text("No notification found :("),
              );
            }

            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No notification found :("),
              );
            }

            final List<NotificationListModel> list = [];
            for (final element in snapshot.data!) {
              list.add(
                NotificationListModel(
                  title: element.title.toString(),
                  description: element.description.toString(),
                  dateAndTime: element.dateTime.toString(),
                  id: element.id.toString(),
                ),
              );
            }

            if (isAscentingOrder == true) {
              list.sort(
                (a, b) => a.dateAndTime.compareTo(b.dateAndTime),
              );
            }
            if (isAscentingOrder == false) {
              list.sort(
                (b, a) => a.dateAndTime.compareTo(b.dateAndTime),
              );
            }

            return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      IconButton(
                        icon: Icon(isAscentingOrder == false
                            ? Icons.arrow_downward
                            : Icons.arrow_upward),
                        onPressed: () {
                          setState(() {
                            isAscentingOrder = !isAscentingOrder;
                          });
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: list.length,
                      shrinkWrap: false,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (ctx, index) {
                        return SqliteListItem(
                          list[index].title.toString(),
                          list[index].description.toString(),
                          list[index].id.toString(),
                          list[index].dateAndTime.toString(),
                          checkedBoxId,
                        );
                      },
                    ),
                  ),
                ]);
          },
        ));
  }
}
