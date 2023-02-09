import '../../../domain/entity/customer/customer.dart';
import 'list_item_controller_state.dart';

abstract class BaseCustomerDetailHeaderListItemControllerState extends ListItemControllerState {}

class CustomerDetailHeaderListItemControllerState extends BaseCustomerDetailHeaderListItemControllerState {
  Customer customer;

  CustomerDetailHeaderListItemControllerState({
    required this.customer,
  });
}

class ShimmerCustomerDetailHeaderListItemControllerState extends BaseCustomerDetailHeaderListItemControllerState {}