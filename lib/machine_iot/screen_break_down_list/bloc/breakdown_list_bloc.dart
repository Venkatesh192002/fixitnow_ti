// ignore_for_file: unused_local_variable

import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/machine_iot/screen_break_down_list/event/breakdow_list_event.dart';
import 'package:auscurator/machine_iot/screen_break_down_list/state/breakdown_list_state.dart';
import 'package:auscurator/model/BreakdownTicketModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BreakDownListBloc extends Bloc<BreakDownListEvent, BreakDownListState> {
  ApiService apiService = ApiService();
  List<BreakdownDetailList> listOfBreakdown = [];
  BreakDownListBloc() : super(BreakDownListInitialState()) {
    on<BreakDownListApiCallEvent>((event, emit) async {
      emit(BreakDownListApiLoadingState());
      try {
        final result = await apiService.getBreakDownStatusList(
            breakdown_status: '',
            from_date: '',
            period: '',
            to_date: '',
            user_login_id: '');
        if (result.isError!) {
          emit(
              BreakDownListErrorState(errorMessage: result.message.toString()));
        }
        if (result.isError! == false) {
          listOfBreakdown = result.breakdownDetailList!;
          if (listOfBreakdown.isEmpty) {
            emit(BreakDownListEmptyDataState());
          }
          if (listOfBreakdown.isNotEmpty) {
            final list = listOfBreakdown.where((element) {
              //print('filter_check:- ${element.status.toString().toLowerCase()} == ${event.selectedStatusId.toLowerCase()}');
              return element.assetStatus.toString().toLowerCase() ==
                  event.selectedStatusId.toLowerCase();
            }).toList();
            emit(BreakDownListLoadedState(
                listOfBreakdown: result.breakdownDetailList!));
          }
        }
      } catch (e) {
        emit(BreakDownListErrorState(errorMessage: e.toString()));
      }
    });
    on<SearchBreakDownList>((event, emit) {
      print('query_started');
      String searchKey = event.queryText;
      if (searchKey != '') {
        final filterList = listOfBreakdown
            .where(
              (element) => element.ticketNo!.contains(searchKey),
            )
            .toList();
        emit(BreakDownListLoadedState(listOfBreakdown: filterList));
      }
      if (searchKey == '') {
        emit(BreakDownListLoadedState(listOfBreakdown: listOfBreakdown));
      }
    });
    on<OnSortingOptionSelected>((event, emit) {
      if (event.selectedStatus == 'Date and time') {
        if (event.isAescenting) {
          listOfBreakdown.sort(
            (a, b) {
              return a.createdOn!.compareTo(b.createdOn.toString());
            },
          );
        } else {
          listOfBreakdown.sort(
            (b, a) {
              return a.createdOn!.compareTo(b.createdOn.toString());
            },
          );
        }
      }
      if (event.selectedStatus == 'Ticket number') {
        if (event.isAescenting) {
          listOfBreakdown.sort(
            (a, b) {
              return a.ticketNo!.compareTo(b.ticketNo.toString());
            },
          );
        } else {
          listOfBreakdown.sort(
            (b, a) {
              return a.ticketNo!.compareTo(b.ticketNo.toString());
            },
          );
        }
      }
      if (event.selectedStatus == 'Status') {
        if (event.isAescenting) {
          listOfBreakdown.sort(
            (a, b) {
              return a.status!.compareTo(b.status.toString());
            },
          );
        } else {
          listOfBreakdown.sort(
            (b, a) {
              return a.status!.compareTo(b.status.toString());
            },
          );
        }
      }
      emit(BreakDownListLoadedState(listOfBreakdown: listOfBreakdown));
    });
  }
}
