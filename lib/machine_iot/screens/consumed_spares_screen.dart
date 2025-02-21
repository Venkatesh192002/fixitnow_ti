// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/screens/spare_screen.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/model/SpareEditListModel.dart';
import 'package:auscurator/provider/spare_provider.dart';
import 'package:auscurator/repository/spare_repository.dart';
import 'package:auscurator/widgets/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsumedSparesScreen extends StatefulWidget {
  const ConsumedSparesScreen(
      {super.key,
      required this.ticketNumber,
      this.status,
      required this.asset_id,
      required this.asset_group_id});
  final String ticketNumber;
  final String? status;

  final String asset_id;
  final String asset_group_id;

  @override
  State<ConsumedSparesScreen> createState() => _ConsumedSparesScreenState();
}

class _ConsumedSparesScreenState extends State<ConsumedSparesScreen> {
  List<ValueNotifier<bool>> checkboxStates = []; // List of ValueNotifiers
  List<ValueNotifier<String>> quantityValues = [];
  List<TicketSpareData> spareDetails = [];
  List<TextEditingController> quantityControllers = [];
  List<ValueNotifier<bool>> editStates = [];
  List<Map<String, dynamic>> selectedSpareParts = [];
  TextEditingController searchController = TextEditingController();

  bool isEdit = true;

