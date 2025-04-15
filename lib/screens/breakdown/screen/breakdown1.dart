// ignore_for_file: deprecated_member_use
import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/screens/MainCategoryDialog.dart';
import 'package:auscurator/machine_iot/screens/SubCategoryDialog.dart';
import 'package:auscurator/machine_iot/screens/all_ticket_details.dart';
import 'package:auscurator/machine_iot/screens/custom_search_dialog.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/elevated_button_widget.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/model/AssetModel.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:auscurator/machine_iot/widget/qr_scanner_widget.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/machine_iot/widget/ticket_info_cart_widget.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/model/BreakdownTicketModel.dart';
import 'package:auscurator/model/MainCategoryModel.dart';
import 'package:auscurator/model/SubCategoryModel.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:auscurator/provider/breakkdown_provider.dart';
import 'package:auscurator/provider/ticket_provider.dart';
import 'package:auscurator/repository/asset_repository.dart';
import 'package:auscurator/repository/breakdown_repository.dart';
import 'package:auscurator/repository/ticket_repository.dart';
import 'package:auscurator/repository/work_log_repository.dart';
import 'package:auscurator/screens/breakdown/screen/create_ticket.dart';
import 'package:auscurator/screens/breakdown/widgets/accept_dialog.dart';
import 'package:auscurator/screens/breakdown/widgets/date_time_picker.dart';
import 'package:auscurator/screens/breakdown/widgets/deny_dialog.dart';
import 'package:auscurator/screens/breakdown/widgets/segmented_priority.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/widgets/bottom_sheet.dart';
import 'package:auscurator/widgets/context_extension.dart';
import 'package:auscurator/widgets/dialogs.dart';
import 'package:auscurator/widgets/loaders.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Breakdown1 extends StatefulWidget {
  const Breakdown1({super.key});

  @override
  State<Breakdown1> createState() => _Breakdown1State();
}

TextEditingController searchController = TextEditingController();
// Default sorting option
DateTime? fromDate;
DateTime? toDate;

List<String> statusList = [
  // 'Open',
  'Assigned',
  'Accepted',
  'In Progress',
  'Pending',
  'Await RCA',
  'Approval of MFG',
  'Acknowledge',
  'Closed'
];
// Corresponding API keys for counts
List<String> apiKeys = [
  // 'Open',
  'Assigned',
  'Accepted',
  'On_Progress',
  'Hold_Pending',
  'rca',
  'approval_mfg',
  'Acknowledge',
  'Closed'
];

List<int> counts = List.filled(8, 0);

int selectedIndex = 0;

List<BreakdownDetailList> assetList = [];
List<BreakdownDetailList> sortedList = [];
List<BreakdownListCount> countList = [];
String dropdownValue = 'Ascending';
String selectedSortOption = 'Date and Time';
Future<BreakkdownTicketModel>? companyFuture;
// bool _isFirstLoad = true;
bool isSearching = false;
String selectedPriority = 'Medium';
String selectedStatus = '1';

