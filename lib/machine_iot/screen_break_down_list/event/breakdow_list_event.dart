class BreakDownListEvent {}

class BreakDownListApiCallEvent extends BreakDownListEvent {
  String selectedStatusId;
  BreakDownListApiCallEvent({required this.selectedStatusId});
}

class SearchBreakDownList extends BreakDownListEvent {
  String queryText;
  SearchBreakDownList({required this.queryText});
}

class OnSortingOptionSelected extends BreakDownListEvent {
  bool isAescenting;
  String selectedStatus;
  OnSortingOptionSelected({
    required this.isAescenting,
    required this.selectedStatus,
  });
}