  void isAction() {
    isEdit = !isEdit;
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SpareRepository()
          .getTicketSpareList(context, ticketId: widget.ticketNumber);
      selectedSpareParts.clear();
      searchController.addListener(() {
        filterItems();
      });
      setState(() {});
    });
    super.initState();
  }

  void filterItems() {
    setState(() {}); // Trigger a rebuild to filter in the UI
  }

  @override
  Widget build(BuildContext context) {
    // logger.e(widget.status);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Spares',
          style: TextStyle(fontFamily: "Mulish", color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.build_outlined),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SpareScreen(
                          ticketNumber: widget.ticketNumber,
                          asset_id: widget.asset_id.toString(),
                          asset_group_id: widget.asset_group_id.toString())));
            },
          ),
        ],
      ),
      body: Consumer<SpareProvider>(
        builder: (context, spare, _) {
          spareDetails = spare.ticketData?.ticketSpareData ?? [];
          editStates = List.generate(
              spareDetails.length, (index) => ValueNotifier(false));
          // Initialize checkbox states and quantity values only if the length changes
          if (checkboxStates.length != spareDetails.length) {
            checkboxStates = List.generate(
                spareDetails.length, (index) => ValueNotifier(false));
            quantityValues = List.generate(
                spareDetails.length,
                (index) => ValueNotifier(spareDetails[index]
                    .consumedQty
                    .toString())); // Initialize quantity values
          }
          if (editStates.length != spareDetails.length) {
            // Initialize editStates for each spare item if not initialized
            editStates = List.generate(
              spareDetails.length,
              (index) => ValueNotifier(false),
            );
          }
          quantityValues = List.generate(
              spareDetails.length, (index) => ValueNotifier<String>('0'));
          quantityControllers = List.generate(
              spareDetails.length, (index) => TextEditingController());

          if (quantityControllers.length != spareDetails.length) {
            quantityControllers = List.generate(
                spareDetails.length,
                (index) => TextEditingController(
                    text:
                        quantityValues[index].value)); // Initialize controllers
          }

          // if (quantityControllers.length != spareDetails.length) {
          quantityControllers = List.generate(spareDetails.length, (index) {
            return TextEditingController(
              text: spareDetails[index].consumedQty.toString(),
            );
          });
          // }
          if (searchController.text.isNotEmpty) {
            spareDetails = spareDetails
                .where((spare) => spare.spareName
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
                .toList();
          }

          return spare.isLoading
              ? SingleChildScrollView(
                  child: const Center(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: ShimmerLists(
                      count: 10,
                      width: double.infinity,
                      height: 300,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  )),
                )
              : spareDetails.isEmpty
                  ? Center(child: NoDataScreen())
                  : Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              const SizedBox(height: 10),
                              _buildSearchField(),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: spareDetails.length,
                                itemBuilder: (context, index) {
                                  return _buildSpareCard(
                                      spareDetails[index], index);
                                },
                              ),
                              const SizedBox(height: 10),
                              // Show the save button only if spareDetails is not empty
                            ],
                          ),
                        ),
                        widget.status == 'Fixed'
                            ? SizedBox.shrink()
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                width: context.widthFull(),
                                child: _buildSaveButton(context)),
                      ],
                    );
        },
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

  Widget _buildSpareCard(TicketSpareData spare, int index) {
    // Check if checkboxStates and quantityValues are initialized
    if (index >= checkboxStates.length || index >= quantityValues.length) {
      return Container(); // Return empty container if lists are not initialized correctly
    }

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCheckboxRow(spare, index),
            const SizedBox(height: 5),
            _buildTextRow('Location:', spare.spareLocation.toString()),
            _buildTextRow('Re-Order Quantity:', spare.spareMinQty.toString()),
            _buildTextRow('Hand Stock:', spare.spareStock.toString()),
            const SizedBox(height: 5),
            _buildPriceQuantityRow(spare, index), // Use modified row here
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxRow(TicketSpareData spare, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
        widget.status == "Fixed"
            ? SizedBox.shrink()
            : Row(
                children: [
                  IconButton(
                    onPressed: () {
                      editStates[index].value =
                          !editStates[index].value; // Toggle edit state
                    },
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      _deleteSpareItem(index, spare);
                    },
                    icon: const Icon(Icons.delete_outline_outlined),
                  ),
                ],
              ),
      ],
    );
  }

  void _deleteSpareItem(int index, TicketSpareData spare) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Delete Item'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Check the current contents of spareDetails before deletion
                  print('Before Deletion: $spareDetails');
                  // Remove the item from the list
                  spareDetails.removeAt(index);
                  // Check the contents after deletion
                  print('After Deletion: $spareDetails');
                });

                // Prepare the JSON list for the remaining spare parts
                List<Map<String, dynamic>> selectedSpareParts = [];

                // Check if spareDetails still contains items
                // if (spareDetails.isNotEmpty) {
                // for (int i = 0; i < spareDetails.length; i++) {
                final currentQuantity = spare.consumedQty
                    .toString(); // Current value from text field
                final parsedQuantity = double.tryParse(currentQuantity) ??
                    0.0; // Parse the current value
                final spareId = spare.spareId;

                // Calculate total cost based on the edited quantity
                final totalCost =
                    parsedQuantity * spare.spareUnitPrice.toDouble();

                // Add edited spare part details to the list
                selectedSpareParts.add({
                  "total_cost": totalCost, // Calculated total cost
                  "spare_id": spareId, // Spare ID
                  "is_checked":
                      "false", // Set "is_checked" to false because it was deleted
                  "consumed_qty": currentQuantity, // New quantity entered
                  "on_hand_stock": spare.spareStock // Current stock
                });
                // }
                // } else {
                //   print(spareDetails.length);
                // }

                // Convert the list of edited spare parts to JSON
                String jsonString = jsonEncode(selectedSpareParts);

                // Log the JSON string for debugging
                print("Selected Spare Parts JSON: $jsonString");

                // Call your API to save the updated spare parts data
                ApiService()
                    .SpareSave(
                        ticketId: widget.ticketNumber, spares: jsonString)
                    .then((value) {
                  if (value.isError == false) {
                    // Close the screen if the save operation is successful
                    Navigator.of(context).pop();
                  }

                  // Display a message based on the response
                  showMessage(
                      context: context,
                      isError: value.isError!,
                      responseMessage: value.message!);
                });

                // Show snackbar feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Item deleted successfully'),
                  ),
                );

                // Close the dialog
                Navigator.of(context)
                    .pop(); // Close the delete confirmation dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceQuantityRow(TicketSpareData spare, int index) {
    return ValueListenableBuilder<bool>(
      valueListenable:
          editStates[index], // Listen to the edit state of this row
      builder: (context, isEditing, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildColumnText('Unit Price', spare.spareUnitPrice.toString()),
            isEditing
                ? _buildQuantityInput(index) // Show input if editing
                : _buildColumnText('Quantity',
                    spare.consumedQty.toString()), // Show text if not editing
            quantityValues[index].value.isEmpty ||
                    quantityValues[index] == "0.0"
                ? _buildColumnText(
                    'Total Cost', '₹${spare.totalCost.toString()}')
                : ValueListenableBuilder<String>(
                    valueListenable: quantityValues[index],
                    builder: (context, quantityText, child) {
                      // Parse the quantity input and calculate total cost
                      double quantity = double.tryParse(quantityText) ?? 0.0;
                      double totalCost =
                          quantity * spare.spareUnitPrice.toDouble();
                      return _buildColumnText(
                        'Total Cost',
                        totalCost == 0.0
                            ? '₹${spare.totalCost.toString()}' // Show spare.totalCost if totalCost is zero
                            : '₹${totalCost.toStringAsFixed(2)}', // Otherwise show calculated cost
                      );
                    },
                  ),
          ],
        );
      },
    );
  }

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

  Widget _buildQuantityInput(int index) {
    return Column(
      children: [
        const Text(
          'Quantity',
          style: TextStyle(
              fontFamily: "Mulish", fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 120,
          height: 50,
          child: TextField(
            controller: quantityControllers[index], // Use persistent controller
            decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF018786)),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              errorText:
                  _getQuantityErrorText(index, quantityControllers[index].text),
            ),
            cursorColor: const Color(0xFF018786),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            onChanged: (newValue) {
              final enteredQuantity = double.tryParse(newValue) ?? -1;

              // Validate the entered quantity
              if (enteredQuantity >= 0 &&
                  enteredQuantity <= spareDetails[index].spareStock) {
                quantityValues[index].value = newValue; // Update ValueNotifier
              } else {
                quantityValues[index].value = ""; // Clear invalid input
              }

              // Update the TextEditingController value if valid
              quantityControllers[index].text = quantityValues[index].value;

              // Handle additional logic for selected spare parts
              if (enteredQuantity > 0) {
                final spareId = spareDetails[index].spareId;
                final totalCost = enteredQuantity *
                    spareDetails[index].spareUnitPrice.toDouble();

                // Update the selected spare parts list
                selectedSpareParts.add({
                  "total_cost": totalCost, // Calculated total cost
                  "spare_id": spareId, // Spare ID
                  "is_checked": "true", // Mark as checked
                  "consumed_qty": newValue, // Updated quantity
                  "on_hand_stock": spareDetails[index].spareStock // Hand stock
                });
              } else {
                // Show an error message if invalid
                showMessage(
                    context: context,
                    isError: true,
                    responseMessage:
                        'Consumed Quantity Must be\nGreater than 0\nand below HandStock...');
              }
            },
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

  String? _getQuantityErrorText(int index, String value) {
    final enteredQuantity = double.tryParse(value);
    if (enteredQuantity == null || enteredQuantity < 0) {
      return 'Must be ≥ 0'; // Error if below 0
    } else if (enteredQuantity > spareDetails[index].spareStock) {
      return 'Exceeds stock'; // Error if exceeds hand stock
    }
    return null; // No error
  }

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ElevatedButton(
        onPressed: () {
          bool validQuantities = true;

          for (int i = 0; i < spareDetails.length; i++) {
            final originalQuantity = spareDetails[i]
                .consumedQty
                .toString(); // Original quantity from data
            final currentQuantity =
                quantityValues[i].value; // Current value from text field
            final parsedQuantity = double.tryParse(currentQuantity) ??
                0.0; // Parse the current value

            // Check if the quantity has been edited
            if (currentQuantity != originalQuantity) {
              if (parsedQuantity <= 0) {
                validQuantities =
                    false; // Set as invalid if consumed quantity is 0 or less
                // showMessage(
                //     context: context,
                //     isError: true,
                //     responseMessage:
                //         'Consumed Quantity Must be\nGreater than 0\nand below HandStock...');
                break; // Exit the loop if invalid
              }

              final spareId = spareDetails[i].spareId;

              // Calculate total cost based on the edited quantity
              final totalCost =
                  parsedQuantity * spareDetails[i].spareUnitPrice.toDouble();

              // Add edited spare part details to the list
              selectedSpareParts.add({
                "total_cost": totalCost, // Calculated total cost
                "spare_id": spareId, // Spare ID
                "is_checked":
                    "true", // Set "is_checked" to true because it was edited
                "consumed_qty": currentQuantity, // New quantity entered
                "on_hand_stock": spareDetails[i].spareStock // Current stock
              });
            }
          }

          if (
              // validQuantities &&
              selectedSpareParts.isNotEmpty) {
            // Convert the list of edited spare parts to JSON
            String jsonString = jsonEncode(selectedSpareParts);

            // Log the JSON string for debugging
            print(jsonString);

            // Call your API to save the updated spare parts data
            ApiService()
                .SpareSave(ticketId: widget.ticketNumber, spares: jsonString)
                .then((value) {
              if (value.isError == false) {
                // Close the screen if the save operation is successful
                Navigator.of(context).pop();
              }

              // Display a message based on the response
              showMessage(
                  context: context,
                  isError: value.isError!,
                  responseMessage: value.message!);
            });
          }
          // else {
          //   showMessage(
          //       context: context,
          //       isError: true,
          //       responseMessage: 'Kinldy Select Anyone Spare');
          // }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(30, 152, 165, 1),
        ),
        child: const Text('Save',
            style: TextStyle(fontFamily: "Mulish", color: Colors.white)),
      ),
    );
  }
}


