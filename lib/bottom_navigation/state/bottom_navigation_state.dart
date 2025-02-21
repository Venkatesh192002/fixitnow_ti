class BottomNavigationState {
  int selectedItem;
  BottomNavigationState({required this.selectedItem});
}

class OnItemClickBottomNavigationState extends BottomNavigationState {
  OnItemClickBottomNavigationState({selectedItem}):super(selectedItem: selectedItem);
}