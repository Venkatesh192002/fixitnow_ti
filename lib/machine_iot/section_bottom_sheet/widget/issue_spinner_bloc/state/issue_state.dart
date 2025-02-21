import 'package:flutter/material.dart';

class IssueSpinnerState {

}

class IssueSpinnerApiInitialState extends IssueSpinnerState {

}

class IssueSpinnerApiLoadingState extends IssueSpinnerState {

}

class IssueSpinnerApiErrorState extends IssueSpinnerState {
    String errorMessage;
    IssueSpinnerApiErrorState({required this.errorMessage});
}

class IssueSpinnerApiLoadedState extends IssueSpinnerState {
    List<DropdownMenuEntry> listOfIssue;
    IssueSpinnerApiLoadedState({required this.listOfIssue});
}