// import 'dart:convert';
// import 'package:auscurator/api_service/api_service.dart';
// import 'package:auscurator/components/no_data_animation.dart';
// import 'package:auscurator/machine_iot/util.dart';
// import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
// import 'package:auscurator/model/SpareEditListModel.dart';
// import 'package:auscurator/repository/spare_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ConsumedSparesScreen extends ConsumerStatefulWidget {
//   final String ticketNumber;

//   const ConsumedSparesScreen({super.key, required this.ticketNumber});
//   @override
//   ConsumerState<ConsumedSparesScreen> createState() => _SpareScreenState();
// }



// class _SpareScreenState extends ConsumerState<ConsumedSparesScreen> {
//   List<ValueNotifier<bool>> checkboxStates = []; // List of ValueNotifiers
// List<ValueNotifier<String>> quantityValues = [];
// List<TicketSpareData> spareDetails = [];
// List<TextEditingController> quantityControllers = [];
// List<ValueNotifier<bool>> editStates = [];
//   List<Map<String, dynamic>> selectedSpareParts = [];

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       SpareRepository()
//           .getTicketSpareList(context, ticketId: widget.ticketNumber);
//       setState(() {});
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Edit Spares',
//           style: TextStyle(fontFamily: "Mulish", color: Colors.white),
//         ),
//         backgroundColor: Color.fromRGBO(30, 152, 165, 1),
//         iconTheme: const IconThemeData(
//           color: Colors.white, //change your color here
//         ),
//       ),
//       body:
//           // Contents of the second tab (General Spares)
//           Consumer<SpareProvider>(
//         builder: (context, spare, _) {
//           spareDetails = spare.ticketData?.ticketSpareData ?? [];
//           editStates = List.generate(
//               spareDetails.length, (index) => ValueNotifier(false));
//           // Initialize checkbox states and quantity values only if the length changes
//           if (checkboxStates.length != spareDetails.length) {
//             checkboxStates = List.generate(
//                 spareDetails.length, (index) => ValueNotifier(false));
//             quantityValues = List.generate(
//                 spareDetails.length,
//                 (index) => ValueNotifier(spareDetails[index]
//                     .consumedQty
//                     .toString())); // Initialize quantity values
//           }
//           if (editStates.length != spareDetails.length) {
//             // Initialize editStates for each spare item if not initialized
//             editStates = List.generate(
//               spareDetails.length,
//               (index) => ValueNotifier(false),
//             );
//           }
//           quantityValues = List.generate(
//               spareDetails.length, (index) => ValueNotifier<String>('0'));
//           quantityControllers = List.generate(
//               spareDetails.length, (index) => TextEditingController());

