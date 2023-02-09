import '../../../domain/entity/house/house.dart';
import 'list_item_controller_state.dart';

class HouseListItemControllerState extends ListItemControllerState {
  House house;
  void Function(House)? onClickHouse;

  HouseListItemControllerState({
    required this.house,
    this.onClickHouse
  });
}