class _Breakdown1State extends State<Breakdown1> {
  final employee_type = SharedUtil().getEmployeeType;
  final employee_name = SharedUtil().getEmployeeName;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      BreakdownRepository().getBreakDownStatusList(
        context, breakdown_status: apiKeys[selectedIndex].toLowerCase(),
        period: 'from_to',
        from_date: fromDate != null
            ? DateFormat('dd-MM-yyyy').format(fromDate!)
            : '', // Default or selected date
        to_date: toDate != null
            ? DateFormat('dd-MM-yyyy').format(toDate!)
            : '', // Default or selected date
        user_login_id: '',
      );
      TicketRepository().getAssetEquipmentList(context);
      BreakdownRepository().getListOfBreadownSub(context);
      BreakdownRepository().getRootCauseList(context);
      BreakdownRepository().getListOfIssue(context);
      AssetRepository().getListOfEquipment(context);
    });
    checkConnection(context);
    searchController.addListener(() {
      filterItems();
    });
    // Set default dates: 'from' is one month before today, 'to' is today
    fromDate = DateTime.now().subtract(const Duration(days: 30));
    toDate = DateTime.now();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   if (_isFirstLoad) {
  //     // Fetch the ticket counts after dependencies are loaded
  //     _fetchTicketCounts();
  //     _isFirstLoad = false; // Ensure this is only called once
  //   }
  // }

  void filterItems() {
    setState(() {}); // Trigger a rebuild to filter in the UI
  }

  // Function to fetch ticket counts
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
        // counts[0] = countData.open ?? 0;
        counts[0] = countData.assigned ?? 0;
        counts[1] = countData.accepted ?? 0;
        counts[2] = countData.onProgress ?? 0;
        counts[3] = countData.holdPending ?? 0;
        counts[4] = countData.rca ?? 0;
        counts[5] = countData.approvalMfg ?? 0;
        counts[6] = countData.acknowledge ?? 0;
        counts[7] = countData.closed ?? 0;
        // counts[5] = countData.rca!;
        // counts[6] = countData.acknowledge!;
        // counts[7] = countData.closed!;
        // });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(statusList[selectedIndex]);
    return Consumer<BreakkdownProvider>(
      builder: (context, breakDown, _) {
        BreakdownListCount countData =
            (breakDown.breakDownOverallData?.breakdownListCount?.isNotEmpty ??
                    false)
                ? breakDown.breakDownOverallData!.breakdownListCount![0]
                : BreakdownListCount(); // Provide a default instance

        // Map the counts directly from the properties of BreakdownListCount
        // counts[0] = countData.open ?? 0;
        counts[0] = countData.assigned ?? 0;
        counts[1] = countData.accepted ?? 0;
        counts[2] = countData.onProgress ?? 0;
        counts[3] = countData.holdPending ?? 0;
        counts[4] = countData.rca ?? 0;
        counts[5] = countData.approvalMfg ?? 0;
        counts[6] = countData.acknowledge ?? 0;
        counts[7] = countData.closed ?? 0;
        // counts[5] = countData.rca!;
        // counts[6] = countData.acknowledge!;
        // counts[7] = countData.closed!;

        TextEditingController textFieldController = TextEditingController();

        textFieldController.clear();

        assetList = breakDown.breakDownOverallData?.breakdownDetailList ?? [];

        if (searchController.text.isNotEmpty) {
          assetList = assetList
              .where((asset) =>
                  asset.ticketNo != null &&
                  asset.ticketNo!
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()))
              .toList();
        }
        bool isTablet =
            MediaQuery.of(context).size.width > 600; // Threshold for tablets

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(30, 152, 165, 1),
            title: isSearching
                ? TextField(
                    controller: searchController,
                    autofocus: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search Tickets',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  )
                : Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Breakdown',
                      style: TextStyle(
                        fontFamily: "Mulish",
                        color: Colors.white,
                      ),
                    ),
                  ),
            actions: <Widget>[
              IconButton(
                icon: Icon(isSearching ? Icons.close : Icons.search),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                    if (!isSearching) {
                      searchController.clear();
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.filter_alt_outlined),
                color: Colors.white,
                onPressed: () => _showSortBottomSheet(context),
              ),
              TextButton(
                onPressed: () =>
                    commonBottomSheet(context, CreateTicketScreen()),
                child: Text(
                  'CREATE TICKET',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          backgroundColor: const Color.fromARGB(240, 255, 255, 255),
          body: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              HeightFull(),
              // if (!isSearching)
              // Padding(
              //   padding: const EdgeInsets.all(10),
              //   child: TextField(
              //     controller: searchController,
              //     decoration: InputDecoration(
              //       labelText: 'Search Tickets',
              //       labelStyle: TextStyle(
              //         fontFamily: "Mulish",
              //       ),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(20.0),
              //       ),
              //     ),
              //   ),
              // ),
              // From/To Date Picker
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(2, 4),
                              ),
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.05),
                                blurRadius: 16,
                                spreadRadius: -1,
                                offset: Offset(-2, -2),
                              ),
                            ]),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 20, // Adjust the size here
                              color: Color(0xFF018786),
                            ),
                            // Gap(3),
                            // Text(
                            //   "From:",
                            //   style: TextStyle(fontFamily: "Mulish",
                            //     fontSize: 16,
                            //   ),
                            // ),
                            SizedBox(width: 12),
                            Text(
                              fromDate != null
                                  ? DateFormat('dd-MM-yyyy').format(fromDate!)
                                  : 'Select From Date',
                              style: TextStyle(
                                  fontFamily: "Mulish",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(2, 4),
                              ),
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.05),
                                blurRadius: 16,
                                spreadRadius: -1,
                                offset: Offset(-2, -2),
                              ),
                            ]),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 20, // Adjust the size here
                              color: Color(0xFF018786),
                            ),
                            // Gap(3),
                            // Text(
                            //   "To:",
                            //   style: TextStyle(fontFamily: "Mulish",
                            //     fontSize: 16,
                            //   ),
                            // ),
                            SizedBox(width: 12),

                            Text(
                              toDate != null
                                  ? DateFormat('dd-MM-yyyy').format(toDate!)
                                  : 'Select To Date',
                              style: TextStyle(
                                  fontFamily: "Mulish",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12.0),
              // Horizontal list
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  height: 50, // Set the height of the horizontal list
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: statusList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedIndex == index
                                ? const Color.fromRGBO(
                                    21, 147, 159, 1) // Selected button color
                                : Colors.white, // Unselected button color
                            foregroundColor: selectedIndex == index
                                ? Colors.white // Text color for selected
                                : Colors.black, // Text color for unselected
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation:
                                2, // Control the elevation for the shadow effect
                          ),
                          onPressed: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            _fetchTicketCounts();
                          },
                          child: Text(
                            '${statusList[index]} (${counts[index]})',
                            style: TextStyle(
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Vertical list
              // FutureBuilder(
              //     future: companyFuture,
              //     builder: (context, snapshot) {
              // if (snapshot.hasError) {
              //   return Center(child: Text(snapshot.error.toString()));
              // }
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return SingleChildScrollView(
              //     child: const Center(
              //         child: Padding(
              //       padding: EdgeInsets.all(15),
              //       child: ShimmerLists(
              //         count: 10,
              //         width: double.infinity,
              //         height: 300,
              //         shapeBorder: RoundedRectangleBorder(
              //             borderRadius:
              //                 BorderRadius.all(Radius.circular(10))),
              //       ),
              //     )),
              //   );
              // }
              // if (snapshot.data == null ||
              //     snapshot.data!.breakdownDetailList == null ||
              //     snapshot.data!.breakdownDetailList!.isEmpty) {
              //   return Center(child: NoDataScreen());
              // }
              // if (snapshot.data!.breakdownListCount != null &&
              //     snapshot.data!.breakdownListCount!.isNotEmpty) {
              //   // Get the first object from the breakdownListCount list
              //   var countData = snapshot.data!.breakdownListCount![0];
              //   // Map the counts directly from the properties of BreakdownListCount
              //   counts[0] = countData.open!.toInt();
              //   counts[1] = countData.assigned!;
              //   counts[2] = countData.accepted!;
              //   counts[3] = countData.onProgress!;
              //   counts[4] = countData.holdPending!;
              //   counts[5] = countData.acknowledge!;
              //   counts[6] = countData.closed!;
              //   // counts[5] = countData.rca!;
              //   // counts[6] = countData.acknowledge!;
              //   // counts[7] = countData.closed!;
              // }
              // TextEditingController textFieldController =
              //     TextEditingController();

              // textFieldController.clear();

              // assetList = snapshot.data!.breakdownDetailList!;

              // if (searchController.text.isNotEmpty) {
              //   assetList = assetList
              //       .where((asset) =>
              //           asset.ticketNo != null &&
              //           asset.ticketNo!
              //               .toLowerCase()
              //               .contains(searchController.text.toLowerCase()))
              //       .toList();
              // }
              // bool isTablet = MediaQuery.of(context).size.width >
              //     600; // Threshold for tablets

              // return
              breakDown.isLoading
                  ? SingleChildScrollView(
                      child: const Center(
                          child: Padding(
                        padding: EdgeInsets.all(15),
                        child: ShimmerLists(
                          count: 10,
                          width: double.infinity,
                          height: 300,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      )),
                    )
                  : assetList.isEmpty
                      ? Center(child: NoDataScreen())
                      : RefreshIndicator(
                          onRefresh: () async {
                            // You can trigger the refresh logic here, like re-fetching data
                            await BreakdownRepository().getBreakDownStatusList(
                              context,
                              breakdown_status:
                                  apiKeys[selectedIndex].toLowerCase(),
                              period: 'from_to',
                              from_date: fromDate != null
                                  ? DateFormat('dd-MM-yyyy').format(fromDate!)
                                  : '', // Default or selected date
                              to_date: toDate != null
                                  ? DateFormat('dd-MM-yyyy').format(toDate!)
                                  : '', // Default or selected date
                              user_login_id: '',
                            );
                          },
                          child: SizedBox(
                            height: isTablet
                                ? context.heightFull() - 260
                                : context.heightHalf() + 150,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: assetList.length,
                              itemBuilder: (context, index) {
                                TextEditingController textFieldController =
                                    TextEditingController(
                                        text: assetList[index].status == 'Open'
                                            ? assetList[index]
                                                .openComment
                                                .toString()
                                            : assetList[index].status ==
                                                    'Assign'
                                                ? assetList[index]
                                                    .assignedComment
                                                    .toString()
                                                : assetList[index].status ==
                                                        'Accept'
                                                    ? assetList[index]
                                                        .acceptComment
                                                        .toString()
                                                    : assetList[index].status ==
                                                            'Check In'
                                                        ? assetList[index]
                                                            .checkInComment
                                                            .toString()
                                                        : assetList[index]
                                                                    .status ==
                                                                'On Hold'
                                                            ? assetList[index]
                                                                .pendingComment
                                                                .toString()
                                                            : assetList[index]
                                                                        .status ==
                                                                    'Pending'
                                                                ? assetList[
                                                                        index]
                                                                    .pendingComment
                                                                    .toString()
                                                                : assetList[index]
                                                                            .status ==
                                                                        'Completed'
                                                                    ? assetList[
                                                                            index]
                                                                        .completedComment
                                                                        .toString()
                                                                    : assetList[index].status ==
                                                                            'Fixed'
                                                                        ? assetList[index]
                                                                            .completedComment
                                                                            .toString()
                                                                        : assetList[index].status ==
                                                                                'Reject'
                                                                            ? assetList[index].rejectComment.toString()
                                                                            : assetList[index].status == 'Reopen'
                                                                                ? assetList[index].reopenComment.toString()
                                                                                : assetList[index].status == 'Reassign'
                                                                                    ? assetList[index].reassignComment.toString()
                                                                                    : 'empty');
                                return Column(
                                  children: [
                                    index == 0
                                        ? SizedBox(height: 12)
                                        : SizedBox.shrink(),
                                    GestureDetector(
                                      onTap: () {
                                        // logger.e(employee_type);
                                        // logger.e(assetList[index].status);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AllTicketDetails(
                                              ticketNumber: assetList[index]
                                                  .id
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                width: 5.0,
                                                color: () {
                                                  switch (
                                                      assetList[index].status) {
                                                    case "Open":
                                                      return Color(0xFF17a2b8);
                                                    case "Assign":
                                                    case "Reassign":
                                                      return Color(0xFF7a7a00);
                                                    case "Approval of Mfg":
                                                      return Color(0xFF7a7a00);
                                                    case "Accept":
                                                      return Color(0xFF64a300);
                                                    case "Pending":
                                                      return Color(0xFFc30000);
                                                    case "Fixed":
                                                      return Color(0xFF008000);
                                                    case "Completed":
                                                      return Color(0xFF0039a1);
                                                    case "Reject":
                                                      return Color(0xFFb53101);
                                                    case "Awaiting RCA":
                                                      return Color(0xFFb53101);
                                                    case "Reopen":
                                                      return Color(0xFF17a2b8);
                                                    case "Check In":
                                                      return Color(0xFF0072ff);
                                                    case "On Hold":
                                                      return Color(0xFFbb5600);
                                                    default:
                                                      return Colors.grey;
                                                  }
                                                }(),
                                              ),
                                            ),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 12,
                                                spreadRadius: 2,
                                                offset: Offset(0, 8),
                                              )
                                            ]),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${assetList[index].ticketNo}',
                                                  style: TextStyle(
                                                    fontFamily: "Mulish",
                                                    fontWeight: FontWeight.bold,
                                                    color: () {
                                                      switch (assetList[index]
                                                          .status) {
                                                        case "Open":
                                                          return Color(
                                                              0xFF17a2b8);
                                                        case "Assign":
                                                        case "Reassign":
                                                          return Color(
                                                              0xFF7a7a00);
                                                        case "Approval of Mfg":
                                                          return Color(
                                                              0xFF7a7a00);
                                                        case "Accept":
                                                          return Color(
                                                              0xFF64a300);
                                                        case "Pending":
                                                          return Color(
                                                              0xFFc30000);
                                                        case "Fixed":
                                                          return Color(
                                                              0xFF008000);
                                                        case "Completed":
                                                          return Color(
                                                              0xFF0039a1);
                                                        case "Reject":
                                                          return Color(
                                                              0xFFb53101);
                                                        case "Awaiting RCA":
                                                          return Color(
                                                              0xFFb53101);
                                                        case "Reopen":
                                                          return Color(
                                                              0xFF17a2b8);
                                                        case "Check In":
                                                          return Color(
                                                              0xFF0072ff);
                                                        case "On Hold":
                                                          return Color(
                                                              0xFFbb5600);
                                                        default:
                                                          return Colors.grey;
                                                      }
                                                    }(),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  '${assetList[index].status} | ',
                                                  style: TextStyle(
                                                      fontFamily: "Mulish",
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                    '${assetList[index].priority}',
                                                    style: const TextStyle(
                                                        fontFamily: "Mulish",
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.w500))
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            TicketInfoCardWidget(
                                                title: 'Date',
                                                value: assetList[index]
                                                            .createdOn !=
                                                        null
                                                    ? DateFormat(
                                                            'yyyy-MM-dd HH:mm')
                                                        .format(DateTime.parse(
                                                                assetList[index]
                                                                    .createdOn
                                                                    .toString())
                                                            .toLocal())
                                                    : 'N/A' // If createdOn is null, show 'N/A'
                                                ),
                                            const SizedBox(height: 5),
                                            TicketInfoCardWidget(
                                                title: 'Asset',
                                                value:
                                                    '${assetList[index].asset}'),
                                            const SizedBox(height: 5),
                                            TicketInfoCardWidget(
                                                title: 'Category',
                                                value:
                                                    '${assetList[index].breakdownCategoryName}'),
                                            const SizedBox(height: 5),
                                            TicketInfoCardWidget(
                                                title: 'Issue',
                                                value:
                                                    '${assetList[index].breakdownSubCategoryName}'),
                                            const SizedBox(height: 5),
                                            TicketInfoCardWidget(
                                                title: 'Department',
                                                value:
                                                    '${assetList[index].department}'),
                                            const SizedBox(height: 5),
                                            TicketInfoCardWidget(
                                                title: 'Raised By',
                                                value:
                                                    '${assetList[index].createdBy}'),
                                            const SizedBox(height: 5),
                                            if (assetList[index].status !=
                                                    'Open' &&
                                                assetList[index].status !=
                                                    'Reject' &&
                                                assetList[index].status !=
                                                    'Reassign') ...[
                                              TicketInfoCardWidget(
                                                  title: 'Assigned To',
                                                  value:
                                                      '${assetList[index].assignedToEngineer}'),
                                              const SizedBox(height: 5),
                                            ],
                                            TicketInfoCardWidget(
                                              title: 'Status',
                                              value: (assetList[index]
                                                              .assetStatus
                                                              ?.toString() ??
                                                          '') ==
                                                      '0'
                                                  ? 'Stopped'
                                                  : (assetList[index]
                                                                  .assetStatus
                                                                  ?.toString() ??
                                                              '') ==
                                                          '1'
                                                      ? 'Complaint'
                                                      : assetList[index]
                                                              .assetStatus
                                                              ?.toString() ??
                                                          'Unknown',
                                            ),
                                            const SizedBox(height: 5),
                                            if (assetList[index].status ==
                                                    'Completed' ||
                                                assetList[index].status ==
                                                    'Fixed') ...[
                                              TicketInfoCardWidget(
                                                  title: 'Completed By',
                                                  value:
                                                      '${assetList[index].fixedBy}'),
                                              const SizedBox(height: 5),
                                            ],
                                            if (assetList[index].status ==
                                                "Reject")
                                              TicketInfoCardWidget(
                                                  title: 'Rejected By',
                                                  value:
                                                      '${assetList[index].rejectedBy}'),
                                            // const SizedBox(height: 5),
                                            // if (assetList[index].status !=
                                            //     "Open")
                                            //   TicketInfoCardWidget(
                                            //       title: 'Assigned To',
                                            //       value:
                                            //           '${assetList[index].assignedToEngineer}'),
                                            const Divider(),
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      WorkLogRepository()
                                                          .getworlLogDetail(
                                                              context,
                                                              ticket_no:
                                                                  assetList[
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                              createdOn:
                                                                  assetList[
                                                                          index]
                                                                      .createdOn
                                                                      .toString(),
                                                              ticketNumber:
                                                                  assetList[
                                                                          index]
                                                                      .ticketNo
                                                                      .toString());
                                                    },
                                                    child: SvgPicture.asset(
                                                      'images/ic_log.svg',
                                                      width: 24,
                                                      height:
                                                          24, // Ensures the SVG fits within the given dimensions
                                                      color: Color(0Xff018786),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  if (assetList[index].status ==
                                                          'Open' ||
                                                      assetList[index].status ==
                                                          'Reject' ||
                                                      assetList[index].status ==
                                                          'Reassign' ||
                                                      assetList[index].status ==
                                                          'Reopen') ...[
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        // commonDialog(context,
                                                        //     AcceptDialog());
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color(0Xff008900),
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      child: Text("Accept"),
                                                    ),
                                                  ],
                                                  if (assetList[index].status ==
                                                      'Assign') ...[
                                                    ElevatedButton(
                                                      onPressed: assetList[
                                                                      index]
                                                                  .assignedToEngineer ==
                                                              ""
                                                          ? () {
                                                              BreakdownRepository()
                                                                  .getBreakDownDetailList(
                                                                      context,
                                                                      ticket_no:
                                                                          assetList[index]
                                                                              .id
                                                                              .toString());
                                                              // .then((V) {
                                                              commonDialog(
                                                                  context,
                                                                  AcceptDialog(
                                                                    ticketId: assetList[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                    companyId: assetList[
                                                                            index]
                                                                        .companyId
                                                                        .toString(),
                                                                    plantId: assetList[
                                                                            index]
                                                                        .plantId
                                                                        .toString(),
                                                                    deptId: assetList[
                                                                            index]
                                                                        .departmentId
                                                                        .toString(),
                                                                    buId: assetList[
                                                                            index]
                                                                        .buId
                                                                        .toString(),
                                                                  ));
                                                              // });
                                                            }
                                                          : () {},
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: assetList[
                                                                        index]
                                                                    .assignedToEngineer ==
                                                                employee_name
                                                            ? Color(0Xff008900)
                                                            : Colors.grey,
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      child: Text("Accept"),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    if (assetList[index]
                                                            .engineerId
                                                            .toString() ==
                                                        SharedUtil()
                                                            .getLoginId
                                                            .toString())
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          commonDialog(
                                                              context,
                                                              DenyDialog(
                                                                  ticketId: assetList[
                                                                          index]
                                                                      .id
                                                                      .toString()));
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                          foregroundColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        child: Text("Deny"),
                                                      ),
                                                  ],
                                                  if (assetList[index].status ==
                                                          'Accept' ||
                                                      assetList[index].status ==
                                                          'Pending') ...[
                                                    ElevatedButton(
                                                      onPressed: () {},
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      child: Text("Check In"),
                                                    ),
                                                  ],

                                                  if (assetList[index].status ==
                                                      'Check In') ...[
                                                    ElevatedButton(
                                                      onPressed: () {},
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      child: Text("Check Out"),
                                                    ),
                                                  ],
                                                  if (assetList[index].status ==
                                                          'Check In' ||
                                                      assetList[index].status ==
                                                          'Accept' ||
                                                      assetList[index].status ==
                                                          'Pending') ...[
                                                    const SizedBox(width: 5),
                                                    ElevatedButton(
                                                      onPressed: () {},
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color(0xFF018786),
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      child: Text("Re-Assign"),
                                                    ),
                                                  ],
                                                  if (assetList[index].status ==
                                                      'Awaiting RCA') ...[
                                                    ElevatedButton(
                                                      onPressed: () {},
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      child: Text("Update"),
                                                    ),
                                                  ],
                                                  if (assetList[index].status ==
                                                      'Approval of Mfg') ...[
                                                    ElevatedButton(
                                                      onPressed: () {},
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      child: Text("Approval"),
                                                    ),
                                                  ],
                                                  // Check if the status is 'acknowledge' or 'fixed'
                                                  if (assetList[index].status ==
                                                          'Completed' &&
                                                      employee_type !=
                                                          "Engineer") ...[
                                                    IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                'Are you sure you want to Acknowledge this ticket?',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Mulish",
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.white,
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Mulish",
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    ApiService()
                                                                        .TicketAccept(
                                                                            ticketNo: assetList[index]
                                                                                .id
                                                                                .toString(),
                                                                            status_id:
                                                                                '11',
                                                                            priority:
                                                                                '',
                                                                            assign_type:
                                                                                '',
                                                                            downtime_val:
                                                                                '',
                                                                            open_comment:
                                                                                '',
                                                                            assigned_comment:
                                                                                '',
                                                                            accept_comment:
                                                                                '',
                                                                            reject_comment:
                                                                                '',
                                                                            hold_comment:
                                                                                '',
                                                                            pending_comment:
                                                                                '',
                                                                            check_out_comment:
                                                                                '',
                                                                            completed_comment:
                                                                                '',
                                                                            reopen_comment:
                                                                                '',
                                                                            reassign_comment:
                                                                                '',
                                                                            comment:
                                                                                '',
                                                                            solution:
                                                                                '',
                                                                            breakdown_category_id:
                                                                                '',
                                                                            breakdown_subcategory_id:
                                                                                '',
                                                                            checkin_comment:
                                                                                '',
                                                                            planned_Date:
                                                                                "")
                                                                        .then(
                                                                            (value) {
                                                                      if (value
                                                                              .isError ==
                                                                          false) {
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                      showMessage(
                                                                        context:
                                                                            context,
                                                                        isError:
                                                                            value.isError!,
                                                                        responseMessage:
                                                                            value.message!,
                                                                      );
                                                                    });
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        const Color
                                                                            .fromRGBO(
                                                                            21,
                                                                            147,
                                                                            159,
                                                                            1),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    'Submit',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Mulish",
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      icon: const Icon(Icons
                                                          .thumb_up_alt_outlined),
                                                      color: Colors.black,
                                                      iconSize: 24,
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            TextEditingController
                                                                textFieldController =
                                                                TextEditingController();

                                                            return AlertDialog(
                                                              title: const Text(
                                                                'Reason For Re-Open...',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Mulish",
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.white,
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  TextField(
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Enter Reason',
                                                                      labelStyle: const TextStyle(
                                                                          fontFamily:
                                                                              "Mulish",
                                                                          color:
                                                                              Colors.black),
                                                                      border:
                                                                          const OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(15.0)),
                                                                      ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        borderSide:
                                                                            const BorderSide(color: Colors.black),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        borderSide:
                                                                            const BorderSide(color: Colors.black),
                                                                      ),
                                                                    ),
                                                                    style: const TextStyle(
                                                                        fontFamily:
                                                                            "Mulish",
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Mulish",
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    ApiService()
                                                                        .TicketAccept(
                                                                            ticketNo: assetList[index]
                                                                                .id
                                                                                .toString(),
                                                                            status_id:
                                                                                '12',
                                                                            priority:
                                                                                '',
                                                                            assign_type:
                                                                                '',
                                                                            downtime_val:
                                                                                '',
                                                                            open_comment:
                                                                                '',
                                                                            assigned_comment:
                                                                                '',
                                                                            accept_comment:
                                                                                '',
                                                                            reject_comment:
                                                                                '',
                                                                            hold_comment:
                                                                                '',
                                                                            pending_comment:
                                                                                '',
                                                                            check_out_comment:
                                                                                '',
                                                                            completed_comment:
                                                                                '',
                                                                            reopen_comment: textFieldController
                                                                                .text,
                                                                            reassign_comment:
                                                                                '',
                                                                            comment:
                                                                                '',
                                                                            solution:
                                                                                '',
                                                                            breakdown_category_id:
                                                                                '',
                                                                            breakdown_subcategory_id:
                                                                                '',
                                                                            checkin_comment:
                                                                                '',
                                                                            planned_Date:
                                                                                "")
                                                                        .then(
                                                                            (value) {
                                                                      if (value
                                                                              .isError ==
                                                                          false) {
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                      showMessage(
                                                                        context:
                                                                            context,
                                                                        isError:
                                                                            value.isError!,
                                                                        responseMessage:
                                                                            value.message!,
                                                                      );
                                                                    });
                                                                  },
                                                                  // data
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        const Color
                                                                            .fromRGBO(
                                                                            21,
                                                                            147,
                                                                            159,
                                                                            1),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    'Re-Open',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Mulish",
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      icon: const Icon(Icons
                                                          .thumb_down_off_alt_sharp),
                                                      color: Colors.black,
                                                      iconSize: 24,
                                                    ),
                                                  ],
                                                  IconButton(
                                                    onPressed: () {
                                                      BreakdownRepository()
                                                          .getBreakDownDetailList(
                                                              context,
                                                              ticket_no: assetList[
                                                                      index]
                                                                  .id
                                                                  .toString());
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          // logger.w(
                                                          //     assetList[index]
                                                          //         .toJson());

                                                          return AlertDialog(
                                                            title: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                  'Remarks',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Mulish",
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                                if (assetList[
                                                                            index]
                                                                        .status ==
                                                                    'Fixed')
                                                                  InkWell(
                                                                      onTap: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                      child: Icon(
                                                                          Icons
                                                                              .close)),
                                                              ],
                                                            ),
                                                            backgroundColor:
                                                                Colors.white,
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                // breakDown
                                                                //         .isLoading
                                                                //     ? Loader()
                                                                //     : breakDown
                                                                //             .ticketDetailData!
                                                                //             .breakdownDetailList!
                                                                //             .isEmpty
                                                                //         ? const Center(
                                                                //             child:
                                                                //                 Text("No data available"))
                                                                //         :
                                                                TextField(
                                                                  controller:
                                                                      textFieldController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Enter Reason',
                                                                    labelStyle: TextStyle(
                                                                        fontFamily:
                                                                            "Mulish",
                                                                        color: Colors
                                                                            .black),
                                                                    border:
                                                                        const OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(15.0)),
                                                                    ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                              color: Colors.black),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                              color: Colors.black),
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Mulish",
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ],
                                                            ),
                                                            actions: assetList[
                                                                            index]
                                                                        .status ==
                                                                    'Fixed'
                                                                ? []
                                                                : [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Cancel',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Mulish",
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        ApiService()
                                                                            .TicketAccept(
                                                                                ticketNo: assetList[index].id.toString(),
                                                                                status_id: assetList[index].status == 'Open'
                                                                                    ? '1'
                                                                                    : assetList[index].status == 'Assign'
                                                                                        ? '2'
                                                                                        : assetList[index].status == 'Accept'
                                                                                            ? '3'
                                                                                            : assetList[index].status == 'Check In'
                                                                                                ? "6"
                                                                                                : assetList[index].status == 'On Hold'
                                                                                                    ? '8'
                                                                                                    : assetList[index].status == 'Pending'
                                                                                                        ? '9'
                                                                                                        : assetList[index].status == 'Completed'
                                                                                                            ? '10'
                                                                                                            : assetList[index].status == 'Fixed'
                                                                                                                ? assetList[index].completedComment.toString()
                                                                                                                : assetList[index].status == 'Reject'
                                                                                                                    ? '4'
                                                                                                                    : assetList[index].status == 'Reopen'
                                                                                                                        ? '12'
                                                                                                                        : assetList[index].status == 'Reassign'
                                                                                                                            ? '5'
                                                                                                                            : '',
                                                                                priority: '',
                                                                                assign_type: '',
                                                                                downtime_val: '',
                                                                                open_comment: textFieldController.text,
                                                                                assigned_comment: textFieldController.text,
                                                                                accept_comment: textFieldController.text,
                                                                                reject_comment: textFieldController.text,
                                                                                hold_comment: textFieldController.text,
                                                                                pending_comment: textFieldController.text,
                                                                                check_out_comment: "",
                                                                                completed_comment: textFieldController.text,
                                                                                reopen_comment: textFieldController.text,
                                                                                reassign_comment: textFieldController.text,
                                                                                comment: textFieldController.text,
                                                                                solution: '',
                                                                                breakdown_category_id: '',
                                                                                breakdown_subcategory_id: '',
                                                                                checkin_comment: textFieldController.text,
                                                                                planned_Date: ""
                                                                                // open_comment: assetList[index].status == 'Open'
                                                                                //     ? textFieldController.text
                                                                                //     : "",
                                                                                // assigned_comment: assetList[index].status == 'Assign'
                                                                                //     ? textFieldController.text
                                                                                //     : "",
                                                                                // accept_comment: assetList[index].status == 'Accept'
                                                                                //     ? textFieldController.text
                                                                                //     : "",
                                                                                // reject_comment: assetList[index].status == 'Reject'
                                                                                //     ? textFieldController.text
                                                                                //     : "",
                                                                                // hold_comment: assetList[index].status == 'On Hold'
                                                                                //     ? textFieldController.text
                                                                                //     : "",
                                                                                // pending_comment: assetList[index].status == 'Pending'
                                                                                //     ? textFieldController.text
                                                                                //     : "",
                                                                                // check_out_comment:
                                                                                //     "",
                                                                                // completed_comment: assetList[index].status == 'Completed'
                                                                                //     ? textFieldController.text
                                                                                //     : "",
                                                                                // reopen_comment: assetList[index].status == 'Reopen'
                                                                                //     ? textFieldController.text
                                                                                //     : "",
                                                                                // reassign_comment: assetList[index].status == 'Reassign'
                                                                                //     ? textFieldController.text
                                                                                //     : "",
                                                                                // comment:
                                                                                //     textFieldController.text,
                                                                                // solution:
                                                                                //     '',
                                                                                // breakdown_category_id:
                                                                                //     '',
                                                                                // breakdown_subcategory_id:
                                                                                //     '',
                                                                                // checkin_comment: assetList[index].status == 'Check In'
                                                                                //     ? textFieldController.text
                                                                                //     : '',
                                                                                )
                                                                            .then((value) {
                                                                          if (value.isError ==
                                                                              false) {
                                                                            _fetchTicketCounts();

                                                                            Navigator.pop(context);
                                                                          }
                                                                          showMessage(
                                                                            context:
                                                                                context,
                                                                            isError:
                                                                                value.isError!,
                                                                            responseMessage:
                                                                                value.message!,
                                                                          );
                                                                        });
                                                                      },
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor: const Color
                                                                            .fromRGBO(
                                                                            21,
                                                                            147,
                                                                            159,
                                                                            1),
                                                                      ),
                                                                      child:
                                                                          const Text(
                                                                        'Submit',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Mulish",
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ],
                                                          );
                                                        },
                                                      );
                                                      setState(() {});
                                                    },
                                                    icon: const Icon(
                                                        Icons.chat_outlined),
                                                    color: Colors.black,
                                                    iconSize: 24,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                                // );
                              },
                            ),
                          ),
                        ),
              // }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.light(
              primary: const Color.fromRGBO(
                  21, 147, 159, 1), // Header background color
              onPrimary: Colors.white, // Header text and selected text color
              onSurface: Colors.black, // Default text color
            ),
            textTheme: TextTheme(
              titleMedium: TextStyle(
                fontFamily: "Mulish",
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != (isFromDate ? fromDate : toDate)) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
      _fetchTicketCounts();
    }
  }

  void handleRowTap(String rowType) {
    // Handle the row tap based on rowType
    print('Tapped on $rowType');
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomSheetSetState) {
            return Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Sort By',
                              style: TextStyle(
                                  fontFamily: "Mulish",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Color.fromRGBO(21, 147, 159, 1)),
                            ),
                            const Spacer(),
                            DropdownButton<String>(
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                bottomSheetSetState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: [
                                'Ascending',
                                'Descending'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        _buildSortOption('Date and Time',
                            Icons.calendar_month_outlined, bottomSheetSetState),
                        const SizedBox(height: 10),
                        _buildSortOption('Ticket Number', Icons.airplane_ticket,
                            bottomSheetSetState),
                        const SizedBox(height: 10),
                        _buildSortOption('Status',
                            Icons.filter_tilt_shift_sharp, bottomSheetSetState),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            print(dropdownValue);
                            print(selectedSortOption);
                            _sortAssetList(bottomSheetSetState);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(21, 147, 159, 1),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontFamily: "Mulish",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortOption(
      String label, IconData icon, StateSetter bottomSheetSetState) {
    return GestureDetector(
      onTap: () {
        selectedSortOption = label;
        bottomSheetSetState(() {});
        setState(() {}); // Trigger a rebuild of the parent widget if needed
      },
      child: Row(
        children: [
          Icon(
            icon,
            color: selectedSortOption == label
                ? const Color(0xFF018786)
                : Colors.black,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontFamily: "Mulish",
              color: selectedSortOption == label
                  ? const Color(0xFF018786)
                  : Colors.black,
              fontWeight: selectedSortOption == label
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _sortAssetList(StateSetter bottomSheetSetState) {
    setState(() {
      // Sort the assetList in place based on selectedSortOption and dropdownValue
      if (selectedSortOption == 'Ticket Number') {
        assetList.sort((a, b) {
          int comparison = a.ticketNo!.compareTo(b.ticketNo!);
          return dropdownValue == 'Ascending' ? comparison : -comparison;
        });
      } else if (selectedSortOption == 'Date and Time') {
        assetList.sort((a, b) {
          DateTime dateA = DateTime.parse(a.createdOn!);
          DateTime dateB = DateTime.parse(b.createdOn!);
          int comparison = dateA.compareTo(dateB);
          return dropdownValue == 'Ascending' ? comparison : -comparison;
        });
      } else if (selectedSortOption == 'Status') {
        assetList.sort((a, b) {
          int comparison = a.status!.compareTo(b.status!);
          return dropdownValue == 'Ascending' ? comparison : -comparison;
        });
      }
      bottomSheetSetState(() {});
    });
  }

  void showCreateTicketModal(BuildContext context) {
    // String selectedText = '';
    String selectedAssetId = '';
    String selectedAssetGroupId = '';
    String selectedMainCategoryId = '';
    String selectedSubCategoryId = '';
    TextEditingController textController = TextEditingController();
    TextEditingController textCategoryController = TextEditingController();
    TextEditingController textSubCategoryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Consumer<TicketProvider>(
          builder: (context, ticket, _) {
            return Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(10.0), // Adjust padding inside content
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
                              selectedAssetGroupId =
                                  result.assetGroupId.toString();
                              textCategoryController.clear();
                              textSubCategoryController.clear();
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
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
                                matchingAsset = ticketProvider.listEquipmentData
                                    ?.firstWhere(
                                  (asset) =>
                                      asset["asset_code"] == scannedValue,
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
                              'Breakdown Category',
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
                        onTap: textController.text.isEmpty
                            ? () {
                                return showToast("Kindly select Equipment Id",
                                    isError: true);
                                // showMessage(
                                //     context: context,
                                //     isError: true,
                                //     responseMessage: "Kindly select Equipment Id");
                              }
                            : () async {
                                // Show the CustomSearchDialog and get the selected asset
                                final MainBreakdownCategoryLists? result =
                                    await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MainCategoryDialog();
                                  },
                                );
                                if (result != null) {
                                  setState(() {
                                    textCategoryController.text =
                                        result.breakdownCategoryName.toString();
                                    selectedMainCategoryId =
                                        result.breakdownCategoryId.toString();
                                    textSubCategoryController.clear();
                                  });
                                  // SharedPreferences prefs =
                                  //     await SharedPreferences.getInstance();
                                  // await prefs.setString('breakdown_category_id',
                                  //     result.breakdownCategoryId.toString());
                                  BreakdownRepository().getListOfBreadownSub1(
                                      context,
                                      breakdownCategoryId:
                                          selectedMainCategoryId,
                                      assetGroupid: selectedAssetGroupId);
                                }
                              },
                        decoration: const InputDecoration(
                          labelText: 'Select Breakdown Category',
                          labelStyle: TextStyle(
                            fontFamily: "Mulish",
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Breakdown',
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
                                return showToast(
                                    "Kindly select Breakdown Category",
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
                                    selectedSubCategoryId = result
                                        .breakdownSubCategoryId
                                        .toString();
                                  });
                                  print(
                                      'Breakdown SubCategory ID: ${result.breakdownCategoryId}');
                                }
                              },
                        decoration: const InputDecoration(
                          labelText: 'Select Breakdown',
                          labelStyle: TextStyle(
                            fontFamily: "Mulish",
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
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
                            selectedStatus =
                                status; // Update the selected priority
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
                                  onTab: textController.text.isEmpty
                                      ? () {
                                          return showToast(
                                              "Kindly select Equipment Id",
                                              isError: true);
                                          // showMessage(
                                          //     context: context,
                                          //     isError: true,
                                          //     responseMessage: "Kindly select Equipment Id");
                                        }
                                      : () {
                                          if (selectedAssetGroupId.isNotEmpty ||
                                              selectedAssetId.isNotEmpty ||
                                              selectedMainCategoryId
                                                  .isNotEmpty ||
                                              selectedSubCategoryId
                                                  .isNotEmpty ||
                                              selectedStatus.isNotEmpty ||
                                              selectedPriority.isNotEmpty) {
                                            TicketRepository()
                                                .saveTicket(context,
                                                    assetGroupId:
                                                        selectedAssetGroupId,
                                                    assetId: selectedAssetId,
                                                    breakdownCategoryId:
                                                        selectedMainCategoryId,
                                                    breakdownSubCategoryId:
                                                        selectedSubCategoryId,
                                                    assetStatus: selectedStatus,
                                                    priorityId:
                                                        selectedPriority,
                                                    userLoginId: '',
                                                    comment: '')
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
      },
    );
  }
}
