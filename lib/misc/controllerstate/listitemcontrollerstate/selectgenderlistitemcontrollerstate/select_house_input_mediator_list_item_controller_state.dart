import '../../select_house_input_controller_state.dart';
import '../list_item_controller_state.dart';

class SelectHouseInputMediatorListItemControllerState extends ListItemControllerState {
  SelectHouseInputControllerState selectHouseInputControllerState;
  ListItemControllerState childListItemControllerState;

  SelectHouseInputMediatorListItemControllerState({
    required this.selectHouseInputControllerState,
    required this.childListItemControllerState
  });
}