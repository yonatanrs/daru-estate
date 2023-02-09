import 'package:flutter/material.dart';
import '../../../domain/entity/customer/customer.dart';
import 'customer_item.dart';

class HorizontalCustomerItem extends CustomerItem {
  @override
  double? get itemWidth => 150.0;

  const HorizontalCustomerItem({
    super.key,
    required super.customer,
    super.onClickCustomer
  });
}