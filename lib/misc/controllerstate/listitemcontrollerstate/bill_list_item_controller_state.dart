import '../../../domain/entity/mybill/bill.dart';
import 'list_item_controller_state.dart';

class BillListItemControllerState extends ListItemControllerState {
  Bill bill;
  void Function(Bill)? onClickBill;

  BillListItemControllerState({
    required this.bill,
    this.onClickBill
  });
}