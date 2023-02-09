import 'package:flutter/material.dart';

class ModifiedLoadingIndicator extends StatelessWidget {
  final Widget? customIndicator;

  const ModifiedLoadingIndicator({
    Key? key,
    this.customIndicator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return customIndicator ?? const CircularProgressIndicator();
  }
}