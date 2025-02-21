import 'dart:convert';
import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/model/SpareListsModel.dart';
import 'package:auscurator/provider/spare_provider.dart';
import 'package:auscurator/repository/spare_repository.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpareScreen extends StatefulWidget {
  const SpareScreen(
      {super.key,
      required this.ticketNumber,
      required this.asset_id,
      required this.asset_group_id});
  final String ticketNumber;
  final String asset_id;
  final String asset_group_id;

  @override
  State<SpareScreen> createState() => _SpareScreenState();
}

List<ValueNotifier<bool>> checkboxStates = []; // List of ValueNotifiers

class _SpareScreenState extends State<SpareScreen> {
  List<ValueNotifier<String>> quantityValuesMapped = [];
  List<ValueNotifier<String>> quantityValuesgeneral = [];
  List<ValueNotifier<bool>> checkboxStatesMapped = []; // List of ValueNotifiers
  List<ValueNotifier<bool>> checkboxStatesgeneral =
      []; // List of ValueNotifiers

  List<SparesLists> generalSpareDetails = [];
  List<SparesLists> overallSpareLists = [];
  List<SparesLists> mappedSpareDetails = [];
  List<TextEditingController> quantityControllersMapped = [];
  List<TextEditingController> quantityControllersGeneral = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController searchController1 = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SpareRepository().spareLists(context,
          assetGroupId: widget.asset_group_id, assetId: widget.asset_id);
    });
    searchController.addListener(() {
      filterItems();
    });
    searchController1.addListener(() {
      filterItems();
    });
    super.initState();
  }

  void filterItems() {
    setState(() {}); // Trigger a rebuild to filter in the UI
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Spares',
            style: TextStyle(fontFamily: "Mulish", color: Colors.white),
          ),
          backgroundColor: Color.fromRGBO(30, 152, 165, 1),
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.build_circle_sharp), // Icon for the first tab
                      SizedBox(width: 5.0),
                      Text('Mapped Spares'), // Text for the first tab
                    ],
                  ),
                ),
              ),
              Tab(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.build_circle_sharp), // Icon for the second tab
                      SizedBox(width: 5.0),
                      Text('General Spares'), // Text for the second tab
                    ],
                  ),
                ),
              ),
            ],
            indicatorColor:
                Colors.white, // Indicator color when tab is selected
            labelColor: Colors.white, // Text color when tab is selected
            unselectedLabelColor:
                Colors.grey, // Text color when tab is not selected
            labelStyle: TextStyle(
                fontFamily: "Mulish",
                fontSize: 14.0), // Style for selected text
            unselectedLabelStyle: TextStyle(
                fontFamily: "Mulish",
                fontSize: 14.0), // Style for unselected text
            // Icon color when tab is not selected
          ),
        ),
        body: Consumer<SpareProvider>(
          builder: (context, spare, _) {
            // // Clear the lists to avoid duplicate entries
            mappedSpareDetails.clear();
            generalSpareDetails.clear();
            overallSpareLists = spare.spareListData?.sparesLists ?? [];

            for (var element in overallSpareLists) {
              if (element.type == "mapping") {
                mappedSpareDetails.add(element);
              } else {
                generalSpareDetails.add(element);
              }
            }

            if (checkboxStatesgeneral.length != generalSpareDetails.length) {
              checkboxStatesgeneral = List.generate(
                  generalSpareDetails.length, (index) => ValueNotifier(false));
              quantityValuesgeneral = List.generate(generalSpareDetails.length,
                  (index) => ValueNotifier('')); // Initialize quantity values
            }
            if (quantityControllersGeneral.length !=
                generalSpareDetails.length) {
              quantityControllersGeneral =
                  List.generate(generalSpareDetails.length, (index) {
                // logger.i(quantityValuesgeneral[index].value);
                return TextEditingController(
                    text: quantityValuesgeneral[index].value);
              }); // Initialize controllers
            }

            if (searchController1.text.isNotEmpty) {
              generalSpareDetails = generalSpareDetails
                  .where((spare) =>
                      spare.spareName != null &&
                      spare.spareName!
                          .toLowerCase()
                          .contains(searchController1.text.toLowerCase()))
                  .toList();
            }

            // Initialize checkbox states and quantity values only if the length changes
            if (checkboxStatesMapped.length != mappedSpareDetails.length) {
              checkboxStatesMapped = List.generate(
                  mappedSpareDetails.length, (index) => ValueNotifier(false));
              quantityValuesMapped = List.generate(mappedSpareDetails.length,
                  (index) => ValueNotifier('')); // Initialize quantity values
            }
            if (quantityControllersMapped.length != mappedSpareDetails.length) {
              quantityControllersMapped = List.generate(
                  mappedSpareDetails.length,
                  (index) => TextEditingController(
                      text: quantityValuesMapped[index]
                          .value)); // Initialize controllers
            }

            if (searchController.text.isNotEmpty) {
              mappedSpareDetails = mappedSpareDetails
                  .where((spare) =>
                      spare.spareName != null &&
                      spare.spareName!
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()))
                  .toList();
            }

            return TabBarView(
              children: [
                // Contents of the first tab (Mapped Spares)
                Container(
                  color: const Color(0xF5F5F5F5),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _buildSearchField(),
                        const SizedBox(height: 10),
                        spare.isLoading
                            ? Expanded(
                                child: SingleChildScrollView(
                                  child: const Center(
                                      child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: ShimmerLists(
                                      count: 10,
                                      width: double.infinity,
                                      height: 300,
                                      shapeBorder: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                    ),
                                  )),
                                ),
                              )
                            : mappedSpareDetails.isEmpty
                                ? Center(
                                    child: NoDataScreen(),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      itemCount: mappedSpareDetails.length,
                                      itemBuilder: (context, index) {
                                        return _buildSpareCardMapped(
                                            mappedSpareDetails[index], index);
                                      },
                                    ),
                                  ),
                        const SizedBox(height: 10),
                        if (mappedSpareDetails.isNotEmpty) ...[
                          _buildSaveMappedButton(context)
                        ],
                      ],
                    ),
                  ),
                ),
                // Contents of the second tab (General Spares)
                Container(
                  color: const Color(0xF5F5F5F5),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _buildSearchField1(),
                        const SizedBox(height: 10),
                        spare.isLoading
                            ? Expanded(
                                child: SingleChildScrollView(
                                  child: const Center(
                                      child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: ShimmerLists(
                                      count: 10,
                                      width: double.infinity,
                                      height: 300,
                                      shapeBorder: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                    ),
                                  )),
                                ),
                              )
                            : generalSpareDetails.isEmpty
                                ? Center(
                                    child: NoDataScreen(),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      itemCount: generalSpareDetails.length,
                                      itemBuilder: (context, index) {
                                        return _buildSpareCardGeneral(
                                            generalSpareDetails[index], index);
                                      },
                                    ),
                                  ),
                        const SizedBox(height: 10),
                        _buildSaveGeneralButton(context),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchField1() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController1,
        style: const TextStyle(fontFamily: "Mulish", color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            fontFamily: "Mulish",
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.black),
        ),
        cursorColor: const Color(0xFF018786),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        style: const TextStyle(fontFamily: "Mulish", color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            fontFamily: "Mulish",
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.black),
        ),
        cursorColor: const Color(0xFF018786),
      ),
    );
  }

  // Widget _buildSparePartsList() {
  //   // final spareFuture = ref.watch(apiServiceProvider).SpareLists(
  //   //     assetGroupId: widget.asset_group_id,
  //   //     assetId: widget.asset_id,
  //   //     type: 'general');

  //   return Expanded(
  //     child: FutureBuilder(
  //       future: spareFuture,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return SingleChildScrollView(
  //             child: const Center(
  //                 child: Padding(
  //               padding: EdgeInsets.all(15),
  //               child: ShimmerLists(
  //                 count: 10,
  //                 width: double.infinity,
  //                 height: 300,
  //                 shapeBorder: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.all(Radius.circular(10))),
  //               ),
  //             )),
  //           );
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         } else if (!snapshot.hasData ||
  //             snapshot.data?.sparesLists == null ||
  //             snapshot.data!.sparesLists!.isEmpty) {
  //           return Center(
  //             child: NoDataScreen(),
  //           );
  //         }

  //         spareDetails = snapshot.data!.sparesLists!;

  //         // Initialize checkbox states and quantity values only if the length changes
  //         if (checkboxStates.length != spareDetails.length) {
  //           checkboxStates = List.generate(
  //               spareDetails.length, (index) => ValueNotifier(false));
  //           quantityValues = List.generate(spareDetails.length,
  //               (index) => ValueNotifier('')); // Initialize quantity values
  //         }
  //         if (quantityControllers.length != spareDetails.length) {
  //           quantityControllers = List.generate(spareDetails.length, (index) {
  //             // logger.i(quantityValues[index].value);
  //             return TextEditingController(text: quantityValues[index].value);
  //           }); // Initialize controllers
  //         }

  //         if (searchController.text.isNotEmpty) {
  //           spareDetails = spareDetails
  //               .where((spare) =>
  //                   spare.spareName != null &&
  //                   spare.spareName!
  //                       .toLowerCase()
  //                       .contains(searchController.text.toLowerCase()))
  //               .toList();
  //         }

  //         return ListView.builder(
  //           itemCount: spareDetails.length,
  //           itemBuilder: (context, index) {
  //             // logger.e(spareDetails[index].toJson());

  //             return _buildSpareCard(spareDetails[index], index);
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget _buildMappedSparePartsList() {
  //   // final spareFuture = ref.watch(apiServiceProvider).SpareLists(
  //   //     assetGroupId: widget.asset_group_id,
  //   //     assetId: widget.asset_id,
  //   //     type: 'mapping');

  //   return Expanded(
  //     child: FutureBuilder(
  //       future: spareFuture,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return SingleChildScrollView(
  //             child: const Center(
  //                 child: Padding(
  //               padding: EdgeInsets.all(15),
  //               child: ShimmerLists(
  //                 count: 10,
  //                 width: double.infinity,
  //                 height: 300,
  //                 shapeBorder: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.all(Radius.circular(10))),
  //               ),
  //             )),
  //           );
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         } else if (!snapshot.hasData ||
  //             snapshot.data?.sparesLists == null ||
  //             snapshot.data!.sparesLists!.isEmpty) {
  //           return Center(
  //             child: NoDataScreen(),
  //           );
  //         }

  //         mappedSpareDetails = snapshot.data!.sparesLists!;

  //         // Initialize checkbox states and quantity values only if the length changes
  //         if (checkboxStates.length != mappedSpareDetails.length) {
  //           checkboxStates = List.generate(
  //               mappedSpareDetails.length, (index) => ValueNotifier(false));
  //           quantityValues = List.generate(mappedSpareDetails.length,
  //               (index) => ValueNotifier('')); // Initialize quantity values
  //         }
  //         if (quantityControllers.length != mappedSpareDetails.length) {
  //           quantityControllers = List.generate(
  //               mappedSpareDetails.length,
  //               (index) => TextEditingController(
  //                   text:
  //                       quantityValues[index].value)); // Initialize controllers
  //         }

  //         if (searchController.text.isNotEmpty) {
  //           mappedSpareDetails = mappedSpareDetails
  //               .where((spare) =>
  //                   spare.spareName != null &&
  //                   spare.spareName!
  //                       .toLowerCase()
  //                       .contains(searchController.text.toLowerCase()))
  //               .toList();
  //         }

  //         print(mappedSpareDetails.length);
  //         return
  //       },
  //     ),
  //   );
  // }

  Widget _buildSpareCardMapped(SparesLists spare, int index) {
    // Check if checkboxStates and quantityValues are initialized
    if (index >= checkboxStatesMapped.length ||
        index >= quantityValuesMapped.length) {
      return Container(); // Return empty container if lists are not initialized correctly
    }

    return Column(
      children: [
        Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCheckboxRowMapped(spare, index),
                const SizedBox(height: 5),
                _buildTextRow('Location:', spare.spareLocation.toString()),
                _buildTextRow(
                    'Re-Order Quantity:', spare.spareMinQty.toString()),
                _buildTextRow('Hand Stock:', spare.spareStock.toString()),
                const SizedBox(height: 5),
                _buildPriceQuantityRowMapped(
                    spare, index), // Use modified row here
              ],
            ),
          ),
        ),
        HeightHalf(),
      ],
    );
  }

  Widget _buildSpareCardGeneral(SparesLists spare, int index) {
    // Check if checkboxStates and quantityValues are initialized
    if (index >= checkboxStatesgeneral.length ||
        index >= quantityValuesgeneral.length) {
      return Container(); // Return empty container if lists are not initialized correctly
    }

    return Column(
      children: [
        Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCheckboxRowGeneral(spare, index),
                const SizedBox(height: 5),
                _buildTextRow('Location:', spare.spareLocation.toString()),
                _buildTextRow(
                    'Re-Order Quantity:', spare.spareMinQty.toString()),
                _buildTextRow('Hand Stock:', spare.spareStock.toString()),
                const SizedBox(height: 5),
                _buildPriceQuantityRowGeneral(
                    spare, index), // Use modified row here
              ],
            ),
          ),
        ),
        HeightHalf(),
      ],
    );
  }

  Widget _buildCheckboxRowMapped(SparesLists spare, int index) {
    return Row(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: checkboxStatesMapped[
              index], // Listen to changes in this specific checkbox state
          builder: (context, value, child) {
            return Checkbox(
              checkColor: Colors.white,
              value: value,
              onChanged: (newValue) {
                checkboxStatesMapped[index].value =
                    newValue ?? false; // Update the ValueNotifier's value
              },
              activeColor: const Color(0xFF018786),
            );
          },
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            spare.spareName.toString(),
            style: const TextStyle(
              fontFamily: "Mulish",
              color: Color(0xFF018786),
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxRowGeneral(SparesLists spare, int index) {
    return Row(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: checkboxStatesgeneral[
              index], // Listen to changes in this specific checkbox state
          builder: (context, value, child) {
            return Checkbox(
              checkColor: Colors.white,
              value: value,
              onChanged: (newValue) {
                checkboxStatesgeneral[index].value =
                    newValue ?? false; // Update the ValueNotifier's value
              },
              activeColor: const Color(0xFF018786),
            );
          },
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            spare.spareName.toString(),
            style: const TextStyle(
              fontFamily: "Mulish",
              color: Color(0xFF018786),
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Mulish",
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          value,
          style: const TextStyle(fontFamily: "Mulish", fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildPriceQuantityRowMapped(SparesLists spare, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildColumnText('Unit Price', spare.spareUnitPrice.toString()),
        // Show quantity input based on checkbox state
        ValueListenableBuilder<bool>(
          valueListenable: checkboxStatesMapped[index],
          builder: (context, isChecked, child) {
            if (!isChecked) {
              // Clear the quantity controller value when unchecked
              quantityControllersMapped[index]
                  .clear(); // Clear text if checkbox is unchecked
              quantityValuesMapped[index].value = ''; // Reset quantity value
            }

            return isChecked
                ? _buildQuantityInput(index, true) // Pass only the index
                : const SizedBox.shrink();
          },
        ),
        // Display the total cost
        ValueListenableBuilder<String>(
          valueListenable: quantityValuesMapped[index],
          builder: (context, quantityText, child) {
            // Parse the quantity input and calculate total cost
            double quantity =
                double.tryParse(quantityText) ?? 0.0; // Safely parse quantity
            double totalCost = quantity *
                spare.spareUnitPrice!.toDouble(); // Ensure unit price is double
            return _buildColumnText('Total Cost',
                '₹${totalCost.toStringAsFixed(2)}'); // Format total cost
          },
        ),
      ],
    );
  }

  Widget _buildPriceQuantityRowGeneral(SparesLists spare, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildColumnText('Unit Price', spare.spareUnitPrice.toString()),
        // Show quantity input based on checkbox state
        ValueListenableBuilder<bool>(
          valueListenable: checkboxStatesgeneral[index],
          builder: (context, isChecked, child) {
            if (!isChecked) {
              // Clear the quantity controller value when unchecked
              quantityControllersGeneral[index]
                  .clear(); // Clear text if checkbox is unchecked
              quantityValuesgeneral[index].value = ''; // Reset quantity value
            }

            return isChecked
                ? _buildQuantityInput(index, false) // Pass only the index
                : const SizedBox.shrink();
          },
        ),
        // Display the total cost
        ValueListenableBuilder<String>(
          valueListenable: quantityValuesgeneral[index],
          builder: (context, quantityText, child) {
            // Parse the quantity input and calculate total cost
            double quantity =
                double.tryParse(quantityText) ?? 0.0; // Safely parse quantity
            double totalCost = quantity *
                spare.spareUnitPrice!.toDouble(); // Ensure unit price is double
            return _buildColumnText('Total Cost',
                '₹${totalCost.toStringAsFixed(2)}'); // Format total cost
          },
        ),
      ],
    );
  }

  Widget _buildQuantityInput(int index, bool isMapped) {
    final quantityValues =
        isMapped ? quantityValuesMapped : quantityValuesgeneral;
    final quantityControllers =
        isMapped ? quantityControllersMapped : quantityControllersGeneral;
    List<SparesLists> list =
        isMapped ? mappedSpareDetails : generalSpareDetails;

    return Column(
      children: [
        const Text(
          'Quantity',
          style: TextStyle(
            fontFamily: "Mulish",
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 56,
          height: 50,
          child: ValueListenableBuilder<String>(
            valueListenable: quantityValues[index],
            builder: (context, value, child) {
              return TextField(
                controller: quantityControllers[index],
                decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF018786)),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  errorText: _getQuantityErrorText(index, value, list),
                ),
                cursorColor: const Color(0xFF018786),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.phone,
                onChanged: (newValue) {
                  final enteredQuantity = double.tryParse(newValue) ?? -1;
                  logger.w(list[index].spareStock);

                  if (enteredQuantity >= 0 &&
                      enteredQuantity <= list[index].spareStock!) {
                    quantityValues[index].value = newValue;
                  } else {
                    quantityValues[index].value = "";
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget _buildPriceQuantityRow(SparesLists spare, int index) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       _buildColumnText('Unit Price', spare.spareUnitPrice.toString()),
  //       // Show quantity input based on checkbox state
  //       ValueListenableBuilder<bool>(
  //         valueListenable: checkboxStates[index],
  //         builder: (context, isChecked, child) {
  //           return isChecked
  //               ? _buildQuantityInput(index) // Pass only the index
  //               : const SizedBox.shrink();
  //         },
  //       ),
  //       // Display the total cost
  //       ValueListenableBuilder<String>(
  //         valueListenable: quantityValues[index],
  //         builder: (context, quantityText, child) {
  //           // Parse the quantity input and calculate total cost
  //           double quantity =
  //               double.tryParse(quantityText) ?? 0.0; // Safely parse quantity
  //           double totalCost = quantity *
  //               spare.spareUnitPrice!.toDouble(); // Ensure unit price is double
  //           return _buildColumnText('Total Cost',
  //               '₹${totalCost.toStringAsFixed(2)}'); // Format total cost
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildColumnText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontFamily: "Mulish", fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 15),
        Text(
          value,
          style: const TextStyle(
              fontFamily: "Mulish", fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ],
    );
  }

  // Widget _buildQuantityInput(int index) {
  //   return Column(
  //     children: [
  //       const Text(
  //         'Quantity',
  //         style: TextStyle(
  //             fontFamily: "Mulish", fontWeight: FontWeight.w600, fontSize: 15),
  //       ),
  //       const SizedBox(height: 4),
  //       SizedBox(
  //         width: 56,
  //         height: 50,
  //         child: ValueListenableBuilder<String>(
  //           valueListenable: quantityValues[index],
  //           builder: (context, value, child) {
  //             return TextField(
  //               controller:
  //                   quantityControllers[index], // Use persistent controller
  //               decoration: InputDecoration(
  //                 focusedBorder: const UnderlineInputBorder(
  //                   borderSide: BorderSide(color: Color(0xFF018786)),
  //                 ),
  //                 enabledBorder: const UnderlineInputBorder(
  //                   borderSide: BorderSide(color: Colors.grey),
  //                 ),
  //                 errorText: _getQuantityErrorText(
  //                     index, value), // Error message if invalid
  //               ),
  //               cursorColor: const Color(0xFF018786),
  //               textAlign: TextAlign.center,
  //               keyboardType: TextInputType.phone,
  //               onChanged: (newValue) {
  //                 final enteredQuantity = double.tryParse(newValue) ?? -1;
  //                 if (enteredQuantity >= 0 &&
  //                     enteredQuantity <= spareDetails[index].spareStock!) {
  //                   quantityValues[index].value =
  //                       newValue; // Update ValueNotifier
  //                 } else {
  //                   quantityValues[index].value = ""; // Clear invalid input
  //                 }
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  String? _getQuantityErrorText(
      int index, String value, List<SparesLists> lists) {
    final enteredQuantity = double.tryParse(value);

    if (enteredQuantity == null || enteredQuantity < 0) {
      return 'Must be ≥ 0'; // Error if below 0
    } else if (enteredQuantity > lists[index].spareStock!) {
      return 'Exceeds stock'; // Error if exceeds hand stock
    }
    return null; // No error
  }

  String? getQuantityErrorText1(int index, String value) {
    final enteredQuantity = double.tryParse(value);

    if (enteredQuantity == null || enteredQuantity < 0) {
      return 'Must be ≥ 0'; // Error if below 0
    } else if (enteredQuantity > overallSpareLists[index].spareStock!) {
      return 'Exceeds stock'; // Error if exceeds hand stock
    }
    return null; // No error
  }

  Widget _buildSaveGeneralButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Check if at least one checkbox is selected
        bool isAnyChecked = checkboxStatesgeneral.any((state) => state.value);

        if (!isAnyChecked) {
          // Show message if no checkbox is selected
          showMessage(
            context: context,
            isError: true,
            responseMessage: 'Kindly Select Any Spares',
          );
          return; // Exit the function
        }

        List<Map<String, dynamic>> selectedSpareParts = [];

        bool validQuantities = true;

        for (int i = 0; i < checkboxStatesgeneral.length; i++) {
          if (checkboxStatesgeneral[i].value) {
            final spareId = generalSpareDetails[i].spareId;
            final quantityText = quantityValuesgeneral[i].value;
            final quantity = double.tryParse(quantityText) ?? 0.0;

            if (quantity <= 0) {
              validQuantities =
                  false; // Set as invalid if consumed quantity is 0 or less
              showMessage(
                  context: context,
                  isError: true,
                  responseMessage:
                      'Consumed Quantity Must be\nGreater than 0\nand below HandStock...');
              break; // Exit the loop if invalid
            }

            final totalCost =
                quantity * generalSpareDetails[i].spareUnitPrice!.toDouble();

            selectedSpareParts.add({
              "total_cost": totalCost,
              "spare_id": spareId,
              "is_checked": checkboxStatesgeneral[i].value.toString(),
              "consumed_qty": quantityText,
              "on_hand_stock": generalSpareDetails[i].spareStock,
            });
          }
        }

        if (validQuantities && selectedSpareParts.isNotEmpty) {
          // Convert to JSON and send to API if all quantities are valid
          String jsonString = jsonEncode(selectedSpareParts);
          print(jsonString);

          ApiService()
              .SpareSave(ticketId: widget.ticketNumber, spares: jsonString)
              .then((value) {
            if (value.isError == false) {
              // Navigator.of(context).pop();
              // ref
              //     .watch(apiServiceProvider)
              //     .TicketSpareLists(ticketId: widget.ticketNumber);
              SpareRepository()
                  .getTicketSpareList(context, ticketId: widget.ticketNumber);

              // Navigator.of(context).pop(
              //     // MaterialPageRoute(
              //     //   builder: (context) => SpareEditScreen(
              //     //       asset_group_id: '',
              //     //       asset_id: '',
              //     //       ticketNumber: widget.ticketNumber))
              //     );
              Navigator.of(context).pop();
            }

            showMessage(
                context: context,
                isError: value.isError!,
                responseMessage: value.message!);
          });
        } else {
          showMessage(
              context: context,
              isError: true,
              responseMessage:
                  'Consumed Quantity Must be\nGreater than 0\nand below HandStock...');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
      ),
      child: const Text('Save',
          style: TextStyle(fontFamily: "Mulish", color: Colors.white)),
    );
  }

  Widget _buildSaveMappedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Check if at least one checkbox is selected
        bool isAnyChecked = checkboxStatesMapped.any((state) => state.value);

        if (!isAnyChecked) {
          // Show message if no checkbox is selected
          showMessage(
            context: context,
            isError: true,
            responseMessage: 'Kindly Select Any Spares',
          );
          return; // Exit the function
        }

        List<Map<String, dynamic>> selectedSpareParts = [];

        bool validQuantities = true;

        for (int i = 0; i < checkboxStatesMapped.length; i++) {
          if (checkboxStatesMapped[i].value) {
            final spareId = mappedSpareDetails[i].spareId;
            final quantityText = quantityValuesMapped[i].value;
            final quantity = double.tryParse(quantityText) ?? 0.0;

            if (quantity <= 0) {
              validQuantities =
                  false; // Set as invalid if consumed quantity is 0 or less
              showMessage(
                  context: context,
                  isError: true,
                  responseMessage:
                      'Consumed Quantity Must be\nGreater than 0\nand below HandStock...');
              break; // Exit the loop if invalid
            }

            final totalCost =
                quantity * mappedSpareDetails[i].spareUnitPrice!.toDouble();

            selectedSpareParts.add({
              "total_cost": totalCost,
              "spare_id": spareId,
              "is_checked": checkboxStatesMapped[i].value.toString(),
              "consumed_qty": quantityText,
              "on_hand_stock": mappedSpareDetails[i].spareStock,
            });
          }
        }

        if (validQuantities && selectedSpareParts.isNotEmpty) {
          // Convert to JSON and send to API if all quantities are valid
          String jsonString = jsonEncode(selectedSpareParts);
          print(jsonString);

          ApiService()
              .SpareSave(ticketId: widget.ticketNumber, spares: jsonString)
              .then((value) {
            if (value.isError == false) {
              // Navigator.of(context).pop();
              // ref
              //     .watch(apiServiceProvider)
              //     .TicketSpareLists(ticketId: widget.ticketNumber);
              SpareRepository()
                  .getTicketSpareList(context, ticketId: widget.ticketNumber);

              // Navigator.of(context).pop(
              //     // MaterialPageRoute(
              //     //   builder: (context) => SpareEditScreen(
              //     //       asset_group_id: '',
              //     //       asset_id: '',
              //     //       ticketNumber: widget.ticketNumber))
              //     );
              Navigator.of(context).pop();
            }

            showMessage(
                context: context,
                isError: value.isError!,
                responseMessage: value.message!);
          });
        } else {
          showMessage(
              context: context,
              isError: true,
              responseMessage:
                  'Consumed Quantity Must be\nGreater than 0\nand below HandStock...');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
      ),
      child: const Text('Save',
          style: TextStyle(fontFamily: "Mulish", color: Colors.white)),
    );
  }
}

// class SpareScreen extends ConsumerStatefulWidget {
//   final String ticketNumber;
//   final String asset_id;
//   final String asset_group_id;

//   const SpareScreen(
//       {super.key,
//       required this.ticketNumber,
//       required this.asset_id,
//       required this.asset_group_id});
//   @override
//   ConsumerState<SpareScreen> createState() => _SpareScreenState();
// }

// class _SpareScreenState extends ConsumerState<SpareScreen> {
//   List<ValueNotifier<bool>> checkboxStates = []; // List of ValueNotifiers
//   List<ValueNotifier<String>> quantityValues = [];
//   List<SpareData> selectedSpares = [];
//   List<SparesLists> spareDetails = [];
//   List<SparesLists> mappedSpareDetails = [];
//   List<TextEditingController> quantityControllers = [];
//   TextEditingController searchController = TextEditingController();
//   bool isLoading = false;

//   @override
//   void initState() {
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
//     return DefaultTabController(
//       length: 2, // Number of tabs
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Add Spares',
//             style: TextStyle(fontFamily: "Mulish", color: Colors.white),
//           ),
//           backgroundColor: Color.fromRGBO(30, 152, 165, 1),
//           iconTheme: const IconThemeData(
//             color: Colors.white, //change your color here
//           ),
//           bottom: const TabBar(
//             tabs: [
//               Tab(
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Icon(Icons.build_circle_sharp), // Icon for the first tab
//                       SizedBox(width: 5.0),
//                       Text('Mapped Spares'), // Text for the first tab
//                     ],
//                   ),
//                 ),
//               ),
//               Tab(
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Icon(Icons.build_circle_sharp), // Icon for the second tab
//                       SizedBox(width: 5.0),
//                       Text('General Spares'), // Text for the second tab
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//             indicatorColor:
//                 Colors.white, // Indicator color when tab is selected
//             labelColor: Colors.white, // Text color when tab is selected
//             unselectedLabelColor:
//                 Colors.grey, // Text color when tab is not selected
//             labelStyle: TextStyle(
//                 fontFamily: "Mulish",
//                 fontSize: 14.0), // Style for selected text
//             unselectedLabelStyle: TextStyle(
//                 fontFamily: "Mulish",
//                 fontSize: 14.0), // Style for unselected text
//             // Icon color when tab is not selected
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // Contents of the first tab (Mapped Spares)
//             Container(
//               color: const Color(0xF5F5F5F5),
//               child: Center(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 10),
//                     _buildSearchField(),
//                     const SizedBox(height: 10),
//                     _buildMappedSparePartsList(),
//                     const SizedBox(height: 10),
//                     if (mappedSpareDetails.isNotEmpty) ...[
//                       _buildSaveButton(context)
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//             // Contents of the second tab (General Spares)
//             Container(
//               color: const Color(0xF5F5F5F5),
//               child: Center(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 10),
//                     _buildSearchField(),
//                     const SizedBox(height: 10),
//                     _buildSparePartsList(),
//                     const SizedBox(height: 10),
//                     _buildSaveButton(context),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: searchController,
//         style: const TextStyle(fontFamily: "Mulish", color: Colors.black),
//         decoration: InputDecoration(
//           hintText: 'Search',
//           hintStyle: TextStyle(
//             fontFamily: "Mulish",
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           enabledBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.transparent),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.transparent),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           prefixIcon: const Icon(Icons.search, color: Colors.black),
//         ),
//         cursorColor: const Color(0xFF018786),
//       ),
//     );
//   }

//   Widget _buildSparePartsList() {
//     final spareFuture = ref.watch(apiServiceProvider).SpareLists(
//         assetGroupId: widget.asset_group_id,
//         assetId: widget.asset_id,
//         type: 'general');

//     return Expanded(
//       child: FutureBuilder(
//         future: spareFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return SingleChildScrollView(
//               child: const Center(
//                   child: Padding(
//                 padding: EdgeInsets.all(15),
//                 child: ShimmerLists(
//                   count: 10,
//                   width: double.infinity,
//                   height: 300,
//                   shapeBorder: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10))),
//                 ),
//               )),
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData ||
//               snapshot.data?.sparesLists == null ||
//               snapshot.data!.sparesLists!.isEmpty) {
//             return Center(
//               child: NoDataScreen(),
//             );
//           }

//           spareDetails = snapshot.data!.sparesLists!;

//           // Initialize checkbox states and quantity values only if the length changes
//           if (checkboxStates.length != spareDetails.length) {
//             checkboxStates = List.generate(
//                 spareDetails.length, (index) => ValueNotifier(false));
//             quantityValues = List.generate(spareDetails.length,
//                 (index) => ValueNotifier('')); // Initialize quantity values
//           }
//           if (quantityControllers.length != spareDetails.length) {
//             quantityControllers = List.generate(spareDetails.length, (index) {
//               // logger.i(quantityValues[index].value);
//               return TextEditingController(text: quantityValues[index].value);
//             }); // Initialize controllers
//           }

//           if (searchController.text.isNotEmpty) {
//             spareDetails = spareDetails
//                 .where((spare) =>
//                     spare.spareName != null &&
//                     spare.spareName!
//                         .toLowerCase()
//                         .contains(searchController.text.toLowerCase()))
//                 .toList();
//           }

//           return ListView.builder(
//             itemCount: spareDetails.length,
//             itemBuilder: (context, index) {
//               // logger.e(spareDetails[index].toJson());

//               return _buildSpareCard(spareDetails[index], index);
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildMappedSparePartsList() {
//     final spareFuture = ref.watch(apiServiceProvider).SpareLists(
//         assetGroupId: widget.asset_group_id,
//         assetId: widget.asset_id,
//         type: 'mapping');

//     return Expanded(
//       child: FutureBuilder(
//         future: spareFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return SingleChildScrollView(
//               child: const Center(
//                   child: Padding(
//                 padding: EdgeInsets.all(15),
//                 child: ShimmerLists(
//                   count: 10,
//                   width: double.infinity,
//                   height: 300,
//                   shapeBorder: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10))),
//                 ),
//               )),
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData ||
//               snapshot.data?.sparesLists == null ||
//               snapshot.data!.sparesLists!.isEmpty) {
//             return Center(
//               child: NoDataScreen(),
//             );
//           }

//           mappedSpareDetails = snapshot.data!.sparesLists!;

//           // Initialize checkbox states and quantity values only if the length changes
//           if (checkboxStates.length != mappedSpareDetails.length) {
//             checkboxStates = List.generate(
//                 mappedSpareDetails.length, (index) => ValueNotifier(false));
//             quantityValues = List.generate(mappedSpareDetails.length,
//                 (index) => ValueNotifier('')); // Initialize quantity values
//           }
//           if (quantityControllers.length != mappedSpareDetails.length) {
//             quantityControllers = List.generate(
//                 mappedSpareDetails.length,
//                 (index) => TextEditingController(
//                     text:
//                         quantityValues[index].value)); // Initialize controllers
//           }

//           if (searchController.text.isNotEmpty) {
//             mappedSpareDetails = mappedSpareDetails
//                 .where((spare) =>
//                     spare.spareName != null &&
//                     spare.spareName!
//                         .toLowerCase()
//                         .contains(searchController.text.toLowerCase()))
//                 .toList();
//           }

//           print(mappedSpareDetails.length);
//           return ListView.builder(
//             itemCount: mappedSpareDetails.length,
//             itemBuilder: (context, index) {
//               // logger.e(mappedSpareDetails[index]);
//               return _buildSpareCard(mappedSpareDetails[index], index);
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildSpareCard(SparesLists spare, int index) {
//     // Check if checkboxStates and quantityValues are initialized
//     if (index >= checkboxStates.length || index >= quantityValues.length) {
//       return Container(); // Return empty container if lists are not initialized correctly
//     }

//     return Column(
//       children: [
//         Card(
//           elevation: 5,
//           margin: EdgeInsets.symmetric(horizontal: 8),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildCheckboxRow(spare, index),
//                 const SizedBox(height: 5),
//                 _buildTextRow('Location:', spare.spareLocation.toString()),
//                 _buildTextRow(
//                     'Re-Order Quantity:', spare.spareMinQty.toString()),
//                 _buildTextRow('Hand Stock:', spare.spareStock.toString()),
//                 const SizedBox(height: 5),
//                 _buildPriceQuantityRow(spare, index), // Use modified row here
//               ],
//             ),
//           ),
//         ),
//         HeightHalf(),
//       ],
//     );
//   }

//   Widget _buildCheckboxRow(SparesLists spare, int index) {
//     return Row(
//       children: [
//         ValueListenableBuilder<bool>(
//           valueListenable: checkboxStates[
//               index], // Listen to changes in this specific checkbox state
//           builder: (context, value, child) {
//             return Checkbox(
//               checkColor: Colors.white,
//               value: value,
//               onChanged: (newValue) {
//                 checkboxStates[index].value =
//                     newValue ?? false; // Update the ValueNotifier's value
//               },
//               activeColor: const Color(0xFF018786),
//             );
//           },
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             spare.spareName.toString(),
//             style: const TextStyle(
//               fontFamily: "Mulish",
//               color: Color(0xFF018786),
//               fontWeight: FontWeight.w600,
//               fontSize: 17,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTextRow(String label, String value) {
//     return Row(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontFamily: "Mulish",
//             fontWeight: FontWeight.w600,
//             fontSize: 15,
//           ),
//         ),
//         const SizedBox(width: 3),
//         Text(
//           value,
//           style: const TextStyle(fontFamily: "Mulish", fontSize: 15),
//         ),
//       ],
//     );
//   }

//   Widget _buildPriceQuantityRow(SparesLists spare, int index) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _buildColumnText('Unit Price', spare.spareUnitPrice.toString()),
//         // Show quantity input based on checkbox state
//         ValueListenableBuilder<bool>(
//           valueListenable: checkboxStates[index],
//           builder: (context, isChecked, child) {
//             if (!isChecked) {
//               // Clear the quantity controller value when unchecked
//               quantityControllers[index]
//                   .clear(); // Clear text if checkbox is unchecked
//               quantityValues[index].value = ''; // Reset quantity value
//             }

//             return isChecked
//                 ? _buildQuantityInput(index) // Pass only the index
//                 : const SizedBox.shrink();
//           },
//         ),
//         // Display the total cost
//         ValueListenableBuilder<String>(
//           valueListenable: quantityValues[index],
//           builder: (context, quantityText, child) {
//             // Parse the quantity input and calculate total cost
//             double quantity =
//                 double.tryParse(quantityText) ?? 0.0; // Safely parse quantity
//             double totalCost = quantity *
//                 spare.spareUnitPrice!.toDouble(); // Ensure unit price is double
//             return _buildColumnText('Total Cost',
//                 '₹${totalCost.toStringAsFixed(2)}'); // Format total cost
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildQuantityInput(int index) {
//     return Column(
//       children: [
//         const Text(
//           'Quantity',
//           style: TextStyle(
//               fontFamily: "Mulish", fontWeight: FontWeight.w600, fontSize: 15),
//         ),
//         const SizedBox(height: 4),
//         SizedBox(
//           width: 56,
//           height: 50,
//           child: ValueListenableBuilder<String>(
//             valueListenable: quantityValues[index],
//             builder: (context, value, child) {
//               return TextField(
//                 controller:
//                     quantityControllers[index], // Use persistent controller
//                 decoration: InputDecoration(
//                   focusedBorder: const UnderlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xFF018786)),
//                   ),
//                   enabledBorder: const UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   errorText: _getQuantityErrorText(
//                       index, value), // Error message if invalid
//                 ),
//                 cursorColor: const Color(0xFF018786),
//                 textAlign: TextAlign.center,
//                 keyboardType: TextInputType.phone,
//                 onChanged: (newValue) {
//                   final enteredQuantity = double.tryParse(newValue) ?? -1;
//                   if (enteredQuantity >= 0 &&
//                       enteredQuantity <= spareDetails[index].spareStock!) {
//                     quantityValues[index].value =
//                         newValue; // Update ValueNotifier
//                   } else {
//                     quantityValues[index].value = ""; // Clear invalid input
//                   }
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   // Widget _buildPriceQuantityRow(SparesLists spare, int index) {
//   //   return Row(
//   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //     children: [
//   //       _buildColumnText('Unit Price', spare.spareUnitPrice.toString()),
//   //       // Show quantity input based on checkbox state
//   //       ValueListenableBuilder<bool>(
//   //         valueListenable: checkboxStates[index],
//   //         builder: (context, isChecked, child) {
//   //           return isChecked
//   //               ? _buildQuantityInput(index) // Pass only the index
//   //               : const SizedBox.shrink();
//   //         },
//   //       ),
//   //       // Display the total cost
//   //       ValueListenableBuilder<String>(
//   //         valueListenable: quantityValues[index],
//   //         builder: (context, quantityText, child) {
//   //           // Parse the quantity input and calculate total cost
//   //           double quantity =
//   //               double.tryParse(quantityText) ?? 0.0; // Safely parse quantity
//   //           double totalCost = quantity *
//   //               spare.spareUnitPrice!.toDouble(); // Ensure unit price is double
//   //           return _buildColumnText('Total Cost',
//   //               '₹${totalCost.toStringAsFixed(2)}'); // Format total cost
//   //         },
//   //       ),
//   //     ],
//   //   );
//   // }

//   Widget _buildColumnText(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//               fontFamily: "Mulish", fontWeight: FontWeight.w600, fontSize: 15),
//         ),
//         const SizedBox(height: 15),
//         Text(
//           value,
//           style: const TextStyle(
//               fontFamily: "Mulish", fontWeight: FontWeight.w600, fontSize: 15),
//         ),
//       ],
//     );
//   }

//   // Widget _buildQuantityInput(int index) {
//   //   return Column(
//   //     children: [
//   //       const Text(
//   //         'Quantity',
//   //         style: TextStyle(
//   //             fontFamily: "Mulish", fontWeight: FontWeight.w600, fontSize: 15),
//   //       ),
//   //       const SizedBox(height: 4),
//   //       SizedBox(
//   //         width: 56,
//   //         height: 50,
//   //         child: ValueListenableBuilder<String>(
//   //           valueListenable: quantityValues[index],
//   //           builder: (context, value, child) {
//   //             return TextField(
//   //               controller:
//   //                   quantityControllers[index], // Use persistent controller
//   //               decoration: InputDecoration(
//   //                 focusedBorder: const UnderlineInputBorder(
//   //                   borderSide: BorderSide(color: Color(0xFF018786)),
//   //                 ),
//   //                 enabledBorder: const UnderlineInputBorder(
//   //                   borderSide: BorderSide(color: Colors.grey),
//   //                 ),
//   //                 errorText: _getQuantityErrorText(
//   //                     index, value), // Error message if invalid
//   //               ),
//   //               cursorColor: const Color(0xFF018786),
//   //               textAlign: TextAlign.center,
//   //               keyboardType: TextInputType.phone,
//   //               onChanged: (newValue) {
//   //                 final enteredQuantity = double.tryParse(newValue) ?? -1;
//   //                 if (enteredQuantity >= 0 &&
//   //                     enteredQuantity <= spareDetails[index].spareStock!) {
//   //                   quantityValues[index].value =
//   //                       newValue; // Update ValueNotifier
//   //                 } else {
//   //                   quantityValues[index].value = ""; // Clear invalid input
//   //                 }
//   //               },
//   //             );
//   //           },
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }

//   String? _getQuantityErrorText(int index, String value) {
//     final enteredQuantity = double.tryParse(value);
//     if (enteredQuantity == null || enteredQuantity < 0) {
//       return 'Must be ≥ 0'; // Error if below 0
//     } else if (enteredQuantity > spareDetails[index].spareStock!) {
//       return 'Exceeds stock'; // Error if exceeds hand stock
//     }
//     return null; // No error
//   }

//   Widget _buildSaveButton(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         // Check if at least one checkbox is selected
//         bool isAnyChecked = checkboxStates.any((state) => state.value);

//         if (!isAnyChecked) {
//           // Show message if no checkbox is selected
//           showMessage(
//             context: context,
//             isError: true,
//             responseMessage: 'Kindly Select Any Spares',
//           );
//           return; // Exit the function
//         }

//         List<Map<String, dynamic>> selectedSpareParts = [];

//         bool validQuantities = true;

//         for (int i = 0; i < checkboxStates.length; i++) {
//           if (checkboxStates[i].value) {
//             final spareId = spareDetails[i].spareId;
//             final quantityText = quantityValues[i].value;
//             final quantity = double.tryParse(quantityText) ?? 0.0;

//             if (quantity <= 0) {
//               validQuantities =
//                   false; // Set as invalid if consumed quantity is 0 or less
//               showMessage(
//                   context: context,
//                   isError: true,
//                   responseMessage:
//                       'Consumed Quantity Must be\nGreater than 0\nand below HandStock...');
//               break; // Exit the loop if invalid
//             }

//             final totalCost =
//                 quantity * spareDetails[i].spareUnitPrice!.toDouble();

//             selectedSpareParts.add({
//               "total_cost": totalCost,
//               "spare_id": spareId,
//               "is_checked": checkboxStates[i].value.toString(),
//               "consumed_qty": quantityText,
//               "on_hand_stock": spareDetails[i].spareStock,
//             });
//           }
//         }

//         if (validQuantities && selectedSpareParts.isNotEmpty) {
//           // Convert to JSON and send to API if all quantities are valid
//           String jsonString = jsonEncode(selectedSpareParts);
//           print(jsonString);

//           ApiService()
//               .SpareSave(ticketId: widget.ticketNumber, spares: jsonString)
//               .then((value) {
//             if (value.isError == false) {
//               // Navigator.of(context).pop();
//               // ref
//               //     .watch(apiServiceProvider)
//               //     .TicketSpareLists(ticketId: widget.ticketNumber);
//               SpareRepository()
//                   .getTicketSpareList(context, ticketId: widget.ticketNumber);

//               // Navigator.of(context).pop(
//               //     // MaterialPageRoute(
//               //     //   builder: (context) => SpareEditScreen(
//               //     //       asset_group_id: '',
//               //     //       asset_id: '',
//               //     //       ticketNumber: widget.ticketNumber))
//               //     );
//               Navigator.of(context).pop();
//             }

//             showMessage(
//                 context: context,
//                 isError: value.isError!,
//                 responseMessage: value.message!);
//           });
//         } else {
//           showMessage(
//               context: context,
//               isError: true,
//               responseMessage:
//                   'Consumed Quantity Must be\nGreater than 0\nand below HandStock...');
//         }
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Color.fromRGBO(30, 152, 165, 1),
//       ),
//       child: const Text('Save',
//           style: TextStyle(fontFamily: "Mulish", color: Colors.white)),
//     );
//   }
// }
