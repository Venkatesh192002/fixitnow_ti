import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/machine_iot/screens/MainCategoryDialog.dart';
import 'package:auscurator/machine_iot/screens/SubCategoryDialog.dart';
import 'package:auscurator/machine_iot/screens/custom_search_dialog.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/elevated_button_widget.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/model/AssetModel.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:auscurator/machine_iot/widget/qr_scanner_widget.dart';
import 'package:auscurator/model/BreakdownTicketModel.dart';
import 'package:auscurator/model/MainCategoryModel.dart';
import 'package:auscurator/model/SubCategoryModel.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:auscurator/provider/ticket_provider.dart';
import 'package:auscurator/repository/breakdown_repository.dart';
import 'package:auscurator/repository/ticket_repository.dart';
import 'package:auscurator/screens/breakdown/screen/breakdown1.dart';
import 'package:auscurator/screens/breakdown/widgets/date_time_picker.dart';
import 'package:auscurator/screens/breakdown/widgets/segmented_priority.dart';
import 'package:auscurator/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  Future<void> _fetchTicketCounts() async {
    BreakdownRepository()
        .getBreakDownStatusList(context,
            breakdown_status: apiKeys[selectedIndex].toLowerCase(),
            period: 'from_to',
            from_date: DateFormat('dd-MM-yyyy').format(fromDate!),
            to_date: DateFormat('dd-MM-yyyy').format(toDate!),
            user_login_id: '')
        .then((value) {
      if (breakProvider.breakDownOverallData?.breakdownListCount != null &&
          breakProvider.breakDownOverallData!.breakdownListCount!.isNotEmpty) {
        BreakdownListCount countData = (breakProvider
                    .breakDownOverallData?.breakdownListCount?.isNotEmpty ??
                false)
            ? breakProvider.breakDownOverallData!.breakdownListCount![0]
            : BreakdownListCount();
        assetList =
            breakProvider.breakDownOverallData?.breakdownDetailList ?? [];

        // Update counts in the state
        // setState(() {
        counts[0] = countData.open ?? 0;
        counts[1] = countData.assigned ?? 0;
        counts[2] = countData.accepted ?? 0;
        counts[3] = countData.onProgress ?? 0;
        counts[4] = countData.holdPending ?? 0;
        counts[5] = countData.acknowledge ?? 0;
        counts[6] = countData.closed ?? 0;
        // counts[5] = countData.rca!;
        // counts[6] = countData.acknowledge!;
        // counts[7] = countData.closed!;
        // });
      }
    });
  }

  String selectedPriority = 'Low';
  String selectedStatus = '1';
  // String selectedText = '';
  String selectedAssetId = '';
  String selectedAssetGroupId = '';
  String selectedMainCategoryId = '';
  String selectedSubCategoryId = '';
  TextEditingController textController = TextEditingController();
  TextEditingController textCategoryController = TextEditingController();
  TextEditingController textSubCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketProvider>(
      builder: (context, ticket, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10.0), // Adjust padding inside content
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjust height dynamically
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10.0),
                  const Text(
                    'Create Ticket',
                    style: TextStyle(
                        fontFamily: "Mulish",
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(21, 147, 159, 1)),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: textController,
                    readOnly: true,
                    onTap: () async {
                      // Show the CustomSearchDialog and get the selected asset
                      final AssetLists? result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomSearchDialog();
                        },
                      );
                      // Check if a result was returned
                      if (result != null) {
                        setState(() {
                          // Update the text field with the assetCode, but you can also use asset_id and asset_group_id
                          textController.text =
                              result.assetCode ?? 'Unknown Asset';
                          selectedAssetId = result.assetId.toString();
                          selectedAssetGroupId = result.assetGroupId.toString();
                          textCategoryController.clear();
                          textSubCategoryController.clear();
                          logger.e(selectedAssetId);
                          // You can store or use asset_id and asset_group_id here
                          print(
                              'Asset ID: ${result.assetId}, Asset Group ID: ${result.assetGroupId}');
                        });
                        // SharedPreferences prefs =
                        //     await SharedPreferences.getInstance();
                        // await prefs.setString('asset_group_id',
                        //     result.assetGroupId.toString());
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Select or Scan Equipment ID',
                      labelStyle: TextStyle(
                        fontFamily: "Mulish",
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          // Navigate to the QR scanner and wait for the result
                          final scannedValue = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QRScannerWidget(),
                            ),
                          );
                          Map<String, dynamic> matchingAsset = {};
                          // Check if a scanned value was returned
                          if (scannedValue != null) {
                            matchingAsset =
                                ticketProvider.listEquipmentData?.firstWhere(
                              (asset) => asset["asset_code"] == scannedValue,
                              orElse: () => null,
                            );

                            textController.text = scannedValue;
                            selectedAssetId =
                                matchingAsset["asset_id"].toString();

                            selectedAssetGroupId =
                                matchingAsset["asset_group_id"].toString();
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('asset_group_id',
                                "${matchingAsset["asset_group_id"]}");

                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.qr_code_scanner_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Date and Time',
                          style: TextStyle(
                              fontFamily: "Mulish",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(21, 147, 159, 1)),
                        ),
                      )),
                  const SizedBox(height: 10.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DatePicker(),
                      SizedBox(width: 10.0),
                      TimePicker(),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Breakdown Category*',
                          style: TextStyle(
                              fontFamily: "Mulish",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(21, 147, 159, 1)),
                        ),
                      )),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: textCategoryController,
                    readOnly: true,
                    onTap: () async {
                      // Show the CustomSearchDialog and get the selected asset
                      final MainBreakdownCategoryLists? result =
                          await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MainCategoryDialog();
                        },
                      );
                      logger.e(result?.toJson());

                      if (result != null) {
                        setState(() {
                          textCategoryController.text =
                              result.breakdownCategoryName.toString();
                          selectedMainCategoryId =
                              result.breakdownCategoryId.toString();
                          textSubCategoryController.clear();
                          // logger.e(selectedMainCategoryId);
                        });
                        // SharedPreferences prefs =
                        //     await SharedPreferences.getInstance();
                        // await prefs.setString('breakdown_category_id',
                        //     result.breakdownCategoryId.toString());
                        BreakdownRepository().getListOfBreadownSub1(context,
                            breakdownCategoryId: selectedMainCategoryId,
                            assetGroupid: selectedAssetGroupId);
                      }
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      labelText: 'Select Breakdown Category',
                      labelStyle: TextStyle(
                        fontFamily: "Mulish",
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Breakdown SubCategory*',
                          style: TextStyle(
                              fontFamily: "Mulish",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(21, 147, 159, 1)),
                        ),
                      )),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: textSubCategoryController,
                    readOnly: true,
                    onTap: textCategoryController.text.isEmpty
                        ? () {
                            return showToast("Kindly select Breakdown Category",
                                isError: true);
                            // showMessage(
                            //     context: context,
                            //     isError: true,
                            //     responseMessage: "Kindly select Equipment Id");
                          }
                        : () async {
                            final BreakdownCategoryLists? result =
                                await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SubCategoryDialog();
                              },
                            );
                            if (result != null) {
                              setState(() {
                                textSubCategoryController.text =
                                    result.breakdownSubCategory.toString();
                                selectedSubCategoryId =
                                    result.breakdownSubCategoryId.toString();
                                    logger.f(selectedSubCategoryId);
                                logger.e(result.toJson());
                              });
                              print(
                                  'Breakdown SubCategory ID: ${result.breakdownCategoryId}');
                            }
                          },
                    decoration: const InputDecoration(
                      labelText: 'Select Breakdown SubCategory',
                      labelStyle: TextStyle(
                        fontFamily: "Mulish",
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Machine Status',
                          style: TextStyle(
                              fontFamily: "Mulish",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(21, 147, 159, 1)),
                        ),
                      )),
                  const SizedBox(height: 10.0),
                  SegmentedControlStatus(
                    onStatusChanged: (String status) {
                      setState(() {
                        selectedStatus = status; // Update the selected priority
                      });
                    },
                  ),
                  const SizedBox(height: 10.0),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Priority',
                          style: TextStyle(
                              fontFamily: "Mulish",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(21, 147, 159, 1)),
                        ),
                      )),
                  const SizedBox(height: 10.0),
                  SegmentedControlPriority(
                    onPriorityChanged: (String priority) {
                      setState(() {
                        selectedPriority =
                            priority; // Update the selected priority
                      });
                    },
                  ),
                  const SizedBox(height: 10.0),
                  ticket.isLoading
                      ? Loader()
                      : Row(
                          children: [
                            ElevatedButtonWidget(
                              flex: 1,
                              label: 'Submit',
                              onTab: textController.text.isEmpty ||
                                      textCategoryController.text.isEmpty ||
                                      textSubCategoryController.text.isEmpty
                                  ? () {
                                      return showToast(
                                          "Kindly select Mandatory Fields",
                                          isError: true);
                                      // showMessage(
                                      //     context: context,
                                      //     isError: true,
                                      //     responseMessage: "Kindly select Equipment Id");
                                    }
                                  : () {
                                      if (selectedAssetGroupId.isNotEmpty ||
                                          selectedAssetId.isNotEmpty ||
                                          selectedMainCategoryId.isNotEmpty ||
                                          selectedSubCategoryId.isNotEmpty ||
                                          selectedStatus.isNotEmpty ||
                                          selectedPriority.isNotEmpty) {
                                        TicketRepository()
                                            .saveTicket(context,
                                                assetGroupId:
                                                    selectedAssetGroupId,
                                                assetId: selectedAssetId,
                                                breakdownCategoryId:
                                                    selectedMainCategoryId,
                                                assetStatus: selectedStatus,
                                                priorityId: selectedPriority,
                                                userLoginId: '',
                                                comment: '',
                                                breakdownSubCategoryId:
                                                    selectedSubCategoryId)
                                            .then((value) {
                                          (value);
                                          // BreakdownRepository()
                                          //     .getBreakDownStatusList(
                                          //   context,
                                          //   breakdown_status: "0",
                                          //   period: 'from_to',
                                          //   from_date:
                                          //       '', // Default or selected date
                                          //   to_date:
                                          //       '', // Default or selected date
                                          //   user_login_id: '',
                                          // );
                                          _fetchTicketCounts();
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        showMessage(
                                            context: context,
                                            isError: true,
                                            responseMessage:
                                                'Kindly Select Mandatory Fields');
                                      }
                                    },
                            ),
                            // BlocConsumer<SaveButtonBloc, SaveButtonState>(
                            //   builder: (context, state) {
                            //     return ElevatedButtonWidget(
                            //       flex: 1,
                            //       label: state is SaveButtonLoadingState
                            //           ? 'Loading...!'
                            //           : 'Submit',
                            //       onTab: () {
                            //         if (selectedAssetGroupId.isNotEmpty ||
                            //             selectedAssetId.isNotEmpty ||
                            //             selectedMainCategoryId.isNotEmpty ||
                            //             selectedSubCategoryId.isNotEmpty ||
                            //             selectedStatus.isNotEmpty ||
                            //             selectedPriority.isNotEmpty) {
                            //           BlocProvider.of<SaveButtonBloc>(context).add(
                            //             SaveButtonOnClickEvent(
                            //                 assetGroupId: selectedAssetGroupId,
                            //                 assetId: selectedAssetId,
                            //                 breakdownCategoryId:
                            //                     selectedMainCategoryId,
                            //                 breakdownsubCategoryId:
                            //                     selectedSubCategoryId,
                            //                 assetStatus: selectedStatus,
                            //                 priorityId: selectedPriority,
                            //                 userLoginId: '',
                            //                 comment: ''),
                            //           );
                            //           _fetchTicketCounts();
                            //         } else {
                            //           showMessage(
                            //               context: context,
                            //               isError: true,
                            //               responseMessage:
                            //                   'Kindly Select Mandatory Fields');
                            //         }
                            //       },
                            //     );
                            //   },
                            //   listener: (context, state) {
                            //     if (state is SaveButtonErrorState) {
                            //       print(state.errorMessage.toString());
                            //       Util.showToastMessage(
                            //           10, context, state.errorMessage, true);
                            //     }
                            //     if (state is SaveButtonSuccessState) {
                            //       Util.showToastMessage(
                            //           10, context, state.message, false);
                            //       Navigator.of(context).pop();
                            //     }
                            //   },
                            // ),
                            const Gap(10),
                            ElevatedButtonWidget(
                              flex: 1,
                              label: 'Cancel',
                              onTab: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
