import 'package:daru_estate/misc/ext/number_ext.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../domain/entity/mybill/bill.dart';
import '../../misc/date_util.dart';

class BillItem extends StatelessWidget {
  final Bill bill;
  final void Function(Bill)? onClickBill;

  const BillItem({
    super.key,
    required this.bill,
    required this.onClickBill
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Material(
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: onClickBill != null ? () => onClickBill!(bill) : null,
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(16.0)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateUtil.standardDateFormat4.format(bill.schemeDate), style: const TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 0.5.h),
                Text(double.parse(bill.schemeNominal).toRupiah()),
              ]
            )
          )
        )
      )
    );
  }
}