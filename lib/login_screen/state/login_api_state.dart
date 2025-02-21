import 'package:auscurator/model/login_model.dart';

class LoginApiState {}

class LoginInitialState extends LoginApiState {}

class LoginLoadingState extends LoginApiState {}

class LoginLoadedState extends LoginApiState {
  LoginModel loginModel;
  bool isError;
  String message;
  LoginLoadedState(
      {required this.isError, required this.message, required this.loginModel});
}

class LoginErrorState extends LoginApiState {
  bool isError;
  String message;
  LoginErrorState({required this.isError, required this.message});
}
