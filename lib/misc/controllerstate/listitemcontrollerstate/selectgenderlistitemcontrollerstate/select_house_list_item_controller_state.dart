import '../../../../domain/entity/house/house.dart';
import '../list_item_controller_state.dart';

class SelectHouseListItemControllerState extends ListItemControllerState {
  void Function()? onUpdateListItemControllerState;
  void Function(House)? onHouseSelected;
  List<House> houseList;

  SelectHouseListItemControllerState({
    this.onUpdateListItemControllerState,
    this.onHouseSelected,
    required this.houseList
  });
}