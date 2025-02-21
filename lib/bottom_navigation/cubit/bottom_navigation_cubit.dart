import 'package:auscurator/bottom_navigation/state/bottom_navigation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationCubit extends Cubit<OnItemClickBottomNavigationState> {
  BottomNavigationCubit()
      : super(OnItemClickBottomNavigationState(selectedItem: 0));

  onBottomNavigationItemClick(int selectedItemIndex) {
    emit(OnItemClickBottomNavigationState(selectedItem: selectedItemIndex));
  }
}
