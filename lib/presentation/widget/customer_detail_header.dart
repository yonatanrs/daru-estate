import 'package:daru_estate/misc/ext/string_ext.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../domain/entity/customer/customer.dart';
import '../../misc/constant.dart';

class CustomerDetailHeader extends BaseCustomerDetailHeader {
  const CustomerDetailHeader({
    Key? key,
    required Customer customer,
  }) : super(
    key: key,
    customer: customer,
  );
}

class ShimmerCustomerDetailHeader extends BaseCustomerDetailHeader {
  const ShimmerCustomerDetailHeader({Key? key}) : super(key: key, isLoading: true);
}

abstract class BaseCustomerDetailHeader extends StatelessWidget {
  final Customer? customer;
  final bool isLoading;

  const BaseCustomerDetailHeader({
    Key? key,
    this.customer,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCustomerNotNull = customer != null;
    Color? textBackgroundColor = isLoading ? Colors.grey : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(Constant.paddingListItem),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCustomerNotNull ? customer!.name.toStringNonNull : (isLoading ? "Dummy Name" : ""),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  backgroundColor: textBackgroundColor
                )
              ),
              if (isCustomerNotNull)
                ...<Widget>[
                  SizedBox(height: 1.h),
                  Text(
                    isCustomerNotNull ? customer!.email : (isLoading ? "Dummy Email" : ""),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      backgroundColor: textBackgroundColor
                    )
                  ),
                ]
            ],
          )
        )
      ]
    );
  }
}