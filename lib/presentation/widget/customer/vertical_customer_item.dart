import 'package:flutter/material.dart';

import '../modified_shimmer.dart';
import 'customer_item.dart';

class VerticalCustomerItem extends CustomerItem {
  @override
  double? get itemWidth => null;

  const VerticalCustomerItem({
    super.key,
    required super.customer,
    super.onClickCustomer
  });
}

class ShimmerVerticalCustomerItem extends VerticalCustomerItem {
  const ShimmerVerticalCustomerItem({
    super.key,
    required super.customer,
    super.onClickCustomer
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ModifiedShimmer.fromColors(
        child: super.build(context)
      ),
    );
  }
}