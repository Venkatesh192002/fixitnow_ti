class LoginButtonClickEvent {

}

class OnLoginButtonClicked extends LoginButtonClickEvent {
  String userName;
  String userPassword;
  String userToken;
  OnLoginButtonClicked({required this.userName,required this.userPassword,required this.userToken});
}