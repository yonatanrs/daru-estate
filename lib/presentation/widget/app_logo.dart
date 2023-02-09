import 'package:flutter/material.dart';

import '../../misc/constant.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(Constant.imageDaruEstate),
        const SizedBox(height: 10.0),
        const Text("Apps", style: TextStyle(fontWeight: FontWeight.bold))
      ]
    );
  }
}