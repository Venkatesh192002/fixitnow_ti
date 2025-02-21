import 'package:auscurator/machine_iot/screen_break_down_list/widget/drop_down_menu_widget.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/container_component_widget.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/elevated_button_widget.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_status_bloc/bloc/machine_status_bloc.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_status_bloc/state/machine_status_state.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/issue_spinner_bloc/bloc/issue_bloc.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/issue_spinner_bloc/event/issue_event.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/issue_spinner_bloc/state/issue_state.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/priority_bloc/bloc/priority_bloc.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/priority_bloc/event/priority_event.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/priority_bloc/state/priority_state.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/save_spinner_bloc/bloc/save_button_bloc.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/save_spinner_bloc/event/save_button_event.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/save_spinner_bloc/state/save_button_state.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/text_field_widget.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/bloc/equipment_spinner_bloc.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/state/equipment_spinner_state.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/text_widget.dart';
import 'package:auscurator/machine_iot/widget/qr_scanner_widget.dart';
import 'package:auscurator/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

enum PriorityStatus { high, medium, low }

enum MachineStatus { running, stopped }

class ModelBottomSheetWidget extends StatelessWidget {
  const ModelBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EquipmentSpinnerBloc, EquipmentSpinnerState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            Scaffold.of(context).showBottomSheet(
              backgroundColor: Colors.white,
              (context) {
                return Sizer(builder: (context, o, t) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            title: 'Create Ticket',
                            fontSize: 18.sp,
                            textAlign: Alignment.centerLeft,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const QRScannerWidget()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.qr_code,
                                color: Color.fromRGBO(30, 152, 165, 1),
                                size: 30,
                              ),
                            ),
                          )
                        ],
                      ),
                      BlocBuilder<EquipmentSpinnerBloc, EquipmentSpinnerState>(
                        builder: (context, state) {
                          if (state is EquipmentSpinnerApiLoadingState) {
                            return ContainerComponent(
                                width: 95.w, height: 8.h, value: 'Loading...');
                          }

                          if (state is EquipmentSpinnerApiErrortate) {
                            return ContainerComponent(
                                width: 95.w,
                                height: 8.h,
                                value: state.message.toString());
                          }

                          if (state is EquipmentSpinnerApiLoadedState) {
                            return DropdownMenuWidget(
                              listOfItem: state.cmmsEquipmentListModel,
                              selectedItemFun: (selectedItem) {
                                print('selected_equipment_id:- $selectedItem');
                                BlocProvider.of<IssueSpinnerBloc>(context).add(
                                    IssueSpinnerApiCallEvent(
                                        selectedEquipmentId: selectedItem));
                              },
                              enableSearch: true,
                              label: 'Select equipment',
                            );
                          }

                          return const Text('Nothing');
                        },
                      ),
                      const Gap(15),
                      ContainerComponent(
                        width: 95.w,
                        height: 7.h,
                        value: DateTime.now().toString(),
                      ),
                      const Gap(15),
                      BlocBuilder<IssueSpinnerBloc, IssueSpinnerState>(
                        builder: (context, state) {
                          if (state is IssueSpinnerApiLoadingState) {
                            return ContainerComponent(
                              width: 95.w,
                              height: 8.h,
                              value: 'Loading...',
                            );
                          }

                          if (state is IssueSpinnerApiErrorState) {
                            return ContainerComponent(
                              width: 95.w,
                              height: 8.h,
                              value: state.errorMessage,
                            );
                          }

                          if (state is IssueSpinnerApiLoadedState) {
                            return DropdownMenuWidget(
                              listOfItem: state.listOfIssue,
                              selectedItemFun: (selectedItem) {},
                              label: 'Selecte issue',
                            );
                          }

                          return ContainerComponent(
                              width: 95.w,
                              height: 8.h,
                              value: 'Issue based on equipment');
                        },
                      ),
                      const Gap(15),
                      SizedBox(
                        width: 95.w,
                        child: BlocBuilder<PriorityBloc, PriorityState>(
                          builder: (context, state) {
                            if (state is OnSelectedState) {
                              return SegmentedButton<PriorityStatus>(
                                style: buttonStyleDecration(context),
                                segments: const [
                                  ButtonSegment(
                                      value: PriorityStatus.high,
                                      label: Text('High')),
                                  ButtonSegment(
                                      value: PriorityStatus.medium,
                                      label: Text('Medium')),
                                  ButtonSegment(
                                      value: PriorityStatus.low,
                                      label: Text('Low')),
                                ],
                                selected: state.priorityStatus,
                                onSelectionChanged: (p0) {
                                  BlocProvider.of<PriorityBloc>(context).add(
                                      OnItemClickPriority(priorityStatus: p0));
                                },
                              );
                            }
                            return const Text('Nothing');
                          },
                        ),
                      ),
                      const Gap(15),
                      BlocBuilder<MachineStatusBloc, MachineStatusState>(
                        builder: (context, state) {
                          if (state is MachienStatusLoadingState) {
                            return ContainerComponent(
                                width: 95.w, height: 8.h, value: 'Loading...!');
                          }
                          if (state is MachineStatusErrorState) {
                            return ContainerComponent(
                                width: 95.w,
                                height: 8.h,
                                value: state.errorMessage);
                          }
                          if (state is MachienStatusLoadedState) {
                            return DropdownMenuWidget(
                              listOfItem: state.listOfBreakdown,
                              selectedItemFun: (selectedItem) {},
                              label: 'Select Machine Status',
                            );
                          }
                          return ContainerComponent(
                              width: 95.w, height: 8.h, value: 'Nothing');
                        },
                      ),
                      const Gap(15),
                      TextFieldWidget(
                        width: 95.w,
                        value: 'Enter description',
                        onChange: (value) {},
                        isSearch: false,
                      ),
                      const Gap(15),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          children: [
                            BlocConsumer<SaveButtonBloc, SaveButtonState>(
                              builder: (context, state) {
                                return ElevatedButtonWidget(
                                  flex: 1,
                                  label: state is SaveButtonLoadingState
                                      ? 'Loading...!'
                                      : 'Submit',
                                  onTab: () {
                                    BlocProvider.of<SaveButtonBloc>(context)
                                        .add(
                                      SaveButtonOnClickEvent(
                                          assetGroupId: '1',
                                          assetId: '1',
                                          breakdownCategoryId: '1',
                                          breakdownsubCategoryId: '',
                                          assetStatus: '1',
                                          priorityId: '1',
                                          userLoginId: '1',
                                          comment: ''),
                                    );
                                  },
                                );
                              },
                              listener: (context, state) {
                                if (state is SaveButtonErrorState) {
                                  Util.showToastMessage(
                                      10, context, state.errorMessage, true);
                                }
                                if (state is SaveButtonSuccessState) {
                                  Util.showToastMessage(
                                      10, context, state.message, false);
                                }
                              },
                            ),
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
                      ),
                    ],
                  );
                });
              },
            );
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        );
      },
    );
  }

  ButtonStyle buttonStyleDecration(BuildContext context) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Color.fromRGBO(30, 152, 165, 1);
        } else {
          return Colors.transparent;
        }
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        } else {
          return Colors.black;
        }
      }),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
