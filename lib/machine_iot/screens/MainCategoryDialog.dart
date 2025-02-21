import 'package:auscurator/main.dart';
import 'package:auscurator/model/MainCategoryModel.dart';
import 'package:auscurator/provider/breakkdown_provider.dart';
import 'package:auscurator/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainCategoryDialog extends StatefulWidget {
  const MainCategoryDialog({super.key});

  @override
  State<MainCategoryDialog> createState() => _MainCategoryDialogState();
}

class _MainCategoryDialogState extends State<MainCategoryDialog> {
  TextEditingController searchController = TextEditingController();
  List<MainBreakdownCategoryLists> filteredItems = [];

  @override
  void initState() {
    checkConnection(context);
    searchController.addListener(() {
      filterItems();
    });
    super.initState();
  }

  void filterItems() {
    setState(() {}); // Trigger a rebuild to filter in the UI
  }

  @override
  Widget build(BuildContext context) {
    // final companyFuture = ref.watch(apiServiceProvider).getListOfIssue();

    return Consumer<BreakkdownProvider>(
      builder: (context, breakDown, _) {
        List<MainBreakdownCategoryLists> assetList =
            breakDown.mainCategoryData?.breakdownCategoryLists ?? [];

        if (searchController.text.isNotEmpty) {
          assetList = assetList
              .where((asset) =>
                  asset.breakdownCategoryName != null &&
                  asset.breakdownCategoryName!
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()))
              .toList();
        }
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Breakdown Category',
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
                breakDown.isLoading
                    ? Loader()
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: assetList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                assetList[index].breakdownCategoryName ??
                                    'Unknown Asset',
                              ),
                              onTap: () {
                                Navigator.pop(context, assetList[index]);
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                // Expanded(
                //   child: FutureBuilder(
                //     future: companyFuture,
                //     builder: (context, snapshot) {
                //       if (snapshot.hasError) {
                //         return Center(child: Text(snapshot.error.toString()));
                //       }

                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return const Center(child: CircularProgressIndicator());
                //       }

                //       if (snapshot.data == null ||
                //           snapshot.data!.breakdownCategoryLists == null ||
                //           snapshot.data!.breakdownCategoryLists!.isEmpty) {
                //         return const Center(child: Text("No data available"));
                //       }

                //       // Apply search filter to the asset list
                //       List<MainBreakdownCategoryLists> assetList =
                //           snapshot.data!.breakdownCategoryLists!;
                //       if (searchController.text.isNotEmpty) {
                //         assetList = assetList
                //             .where((asset) =>
                //                 asset.breakdownCategoryName != null &&
                //                 asset.breakdownCategoryName!
                //                     .toLowerCase()
                //                     .contains(searchController.text.toLowerCase()))
                //             .toList();
                //       }

                // return ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: assetList.length,
                //   itemBuilder: (context, index) {
                //     return ListTile(
                //       title: Text(
                //         assetList[index].breakdownCategoryName ??
                //             'Unknown Asset',
                //       ),
                //       onTap: () {
                //         Navigator.pop(context, assetList[index]);
                //       },
                //     );
                //   },
                // );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class MainCategoryDialog extends ConsumerStatefulWidget {
//   const MainCategoryDialog({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() {
//     return _MainCategoryDialogState();
//   }
// }

// class _MainCategoryDialogState extends ConsumerState {
//   TextEditingController searchController = TextEditingController();
//   List<MainBreakdownCategoryLists> filteredItems = [];

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       BreakdownRepository().getListOfIssue(context);
//     });
//     checkConnection(context);
//     searchController.addListener(() {
//       filterItems();
//     });
//     super.initState();
//   }

//   void filterItems() {
//     setState(() {}); // Trigger a rebuild to filter in the UI
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final companyFuture = ref.watch(apiServiceProvider).getListOfIssue();

//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       backgroundColor: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search Breakdown Category',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//             ),
//             const Divider(),
//             const SizedBox(height: 5),

//             // Expanded(
//             //   child: FutureBuilder(
//             //     future: companyFuture,
//             //     builder: (context, snapshot) {
//             //       if (snapshot.hasError) {
//             //         return Center(child: Text(snapshot.error.toString()));
//             //       }

//             //       if (snapshot.connectionState == ConnectionState.waiting) {
//             //         return const Center(child: CircularProgressIndicator());
//             //       }

//             //       if (snapshot.data == null ||
//             //           snapshot.data!.breakdownCategoryLists == null ||
//             //           snapshot.data!.breakdownCategoryLists!.isEmpty) {
//             //         return const Center(child: Text("No data available"));
//             //       }

//             //       // Apply search filter to the asset list
//             //       List<MainBreakdownCategoryLists> assetList =
//             //           snapshot.data!.breakdownCategoryLists!;
//             //       if (searchController.text.isNotEmpty) {
//             //         assetList = assetList
//             //             .where((asset) =>
//             //                 asset.breakdownCategoryName != null &&
//             //                 asset.breakdownCategoryName!
//             //                     .toLowerCase()
//             //                     .contains(searchController.text.toLowerCase()))
//             //             .toList();
//             //       }

//             //       return ListView.builder(
//             //         shrinkWrap: true,
//             //         itemCount: assetList.length,
//             //         itemBuilder: (context, index) {
//             //           return ListTile(
//             //             title: Text(
//             //               assetList[index].breakdownCategoryName ??
//             //                   'Unknown Asset',
//             //             ),
//             //             onTap: () {
//             //               Navigator.pop(context, assetList[index]);
//             //             },
//             //           );
//             //         },
//             //       );
//             //     },
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
