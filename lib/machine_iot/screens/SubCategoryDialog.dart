import 'package:auscurator/main.dart';
import 'package:auscurator/model/SubCategoryModel.dart';
import 'package:auscurator/provider/breakkdown_provider.dart';
import 'package:auscurator/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubCategoryDialog extends StatefulWidget {
  const SubCategoryDialog({super.key});

  @override
  State<SubCategoryDialog> createState() => _SubCategoryDialogState();
}

class _SubCategoryDialogState extends State<SubCategoryDialog> {
  TextEditingController searchController = TextEditingController();
  List<BreakdownCategoryLists> filteredItems = [];

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
    // final companyFuture = ref.watch(apiServiceProvider).getListOfBreadownSub();

    return Consumer<BreakkdownProvider>(
      builder: (context, breakDown, _) {
        List<BreakdownCategoryLists> assetList =
            breakDown.subCategoryData?.breakdownCategoryLists ?? [];
        if (searchController.text.isNotEmpty) {
          assetList = assetList
              .where((asset) =>
                  asset.breakdownSubCategory != null &&
                  asset.breakdownSubCategory!
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()))
              .toList();
        }
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Breakdown',
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
                                  assetList[index].breakdownSubCategory ??
                                      'Unknown Asset',
                                ),
                                onTap: () {
                                  Navigator.pop(context, assetList[index]);
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
                  //       List<BreakdownCategoryLists> assetList =
                  //           snapshot.data!.breakdownCategoryLists!;
                  //       if (searchController.text.isNotEmpty) {
                  //         assetList = assetList
                  //             .where((asset) =>
                  //                 asset.breakdownSubCategory != null &&
                  //                 asset.breakdownSubCategory!
                  //                     .toLowerCase()
                  //                     .contains(searchController.text.toLowerCase()))
                  //             .toList();
                  //       }

                  //       return ListView.builder(
                  //         shrinkWrap: true,
                  //         itemCount: assetList.length,
                  //         itemBuilder: (context, index) {
                  //           return ListTile(
                  //             title: Text(
                  //               assetList[index].breakdownSubCategory ??
                  //                   'Unknown Asset',
                  //             ),
                  //             onTap: () {
                  //               Navigator.pop(context, assetList[index]);
                  //             },
                  //           );
                  //         },
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// class SubCategoryDialog extends ConsumerStatefulWidget {
//   const SubCategoryDialog({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() {
//     return _SubCategoryDialogState();
//   }
// }

// class _SubCategoryDialogState extends ConsumerState {
//   TextEditingController searchController = TextEditingController();
//   List<BreakdownCategoryLists> filteredItems = [];

//   @override
//   void initState() {
//     super.initState();
//     checkConnection(context);
//     searchController.addListener(() {
//       filterItems();
//     });
//   }

//   void filterItems() {
//     setState(() {}); // Trigger a rebuild to filter in the UI
//   }

//   @override
//   Widget build(BuildContext context) {
//     final companyFuture = ref.watch(apiServiceProvider).getListOfBreadownSub();

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
//                 labelText: 'Search Breakdown',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//             ),
//             const Divider(),
//             const SizedBox(height: 5),
//             Expanded(
//               child: FutureBuilder(
//                 future: companyFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Center(child: Text(snapshot.error.toString()));
//                   }

//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (snapshot.data == null ||
//                       snapshot.data!.breakdownCategoryLists == null ||
//                       snapshot.data!.breakdownCategoryLists!.isEmpty) {
//                     return const Center(child: Text("No data available"));
//                   }

//                   // Apply search filter to the asset list
//                   List<BreakdownCategoryLists> assetList =
//                       snapshot.data!.breakdownCategoryLists!;
//                   if (searchController.text.isNotEmpty) {
//                     assetList = assetList
//                         .where((asset) =>
//                             asset.breakdownSubCategory != null &&
//                             asset.breakdownSubCategory!
//                                 .toLowerCase()
//                                 .contains(searchController.text.toLowerCase()))
//                         .toList();
//                   }

//                   return ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: assetList.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(
//                           assetList[index].breakdownSubCategory ??
//                               'Unknown Asset',
//                         ),
//                         onTap: () {
//                           Navigator.pop(context, assetList[index]);
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
