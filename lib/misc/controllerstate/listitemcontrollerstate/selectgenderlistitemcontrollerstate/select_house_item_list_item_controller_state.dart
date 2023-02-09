import '../../../../domain/entity/house/house.dart';
import '../list_item_controller_state.dart';

class SelectHouseItemListItemControllerState extends ListItemControllerState {
  House house;
  String? selectedHouseId;
  void Function(House)? onHouseSelected;

  SelectHouseItemListItemControllerState({
    required this.house,
    this.selectedHouseId,
    this.onHouseSelected
  });
}