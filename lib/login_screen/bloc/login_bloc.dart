import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/login_screen/event/login_btn_click_event.dart';
import 'package:auscurator/login_screen/state/login_api_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginButtonClickEvent, LoginApiState> {
  ApiService apiService = ApiService();
  LoginBloc() : super(LoginInitialState()) {
    on<OnLoginButtonClicked>((event, emit) async {
      try {
        emit(LoginLoadingState());
        final response = await apiService.getLoginDetail(
            event.userName, event.userPassword, event.userToken);
   
        if (response.isError!) {
          emit(LoginLoadedState(
              isError: response.isError!,
              message: response.message!,
              loginModel: response));
        }

        if (response.isError == false) {
          emit(LoginLoadedState(
              isError: response.isError!,
              message: response.message!,
              loginModel: response));
        }
      } catch (e) {
        emit(LoginErrorState(isError: true, message: e.toString()));
      }
    });
  }
}
