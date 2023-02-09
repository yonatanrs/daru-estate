import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:daru_estate/misc/ext/string_ext.dart';

import '../../misc/date_util.dart';

typedef _OnDateTimeSelected = void Function(DateTime);
typedef _OnDateTimeReset = void Function();

class DateTimeChooser extends StatefulWidget {
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? selectedDateTime;
  final String? hintText;
  // ignore: library_private_types_in_public_api
  final _OnDateTimeSelected? onDateTimeSelected;
  // ignore: library_private_types_in_public_api
  final _OnDateTimeReset? onDateTimeReset;

  const DateTimeChooser({
    Key? key,
    this.firstDate,
    this.lastDate,
    this.selectedDateTime,
    this.hintText,
    this.onDateTimeSelected,
    this.onDateTimeReset
  }): super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DateTimeChooserState createState() => _DateTimeChooserState();
}

class _DateTimeChooserState extends State<DateTimeChooser> {
  final GlobalKey _dateTimeChooseResetButtonGlobalKey = GlobalKey();
  double? _dateTimeChooseResetButtonHeight;

  @override
  Widget build(BuildContext context) {
    bool hasMonthYearReset = widget.onDateTimeReset != null;
    if (hasMonthYearReset) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Size monthYearChooseResetButtonSize = (_dateTimeChooseResetButtonGlobalKey.currentContext?.findRenderObject() as RenderBox?)?.size ?? Size.zero;
        if (_dateTimeChooseResetButtonHeight != monthYearChooseResetButtonSize.height) {
          _dateTimeChooseResetButtonHeight = monthYearChooseResetButtonSize.height;
          setState(() {});
        }
      });
    }
    String effectiveHintText = widget.hintText.isEmptyString ? "(${"Select Month Year".tr})" : widget.hintText!;
    double radius = 16.0;
    return Material(
      borderRadius: BorderRadius.circular(radius),
      color: const Color(0xffF1F5F9),
      child: Row(
        children: [
          Expanded(
            key: _dateTimeChooseResetButtonGlobalKey,
            child: InkWell(
              borderRadius: hasMonthYearReset ? BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.zero,
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.zero
              ) : BorderRadius.circular(radius),
              onTap: () async {
                DateTime? selectedDateTime = await showDatePicker(
                  context: context,
                  initialDate: widget.selectedDateTime ?? DateTime.now(),
                  firstDate: widget.firstDate ?? DateTime.utc(1030, 3, 14),
                  lastDate: widget.lastDate ?? DateTime.utc(9999, 3, 14),
                );
                if (selectedDateTime != null && widget.onDateTimeSelected != null) {
                  widget.onDateTimeSelected!(selectedDateTime);
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.selectedDateTime != null ? DateUtil.standardDateFormat4.format(widget.selectedDateTime!) : effectiveHintText, style: const TextStyle(
                    color: Color(0xff1E293B),
                  )
                ),
              ),
            )
          ),
          if (hasMonthYearReset)
            SizedBox(
              width: 10.w,
              height: _dateTimeChooseResetButtonHeight,
              child: InkWell(
                borderRadius: hasMonthYearReset ? BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(radius),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.circular(radius)
                ) : BorderRadius.circular(radius),
                onTap: widget.onDateTimeReset,
                child: const Center(
                  child: Text("X")
                ),
              )
            )
        ]
      )
    );
  }
}