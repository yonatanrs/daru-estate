import '../../domain/entity/house/house.dart';

class SelectHouseInputControllerState {
  String? lastSelectedHouseId;
  House? selectedHouse;

  SelectHouseInputControllerState({
    required this.lastSelectedHouseId,
    required this.selectedHouse
  });

  SelectHouseInputControllerState copy({
    String? lastSelectedHouseId,
    House? selectedHouse,
    bool checkNullOfSelectedHouse = false
  }) {
    return SelectHouseInputControllerState(
      lastSelectedHouseId: checkNullOfSelectedHouse ? (lastSelectedHouseId ?? this.lastSelectedHouseId) : this.lastSelectedHouseId,
      selectedHouse: checkNullOfSelectedHouse ? (selectedHouse ?? this.selectedHouse) : this.selectedHouse
    );
  }
}