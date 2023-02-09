import 'package:flutter/material.dart';

import '../list_item_controller_state.dart';

class ProfileMenuListItemControllerState extends ListItemControllerState {
  void Function(BuildContext)? onTap;
  WidgetBuilder icon;
  String title;
  Color? color;

  ProfileMenuListItemControllerState({
    required this.onTap,
    required this.icon,
    required this.title,
    this.color
  });
}