import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/model/AssetModel.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/provider/asset_provider.dart';
import 'package:auscurator/provider/breakkdown_provider.dart';
import 'package:auscurator/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSearchDialog extends StatefulWidget {
  const CustomSearchDialog({super.key});

  @override
  State<CustomSearchDialog> createState() => _CustomSearchDialogState();
}

class _CustomSearchDialogState extends State<CustomSearchDialog> {
  TextEditingController searchController = TextEditingController();
  List<AssetLists> filteredItems = [];

  @override
  void initState() {
    super.initState();
    checkConnection(context);
    searchController.addListener(() {
      filterItems();
    });
  }

  void filterItems() {
    setState(() {}); // Trigger a rebuild to filter in the UI
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      child: Consumer<AssetProvider>(
        builder: (context, asset, child) {
          List<AssetLists> assetList = asset.assetModelData?.assetLists ?? [];
          if (searchController.text.isNotEmpty) {
            assetList = assetList
                .where((asset) =>
                    asset.assetCode != null &&
                    asset.assetCode!
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                .toList();
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Equipment ID',
                    labelStyle: TextStyle(
                      fontFamily: "Mulish",
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 5),
                asset.isLoading
                    ? Loader()
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: assetList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                assetList[index].assetCode ?? 'Unknown Asset',
                              ),
                              onTap: () {
                                Navigator.pop(context, assetList[index]);
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomdDropdownDialog extends StatefulWidget {
  const CustomdDropdownDialog({super.key});

  @override
  State<CustomdDropdownDialog> createState() => _CustomdDropdownDialogState();
}

class _CustomdDropdownDialogState extends State<CustomdDropdownDialog> {
  List<AssetLists> filteredItems = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      child: Consumer<BreakkdownProvider>(
        builder: (context, break1, child) {
          // List<RootCauseList> rootCauseList =
              // break1.rootCauseData?.rootCauseLists ?? [];

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // children: [
                // break1.isLoading
                    // ? Loader()
                    // : Expanded(
                    //     child: ListView.builder(
                    //       shrinkWrap: true,
                    //       itemCount: rootCauseList.length,
                    //       itemBuilder: (context, index) {
                    //         return ListTile(
                    //           title: Text(
                    //             "${rootCauseList[index].rootCauseCode}-${rootCauseList[index].rootCauseName}",
                    //           ),
                    //           onTap: () {
                    //             Navigator.pop(context, rootCauseList[index]);
                    //           },
                    //         );
                    //       },
                    //     ),
                    //   ),
              // ],
            ),
          );
        },
      ),
    );
  }
}

class CustomAbnormalityDialog extends StatefulWidget {
  const CustomAbnormalityDialog({super.key});

  @override
  State<CustomAbnormalityDialog> createState() =>
      _CustomAbnormalityDialogState();
}

class _CustomAbnormalityDialogState extends State<CustomAbnormalityDialog> {
  List abnormality = [
    {"value": "jh"},
    {"value": "pm"},
    {"value": "design"},
    {"value": "knowledge"},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      child: Consumer<BreakkdownProvider>(
        builder: (context, break1, child) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                break1.isLoading
                    ? Loader()
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: abnormality.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(capitalizeFirstLetter(
                                  abnormality[index]["value"].toString())),
                              onTap: () {
                                Navigator.pop(context, abnormality[index]);
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
