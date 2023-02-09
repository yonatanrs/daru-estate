import 'package:daru_estate/misc/ext/string_ext.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../domain/entity/customer/customer.dart';
import '../../../misc/constant.dart';

abstract class CustomerItem extends StatelessWidget {
  final Customer customer;
  final void Function(Customer)? onClickCustomer;

  @protected
  double? get itemWidth;

  const CustomerItem({
    Key? key,
    required this.customer,
    this.onClickCustomer
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth,
      child: Material(
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: onClickCustomer != null ? () => onClickCustomer!(customer) : null,
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              border: Border.all(color: Constant.colorProductItemBorder),
              borderRadius: BorderRadius.circular(16.0)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                  message: customer.name.toStringNonNull,
                  child: Text(
                    customer.name.toStringNonNull,
                    style: Theme.of(context).textTheme.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  customer.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis
                ),
              ],
            )
          )
        )
      )
    );
  }
}