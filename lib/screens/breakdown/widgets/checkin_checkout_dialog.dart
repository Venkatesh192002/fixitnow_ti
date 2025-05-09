import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/bottom_navigation/bottomnavscreen.dart';
import 'package:auscurator/model/TicketDetailModel.dart';
import 'package:auscurator/provider/breakkdown_provider.dart';
import 'package:auscurator/widgets/buttons.dart';
import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:auscurator/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckInAndCheckoutDialog extends StatefulWidget {
  const CheckInAndCheckoutDialog({super.key});

  @override
  State<CheckInAndCheckoutDialog> createState() =>
      _CheckInAndCheckoutDialogState();
}

class _CheckInAndCheckoutDialogState extends State<CheckInAndCheckoutDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BreakkdownProvider>(
      builder: (context, ticketDetails, child) {
        BreakdownDetailList ticketDetail =
            ticketDetails.ticketDetailData?.breakdownDetailList?[0] ??
                BreakdownDetailList();
        return Column(
          children: [
            TextCustom(
              "Alert !",
              size: 16,
              fontWeight: FontWeight.bold,
              color: Palette.dark,
            ),
            HeightFull(),
            TextCustom(
              "Do you want to Check In this ticket?",
              fontWeight: FontWeight.w500,
              size: 16,
            ),
            HeightFull(),
            Row(
              children: [
                Expanded(
                  child: ButtonPrimary(
                    onPressed: () => ApiService()
                        .Ticketcheckin(
                            status_id: "3",
                            ticketNo: ticketDetail.id.toString())
                        .then((v) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (ctx) => const BottomNavScreen(),
                        ),
                        (route) => false,
                      );
                    }),
                    label: "Check In Later",
                    backgroundColor: Palette.red,
                  ),
                ),
                WidthFull(),
                Expanded(
                  child: ButtonPrimary(
                    onPressed: () => ApiService()
                        .Ticketcheckin(
                            status_id: "6",
                            ticketNo: ticketDetail.id.toString())
                        .then((v) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (ctx) => const BottomNavScreen(),
                        ),
                        (route) => false,
                      );
                    }),
                    label: "Check In Now",
                    backgroundColor: Palette.greenAccent,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
