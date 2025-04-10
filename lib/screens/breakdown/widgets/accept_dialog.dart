import 'package:auscurator/machine_iot/screens/AssignMultipleTechnician.dart';
import 'package:auscurator/model/TicketDetailModel.dart';
import 'package:auscurator/provider/breakkdown_provider.dart';
import 'package:auscurator/screens/breakdown/widgets/checkin_checkout_dialog.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/widgets/buttons.dart';
import 'package:auscurator/widgets/dialogs.dart';
import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:auscurator/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AcceptDialog extends StatefulWidget {
  const AcceptDialog({
    super.key,
    required this.ticketId,
    this.companyId,
    this.buId,
    this.plantId,
    this.deptId,
  });

  final String ticketId;
  final String? companyId, buId, plantId, deptId;

  @override
  State<AcceptDialog> createState() => _AcceptDialogState();
}

class _AcceptDialogState extends State<AcceptDialog> {
  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((t) {
  //   });
  //   super.initState();
  // }
  final loginId = SharedUtil().getLoginId;

  @override
  Widget build(BuildContext context) {
    return Consumer<BreakkdownProvider>(
      builder: (context, ticketDetails, child) {
        BreakdownDetailList ticketDetail =
            ticketDetails.ticketDetailData?.breakdownDetailList?[0] ??
                BreakdownDetailList();
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 24),
                TextCustom(
                  "Assign Engineer",
                  size: 16,
                  fontWeight: FontWeight.bold,
                  color: Palette.dark,
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: Palette.dark,
                  ),
                )
              ],
            ),
            HeightFull(),
            TextCustom(
              "Select the Assign Type ?",
              fontWeight: FontWeight.w500,
            ),
            HeightFull(),
            DoubleButton(
                primaryLabel: "Single",
                secondarylabel: "Multiple",
                primaryOnTap: () {
                  // ApiService()
                  //     .AssignEngineer(
                  //         ticketNo: ticketDetail.id.toString(),
                  //         status_id: '2',
                  //         priority: "",
                  //         engineer_id: loginId.toString(),
                  //         assign_type: 'Single',
                  //         downtime_val: '',
                  //         open_comment: '',
                  //         assigned_comment: '',
                  //         accept_comment: '',
                  //         reject_comment: '',
                  //         hold_comment: '',
                  //         pending_comment: '',
                  //         check_out_comment: '',
                  //         completed_comment: '',
                  //         reopen_comment: '',
                  //         reassign_comment: '',
                  //         comment: '')
                  //     .then((value) {
                  //   showMessage(
                  //       context: context,
                  //       isError: value.isError!,
                  //       responseMessage: value.message!);
                  // });
                  commonDialog(context, CheckInAndCheckoutDialog());
                },
                secondaryOnTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssignMultipleTechnician(
                          buId: widget.buId,
                          companyId: widget.companyId,
                          deptId: widget.deptId,
                          plantId: widget.plantId,
                          ticketDetails:
                              ticketDetail, // Passing the first ticket detail
                        ),
                      ));
                })
          ],
        );
      },
    );
  }
}