//           if (quantityControllers.length != spareDetails.length) {
//             quantityControllers = List.generate(
//                 spareDetails.length,
//                 (index) => TextEditingController(
//                     text:
//                         quantityValues[index].value)); // Initialize controllers
//           }
//           return spare.isLoading
//               ? SingleChildScrollView(
//                   child: const Center(
//                       child: Padding(
//                     padding: EdgeInsets.all(15),
//                     child: ShimmerLists(
//                       count: 10,
//                       width: double.infinity,
//                       height: 300,
//                       shapeBorder: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10))),
//                     ),
//                   )),
//                 )
//               : spareDetails.isEmpty
//                   ? Center(
//                       child: NoDataScreen(),
//                     )
//                   : ListView(
//                     children: [
//                       const SizedBox(height: 10),
//                       _buildSearchField(),
//                       const SizedBox(height: 10),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: spareDetails.length,
//                         itemBuilder: (context, index) {
//                           return _buildSpareCard(
//                               spareDetails[index], index);
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       // Show the save button only if spareDetails is not empty
//                       _buildSaveButton(context),
//                     ],
//                   );
//         },
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         style: const TextStyle(fontFamily: "Mulish", color: Colors.black),
//         decoration: InputDecoration(
//           hintText: 'Search',
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
//     print(widget.ticketNumber);
//     final spareFuture = ref
//         .watch(apiServiceProvider)
//         .TicketSpareLists(ticketId: widget.ticketNumber);

