// import 'package:flutter/material.dart';

// class FilterBottomSheet extends StatefulWidget {
//   const FilterBottomSheet({super.key});

//   @override
//   State<FilterBottomSheet> createState() => _FilterBottomSheetState();
// }

// class _FilterBottomSheetState extends State<FilterBottomSheet> {
//   String dropdownValue = 'Ascending';
//   String selectedSortOption = 'Date and Time'; // Default sorting option
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 40,
//             height: 4,
//             margin: const EdgeInsets.symmetric(vertical: 10),
//             decoration: BoxDecoration(
//               color: Colors.grey,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     const Text(
//                       'Sort By',
//                       style: TextStyle(
//                           fontFamily: "Mulish",
//                           fontWeight: FontWeight.w600,
//                           fontSize: 20,
//                           color: Color.fromRGBO(21, 147, 159, 1)),
//                     ),
//                     const Spacer(),
//                     StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                         return DropdownButton<String>(
//                           value: dropdownValue,
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               dropdownValue = newValue!;
//                             });
//                           },
//                           items: ['Ascending', 'Descending']
//                               .map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 _buildSortOption(
//                     'Date and Time', Icons.calendar_month_outlined),
//                 const SizedBox(height: 10),
//                 _buildSortOption('Ticket Number', Icons.airplane_ticket),
//                 const SizedBox(height: 10),
//                 _buildSortOption('Status', Icons.filter_tilt_shift_sharp),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     print(dropdownValue);
//                     print(selectedSortOption);
//                     setState(() {
//                       _sortAssetList(); // Sort the list and trigger a rebuild
//                     });
//                     Navigator.pop(
//                         context); // Close the bottom sheet after sorting
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromRGBO(21, 147, 159, 1),
//                   ),
//                   child: const Text(
//                     'Submit',
//                     style: TextStyle(
//                       fontFamily: "Mulish",
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSortOption(String label, IconData icon) {
//     return GestureDetector(
//       onTap: () {
//         selectedSortOption = label;
//       },
//       child: Row(
//         children: [
//           Icon(icon,
//               color: selectedSortOption == label
//                   ? Color(0xFF018786)
//                   : Colors.black),
//           const SizedBox(width: 10),
//           Text(label,
//               style: TextStyle(
//                 fontFamily: "Mulish",
//                 color: selectedSortOption == label
//                     ? Color(0xFF018786)
//                     : Colors.black,
//                 fontWeight: selectedSortOption == label
//                     ? FontWeight.bold
//                     : FontWeight.normal,
//               )),
//         ],
//       ),
//     );
//   }

//   void _sortAssetList() {
//     setState(() {
//       // Sort the assetList in place based on selectedSortOption and dropdownValue
//       if (selectedSortOption == 'Ticket Number') {
//         assetList.sort((a, b) {
//           int comparison = a.ticketNo!.compareTo(b.ticketNo!);
//           return dropdownValue == 'Ascending' ? comparison : -comparison;
//         });
//       } else if (selectedSortOption == 'Date and Time') {
//         assetList.sort((a, b) {
//           DateTime dateA = DateTime.parse(a.createdOn!);
//           DateTime dateB = DateTime.parse(b.createdOn!);
//           int comparison = dateA.compareTo(dateB);
//           return dropdownValue == 'Ascending' ? comparison : -comparison;
//         });
//       } else if (selectedSortOption == 'Status') {
//         assetList.sort((a, b) {
//           int comparison = a.status!.compareTo(b.status!);
//           return dropdownValue == 'Ascending' ? comparison : -comparison;
//         });
//       }
//     });
//   }
// }
