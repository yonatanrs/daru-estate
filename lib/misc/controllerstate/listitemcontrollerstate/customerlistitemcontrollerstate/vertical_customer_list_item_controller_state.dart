import '../../../../domain/entity/customer/customer.dart';
import 'customer_list_item_controller_state.dart';

class VerticalCustomerListItemControllerState extends CustomerListItemControllerState {
  VerticalCustomerListItemControllerState({required super.customer, super.onClickCustomer});
}

class ShimmerVerticalCustomerListItemControllerState extends VerticalCustomerListItemControllerState {
  ShimmerVerticalCustomerListItemControllerState({required super.customer});
}