//     return Expanded(
//       child: FutureBuilder<SpareEditListsModel>(
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
//             print('Error: ${snapshot.error}');
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData ||
//               snapshot.data!.ticketSpareData.isEmpty) {
//             print('No Data Available or ticketSpareData is null');
//             return Center(
//               child: NoDataScreen(),
//             );
//           }
//           print('Fetched Data: ${snapshot.data!.ticketSpareData}');

//           spareDetails = snapshot.data!.ticketSpareData;

//           // Initialize checkbox states and quantity values only if the length changes
//           if (checkboxStates.length != spareDetails.length) {
//             checkboxStates = List.generate(
//                 spareDetails.length, (index) => ValueNotifier(false));
//             quantityValues = List.generate(spareDetails.length,
//                 (index) => ValueNotifier('')); // Initialize quantity values
//           }
//           editStates = List.generate(
//               spareDetails.length, (index) => ValueNotifier(false));
//           quantityValues = List.generate(
//               spareDetails.length, (index) => ValueNotifier<String>('0'));
//           quantityControllers = List.generate(
//               spareDetails.length, (index) => TextEditingController());

//           if (quantityControllers.length != spareDetails.length) {
//             quantityControllers = List.generate(
//                 spareDetails.length,
//                 (index) => TextEditingController(
//                     text:
//                         quantityValues[index].value)); // Initialize controllers
//           }
//           return ListView.builder(
//             itemCount: spareDetails.length,
//             itemBuilder: (context, index) {
//               return _buildSpareCard(spareDetails[index], index);
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildSpareCard(TicketSpareData spare, int index) {
//     // Check if checkboxStates and quantityValues are initialized
//     if (index >= checkboxStates.length || index >= quantityValues.length) {
//       return Container(); // Return empty container if lists are not initialized correctly
//     }

//     return Card(
//       elevation: 5,
//       margin: const EdgeInsets.all(10),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildCheckboxRow(spare, index),
//             const SizedBox(height: 5),
//             _buildTextRow('Location:', spare.spareLocation.toString()),
//             _buildTextRow('Re-Order Quantity:', spare.spareMinQty.toString()),
//             _buildTextRow('Hand Stock:', spare.spareStock.toString()),
//             const SizedBox(height: 5),
//             _buildPriceQuantityRow(spare, index), // Use modified row here
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCheckboxRow(TicketSpareData spare, int index) {
//     return Row(
//       children: [
//         Text(
//           spare.spareName.toString(),
//           style: const TextStyle(
//             fontFamily: "Mulish",
//             color: Color(0xFF018786),
//             fontWeight: FontWeight.w600,
//             fontSize: 17,
//           ),
//         ),
//         const Spacer(),
//         IconButton(
//           onPressed: () {
//             editStates[index].value =
//                 !editStates[index].value; // Toggle edit state
//           },
//           icon: const Icon(Icons.edit_outlined),
//         ),
//         const SizedBox(width: 5),
//         IconButton(
//           onPressed: () {
//             _deleteSpareItem(index, spare);
//           },
//           icon: const Icon(Icons.delete_outline_outlined),
//         ),
//       ],
//     );
//   }

//   void _deleteSpareItem(int index, TicketSpareData spare) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: const Text('Delete Item'),
//           content: const Text('Are you sure you want to delete this item?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   // Check the current contents of spareDetails before deletion
//                   print('Before Deletion: $spareDetails');
//                   // Remove the item from the list
//                   spareDetails.removeAt(index);
//                   // Check the contents after deletion
//                   print('After Deletion: $spareDetails');
//                 });

//                 // Prepare the JSON list for the remaining spare parts
//                 List<Map<String, dynamic>> selectedSpareParts = [];

//                 // Check if spareDetails still contains items
//                 // if (spareDetails.isNotEmpty) {
//                 // for (int i = 0; i < spareDetails.length; i++) {
//                 final currentQuantity = spare.consumedQty
//                     .toString(); // Current value from text field
//                 final parsedQuantity = double.tryParse(currentQuantity) ??
//                     0.0; // Parse the current value
//                 final spareId = spare.spareId;

//                 // Calculate total cost based on the edited quantity
//                 final totalCost =
//                     parsedQuantity * spare.spareUnitPrice.toDouble();

//                 // Add edited spare part details to the list
//                 selectedSpareParts.add({
//                   "total_cost": totalCost, // Calculated total cost
//                   "spare_id": spareId, // Spare ID
//                   "is_checked":
//                       "false", // Set "is_checked" to false because it was deleted
//                   "consumed_qty": currentQuantity, // New quantity entered
//                   "on_hand_stock": spare.spareStock // Current stock
//                 });
//                 // }
//                 // } else {
//                 //   print(spareDetails.length);
//                 // }

//                 // Convert the list of edited spare parts to JSON
//                 String jsonString = jsonEncode(selectedSpareParts);

//                 // Log the JSON string for debugging
//                 print("Selected Spare Parts JSON: $jsonString");

//                 // Call your API to save the updated spare parts data
//                 ApiService()
//                     .SpareSave(
//                         ticketId: widget.ticketNumber, spares: jsonString)
//                     .then((value) {
//                   if (value.isError == false) {
//                     // Close the screen if the save operation is successful
//                     Navigator.of(context).pop();
//                   }

//                   // Display a message based on the response
//                   showMessage(
//                       context: context,
//                       isError: value.isError!,
//                       responseMessage: value.message!);
//                 });

//                 // Show snackbar feedback
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Item deleted successfully'),
//                   ),
//                 );

//                 // Close the dialog
//                 Navigator.of(context)
//                     .pop(); // Close the delete confirmation dialog
//               },
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
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

//   Widget _buildPriceQuantityRow(TicketSpareData spare, int index) {
//     return ValueListenableBuilder<bool>(
//       valueListenable:
//           editStates[index], // Listen to the edit state of this row
//       builder: (context, isEditing, child) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _buildColumnText('Unit Price', spare.spareUnitPrice.toString()),
//             isEditing
//                 ? _buildQuantityInput(index) // Show input if editing
//                 : _buildColumnText('Quantity',
//                     spare.consumedQty.toString()), // Show text if not editing
//             _buildColumnText('Total Cost', '₹${spare.totalCost.toString()}'),
//           ],
//         );
//       },
//     );
//   }

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
//           width: 120,
//           height: 50,
//           child: TextField(
//             controller: quantityControllers[index], // Use the controller
//             decoration: InputDecoration(
//               focusedBorder: const UnderlineInputBorder(
//                 borderSide: BorderSide(color: Color(0xFF018786)),
//               ),
//               enabledBorder: const UnderlineInputBorder(
//                 borderSide: BorderSide(color: Colors.grey),
//               ),
//               errorText:
//                   _getQuantityErrorText(index, quantityControllers[index].text),
//             ),
//             cursorColor: const Color(0xFF018786),
//             textAlign: TextAlign.center,
//             keyboardType: TextInputType.number,
//             onChanged: (newValue) {
//               bool validQuantities = true;

//               final enteredQuantity = double.tryParse(newValue) ?? -1;
//               if (enteredQuantity >= 0 &&
//                   enteredQuantity <= spareDetails[index].spareStock) {
//                 quantityValues[index].value = newValue; // Update ValueNotifier
//               } else {
//                 quantityValues[index].value = ""; // Clear invalid input
//               }
//               final originalQuantity = spareDetails[index]
//                   .consumedQty
//                   .toString(); // Original quantity from data
//               final currentQuantity =
//                   quantityValues[index].value; // Current value from text field
//               var parsedQuantity = double.tryParse(currentQuantity) ??
//                   0.0; // Parse the current value

//               // Check if the quantity has been edited
//               if (currentQuantity != originalQuantity) {
//                 if (parsedQuantity <= 0) {
//                   parsedQuantity = 0;
//                   validQuantities =
//                       false; // Set as invalid if consumed quantity is 0 or less
//                   showMessage(
//                       context: context,
//                       isError: true,
//                       responseMessage:
//                           'Consumed Quantity Must be\nGreater than 0\nand below HandStock...');
//                   return; // Exit the loop if invalid
//                 }

//                 final spareId = spareDetails[index].spareId;

//                 // Calculate total cost based on the edited quantity
//                 final totalCost = parsedQuantity *
//                     spareDetails[index].spareUnitPrice.toDouble();
//                 selectedSpareParts.clear();
//                 // Add edited spare part details to the list
//                 selectedSpareParts.add({
//                   "total_cost": totalCost, // Calculated total cost
//                   "spare_id": spareId, // Spare ID
//                   "is_checked":
//                       "true", // Set "is_checked" to true because it was edited
//                   "consumed_qty": currentQuantity, // New quantity entered
//                   "on_hand_stock":
//                       spareDetails[index].spareStock // Current stock
//                 });
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   String? _getQuantityErrorText(int index, String value) {
//     final enteredQuantity = double.tryParse(value);
//     if (enteredQuantity == null || enteredQuantity < 0) {
//       return 'Must be ≥ 0'; // Error if below 0
//     } else if (enteredQuantity > spareDetails[index].spareStock) {
//       return 'Exceeds stock'; // Error if exceeds hand stock
//     }
//     return null; // No error
//   }

//   Widget _buildSaveButton(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         List<Map<String, dynamic>> selectedSpareParts = [];

//         bool validQuantities = true;

//         for (int i = 0; i < checkboxStates.length; i++) {
//           if (checkboxStates[i].value) {
//             final spareId = spareDetails[i].spareId;
//             final quantityText = quantityValues[i].value;
//             final quantity = double.tryParse(quantityText) ?? 0.0;

//             // Check if quantity exceeds hand stock
//             if (quantity > spareDetails[i].spareStock) {
//               validQuantities = false;
//               showMessage(
//                 context: context,
//                 isError: true,
//                 responseMessage:
//                     'Entered quantity exceeds hand stock for ${spareDetails[i].spareName}',
//               );
//               break;
//             }

//             final totalCost =
//                 quantity * spareDetails[i].spareUnitPrice.toDouble();

//             selectedSpareParts.add({
//               "total_cost": totalCost,
//               "spare_id": spareId,
//               "is_checked": checkboxStates[i].value.toString(),
//               "consumed_qty": quantityText,
//               "on_hand_stock": spareDetails[i].spareStock,
//             });
//           }
//         }

//         if (validQuantities) {
//           // Convert to JSON and send to API if all quantities are valid
//           String jsonString = jsonEncode(selectedSpareParts);
//           print(jsonString);

//           ApiService()
//               .SpareSave(ticketId: widget.ticketNumber, spares: jsonString)
//               .then((value) {
//             if (value.isError == false) {
//               Navigator.of(context).pop();
//             }
//             showMessage(
//                 context: context,
//                 isError: value.isError!,
//                 responseMessage: value.message!);
//           });
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
