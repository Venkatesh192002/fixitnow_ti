class SaveButtonState {

}

class SavebuttonInitialState extends SaveButtonState {

}

class SaveButtonLoadingState extends SaveButtonState {

}

class SaveButtonSuccessState extends SaveButtonState {
    String message;
    SaveButtonSuccessState({required this.message});
}

class SaveButtonErrorState extends SaveButtonState {
    String errorMessage;
    SaveButtonErrorState({required this.errorMessage});
}