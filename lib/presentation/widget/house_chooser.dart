import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../misc/page_restoration_helper.dart';

class HouseChooser extends StatelessWidget {
  final Map<String, dynamic>? selectedHouseJsonMap;

  const HouseChooser({
    Key? key,
    this.selectedHouseJsonMap
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    String effectiveHintText = "(${"Pilih rumah".tr})";
    double radius = 16.0;
    return Material(
      borderRadius: BorderRadius.circular(radius),
      color: const Color(0xffF1F5F9),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: () async {
                PageRestorationHelper.toSelectHousePage(context, selectedHouseJsonMap != null ? json.encode(selectedHouseJsonMap!) : null);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  selectedHouseJsonMap != null ? selectedHouseJsonMap!["typeName"] : effectiveHintText, style: const TextStyle(
                    color: Color(0xff1E293B),
                  )
                ),
              ),
            )
          ),
        ]
      )
    );
  }
}