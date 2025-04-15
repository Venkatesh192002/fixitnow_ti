import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/model/TicketDetailModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auscurator/machine_iot/screens/AssignMultipleTechnician.dart';
import 'package:auscurator/machine_iot/screens/AssignTechnician.dart';
import 'package:auscurator/machine_iot/widget/ticket_info_cart_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketDetailsScreen extends ConsumerStatefulWidget {
  final String ticketNumber;
  final String? companyId, buId, plantId, deptId;

  const TicketDetailsScreen({
    super.key,
    required this.ticketNumber,
    this.companyId,
    this.buId,
    this.plantId,
    this.deptId,
  });

  @override
  ConsumerState createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends ConsumerState<TicketDetailsScreen> {
  String? is_multiple;
  @override
  void initState() {
    super.initState();
    checkConnection(context); // Assuming this checks for internet connection
    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      is_multiple = prefs.getString('is_multiple') ?? "";
    });
    print('is_multiple-> $is_multiple');
  }

  @override
  Widget build(BuildContext context) {
    final ticketFuture = ref.watch(apiServiceProvider).getBreakDownDetailList(
          ticket_no: widget.ticketNumber,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details',
            style: TextStyle(fontFamily: "Mulish", color: Colors.white)),
        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<TicketDetailModel>(
        future: ticketFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.all(10),
              child: ShimmerLists(
                count: 3,
                width: double.infinity,
                height: 200,
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final ticketDetails = snapshot.data;

            if (ticketDetails == null ||
                ticketDetails.breakdownDetailList == null ||
                ticketDetails.breakdownDetailList!.isEmpty) {
              return Center(
                child: NoDataScreen(),
              );
            }

            // Accessing the first item of breakdownDetailList safely
            final breakdownDetail = ticketDetails.breakdownDetailList![0];

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Assign Technician Button
                  Column(children: [
                    ElevatedButton(
                      onPressed: () {
                        if (ticketDetails.breakdownDetailList!.isNotEmpty) {
                          // Navigate to the AssignTechnician screen and pass the first ticket detail
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AssignTechnician(
                                buId: widget.buId,
                                companyId: widget.companyId,
                                deptId: widget.deptId,
                                plantId: widget.plantId,
                                ticketDetails:
                                    ticketDetails.breakdownDetailList![
                                        0], // Passing the first ticket detail
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(21, 147, 159, 1),
                      ),
                      child: const Text('Assign Technician',
                          style: TextStyle(
                              fontFamily: "Mulish", color: Colors.white)),
                    ),
                    const SizedBox(height: 16),
                    // Assign Multiple Technicians Button
                    if (is_multiple == 'yes')
                      ElevatedButton(
                        onPressed: () {
                          if (ticketDetails.breakdownDetailList!.isNotEmpty) {
                            // Navigate to the AssignTechnician screen and pass the first ticket detail
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AssignMultipleTechnician(
                                  buId: widget.buId,
                                  companyId: widget.companyId,
                                  deptId: widget.deptId,
                                  plantId: widget.plantId,
                                  ticketDetails:
                                      ticketDetails.breakdownDetailList![
                                          0], // Passing the first ticket detail
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(21, 147, 159, 1),
                        ),
                        child: const Text('Assign Multiple Technician',
                            style: TextStyle(
                                fontFamily: "Mulish", color: Colors.white)),
                      ),
                  ]),
                  const SizedBox(height: 12.0),
                  Column(
                    children: [
                      Card(
                        child: IconButton(
                          onPressed: () {
                            // final LoginId = SharedUtil().getLoginId;

                            // WorkLogRepository().getWorkLogList(context, {
                            //   "user_login_id": LoginId,
                            //   "ticket_id": widget.ticketNumber
                            // }).then((value) {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => WorkLogScreen(
                            //           ticketNo: widget.ticketNumber,
                            //           status: breakdownDetail.status ?? ""),
                            //     ));
                            // });
                          },
                          icon: const Icon(Icons.description_sharp),
                          color: Color.fromRGBO(30, 152, 165, 1),
                        ),
                      ),
                      const Text('Work Log')
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Ticket details',
                          style: TextStyle(
                              fontFamily: "Mulish",
                              color: Color.fromRGBO(21, 147, 159, 1),
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  const SizedBox(height: 10.0),
                  Card(
                    color: Colors.white,
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(children: [
                        TicketInfoCardWidget(
                          title: 'Category',
                          value: breakdownDetail.breakdownCategory ??
                              'N/A', // Accessing safely
                        ),
                        const SizedBox(height: 5.0),
                        TicketInfoCardWidget(
                          title: 'Issue',
                          value: breakdownDetail.breakdownSubCategory ??
                              'N/A', // Accessing safely
                        ),
                        const SizedBox(height: 5.0),
                        TicketInfoCardWidget(
                          title: 'Ticket Number',
                          value: breakdownDetail.ticketNo ??
                              'N/A', // Accessing safely
                        ),
                        const SizedBox(height: 5.0),
                        TicketInfoCardWidget(
                          title: 'Raised By',
                          value: breakdownDetail.createdBy ??
                              'N/A', // Accessing safely
                        ),
                        const SizedBox(height: 5.0),
                        TicketInfoCardWidget(
                          title: 'Raised Date',
                          value: breakdownDetail.createdOn != null
                              ? DateFormat('yyyy-MM-dd HH:mm').format(
                                  DateTime.parse(
                                          breakdownDetail.createdOn.toString())
                                      .toLocal())
                              : 'N/A', // Assuming createdOn is a string
                        ),
                        const SizedBox(height: 5.0),
                        TicketInfoCardWidget(
                          title: 'Status',
                          value: breakdownDetail.status ??
                              'N/A', // Accessing safely
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Asset details',
                          style: TextStyle(
                              fontFamily: "Mulish",
                              color: Color.fromRGBO(21, 147, 159, 1),
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  const SizedBox(height: 10.0),
                  Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(children: [
                            TicketInfoCardWidget(
                              title: 'Asset Status',
                              value: breakdownDetail.machineStatus
                                  .toString(), // Accessing safely
                            ),
                            const SizedBox(height: 5.0),
                            TicketInfoCardWidget(
                              title: 'Asset Name',
                              value: breakdownDetail.asset ??
                                  'N/A', // Accessing safely
                            ),
                            const SizedBox(height: 5.0),
                            TicketInfoCardWidget(
                              title: 'Asset Group',
                              value: breakdownDetail.assetGroupName ?? 'N/A',
                            ),
                            const SizedBox(height: 5.0),
                            TicketInfoCardWidget(
                              title: 'Asset Model',
                              value: breakdownDetail.assetNo ?? 'N/A',
                            ),
                            const SizedBox(height: 5.0),
                            TicketInfoCardWidget(
                              title: 'Location',
                              value:
                                  breakdownDetail.location?.toString() ?? 'N/A',
                            ),
                            const SizedBox(height: 5.0),
                          ])))
                ],
              ),
            );
          } else {
            return Center(
              child: NoDataScreen(),
            );
          }
        },
      ),
    );
  }
}
