import 'package:auscurator/machine_iot/screen_break_down_list/bloc/breakdown_list_bloc.dart';
import 'package:auscurator/machine_iot/screen_break_down_list/event/breakdow_list_event.dart';
import 'package:auscurator/machine_iot/screen_break_down_list/widget/sorting_icon_txt_widget.dart';
import 'package:auscurator/machine_iot/screen_break_down_list/widget/sorting_status_change.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/ui/model_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    bool isAescenting = false;
    return AppBar(
      title: const Text(
        'Tickets',
        style: TextStyle(
          fontFamily: "Mulish",
          color: Colors.white,
        ),
      ),
      actions: [
        BlocProvider.value(
          value: BlocProvider.of<BreakDownListBloc>(context),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    surfaceTintColor: Colors.white,
                    backgroundColor: Colors.white,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SortingStatusChange(
                          onSortingStatusChange: (isDecenting) {
                            isAescenting = isDecenting;
                          },
                        ),
                        const Gap(10),
                        SortingIconTextWidget(
                          iconData: Icons.date_range_outlined,
                          value: 'Date and time',
                          onTab: (value) {
                            BlocProvider.of<BreakDownListBloc>(context).add(
                                OnSortingOptionSelected(
                                    isAescenting: isAescenting,
                                    selectedStatus: value));
                            Navigator.pop(context);
                          },
                        ),
                        const Gap(10),
                        SortingIconTextWidget(
                          iconData: Icons.confirmation_number_outlined,
                          value: 'Ticket number',
                          onTab: (value) {
                            BlocProvider.of<BreakDownListBloc>(context).add(
                                OnSortingOptionSelected(
                                    isAescenting: isAescenting,
                                    selectedStatus: value));
                            Navigator.pop(context);
                          },
                        ),
                        const Gap(10),
                        SortingIconTextWidget(
                          iconData: Icons.lightbulb_outlined,
                          value: 'Status',
                          onTab: (value) {
                            BlocProvider.of<BreakDownListBloc>(context).add(
                                OnSortingOptionSelected(
                                    isAescenting: isAescenting,
                                    selectedStatus: value));
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Icon(
              Icons.filter_list_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const Gap(10),
        const ModelBottomSheetWidget(),
      ],
      backgroundColor: Color.fromRGBO(30, 152, 165, 1),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}
