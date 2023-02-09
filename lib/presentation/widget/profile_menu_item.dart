import 'package:flutter/material.dart';
import 'package:daru_estate/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import 'icon_title_and_description_list_item.dart';
import 'modified_svg_picture.dart';

class ProfileMenuItem extends StatelessWidget {
  final VoidCallback? onTap;
  final WidgetBuilder icon;
  final String title;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const ProfileMenuItem({
    Key? key,
    this.onTap,
    required this.icon,
    required this.title,
    this.color,
    this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget effectiveIcon = icon(context);
    if (effectiveIcon is ModifiedSvgPicture && color != null) {
      effectiveIcon = effectiveIcon.copy(color: color);
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding ?? EdgeInsets.all(4.w),
          child: IconTitleAndDescriptionListItem(
            title: title,
            description: null,
            space: 4.w,
            verticalSpace: (0.5).h,
            titleAndDescriptionItemInterceptor: (padding, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
              return Text(title.toEmptyStringNonNull, style: TextStyle(color: color));
            },
            icon: effectiveIcon,
          )
        ),
      ),
    );
  }
}