class House {
  String id;
  String typeName;
  String housePic;
  double cashPrice;
  double landArea;
  double buildingArea;
  int storeyNumber;
  int stock;
  DateTime lastStockUpdate;

  House({
    required this.id,
    required this.typeName,
    required this.housePic,
    required this.cashPrice,
    required this.landArea,
    required this.buildingArea,
    required this.storeyNumber,
    required this.stock,
    required this.lastStockUpdate
  });
}