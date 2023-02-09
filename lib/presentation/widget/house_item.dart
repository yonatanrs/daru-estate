import 'package:daru_estate/misc/controllerstate/listitemcontrollerstate/horizontal_justified_title_and_description_list_item_controller_state.dart';
import 'package:daru_estate/misc/ext/number_ext.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../domain/entity/house/house.dart';
import 'modified_cached_network_image.dart';

class HouseItem extends StatelessWidget {
  final House house;
  final String? selectedHouseId;
  final void Function(House)? onClickHouse;

  const HouseItem({
    super.key,
    required this.house,
    required this.onClickHouse,
    this.selectedHouseId
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Material(
        borderRadius: BorderRadius.circular(16.0),
        color: selectedHouseId == house.id ? Colors.grey.shade200 : null,
        child: InkWell(
          onTap: onClickHouse != null ? () => onClickHouse!(house) : null,
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
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: ModifiedCachedNetworkImage(
                      imageUrl: house.housePic,
                    )
                  )
                ),
                SizedBox(height: 1.h),
                Text(house.typeName, style: const TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 0.5.h),
                Text(house.cashPrice.toRupiah()),
                SizedBox(height: 0.5.h),
                HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                  title: "Luas tanah",
                  description: house.landArea.toString()
                ).widgetSubstitution(context, 0),
                HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                  title: "Luas bangunan",
                  description: house.buildingArea.toString()
                ).widgetSubstitution(context, 0),
                HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                  title: "Stok",
                  description: house.stock.toString()
                ).widgetSubstitution(context, 0),
              ]
            )
          )
        )
      )
    );
  }
}