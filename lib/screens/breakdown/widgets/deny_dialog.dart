import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/api_service_myconcept/api_helper.dart';
import 'package:auscurator/bottom_navigation/bottomnavscreen.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:auscurator/model/TicketDetailModel.dart';
import 'package:auscurator/provider/breakkdown_provider.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/widgets/buttons.dart';
import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:auscurator/widgets/text_field.dart';
import 'package:auscurator/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DenyDialog extends StatefulWidget {
  const DenyDialog({super.key, required this.ticketId});
  final String ticketId;

  @override
  State<DenyDialog> createState() => _DenyDialogState();
}

class _DenyDialogState extends State<DenyDialog> {
  TextEditingController reasonController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final engineerId = SharedUtil().getLoginId;
    return Consumer<BreakkdownProvider>(
      builder: (context, ticketDetails, child) {
        return Column(
          children: [
            TextCustom(
              "Reason",
              size: 16,
              fontWeight: FontWeight.bold,
              color: Palette.dark,
            ),
            HeightFull(),
            TextFormFieldCustom(
                controller: reasonController, hint: "Enter Reason"),
            HeightFull(),
            DoubleButton(
                primaryLabel: "Save",
                secondarylabel: "Cancel",
                primaryOnTap: () {
                  if (reasonController.text.isEmpty) {
                    return showToast("Kindly enter reason", isError: true);
                  }
                  ApiService()
                      .AssignEngineer(
                    ticketNo: widget.ticketId.toString(),
                    status_id: '4',
                    priority: "",
                    engineer_id: engineerId.toString(),
                    assign_type: '',
                    downtime_val: '',
                    open_comment: '',
                    assigned_comment: '',
                    accept_comment: '',
                    reject_comment: reasonController.text,
                    hold_comment: '',
                    pending_comment: '',
                    check_out_comment: '',
                    completed_comment: '',
                    reopen_comment: '',
                    reassign_comment: '',
                    comment: reasonController.text,
                  )
                      .then((v) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (ctx) => const BottomNavScreen(),
                      ),
                      (route) => false,
                    );
                  });
                },
                secondaryOnTap: () => Navigator.pop(context)),
          ],
        );
      },
    );
  }
}
