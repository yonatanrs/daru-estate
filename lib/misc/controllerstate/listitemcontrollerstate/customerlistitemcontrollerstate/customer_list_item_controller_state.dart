import '../../../../domain/entity/customer/customer.dart';
import '../list_item_controller_state.dart';

abstract class CustomerListItemControllerState extends ListItemControllerState {
  Customer customer;
  void Function(Customer)? onClickCustomer;

  CustomerListItemControllerState({
    required this.customer,
    this.onClickCustomer
  });
}