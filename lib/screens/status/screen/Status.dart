// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/model/AssetModel.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/model/EmployeeListModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class Status extends ConsumerStatefulWidget {
  const Status({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _StatusState();
  }
}

class _StatusState extends ConsumerState {
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
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    final companyFuture =
        ref.watch(apiServiceProvider).getEmployeeList(userAvail: '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineer Status',
            style: TextStyle(fontFamily: "Mulish", color: Colors.white)),
        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Engineer',
                    labelStyle: TextStyle(
                      fontFamily: "Mulish",
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
          const SizedBox(height: 5),
          FutureBuilder(
            future: companyFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ShimmerLists(
                    count: 4,
                    width: double.infinity,
                    height: 100,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ));
              }

              if (snapshot.data == null ||
                  snapshot.data!.employeeLists == null ||
                  snapshot.data!.employeeLists!.isEmpty) {
                return Center(
                  child: NoDataScreen(),
                );
              }

              List<EmployeeLists> assetList = snapshot.data!.employeeLists!;
              if (searchController.text.isNotEmpty) {
                assetList = assetList
                    .where((asset) =>
                        asset.employeeName != null &&
                        asset.employeeName!
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                    .toList();
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: assetList.length,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      FadeInRight(
                        delay: Duration(milliseconds: index * 150),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                  offset: Offset(0, 8),
                                ),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          assetList[index].status == 'active' ||
                                                  assetList[index]
                                                          .userAvailability ==
                                                      "yes"
                                              ? Colors.green
                                              : Colors.red),
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  assetList[index].employeeName.toString(),
                                  style: TextStyle(
                                    fontFamily: "Mulish",
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(30, 152, 165, 1),
                                  ),
                                ),
                              ]),
                              const Gap(5),
                              Text(
                                assetList[index].department ?? '',
                                style: const TextStyle(
                                    fontFamily: "Mulish", color: Colors.grey),
                                maxLines: 5,
                              ),
                              const Gap(5),
                              Text(assetList[index].status.toString()),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12)
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
