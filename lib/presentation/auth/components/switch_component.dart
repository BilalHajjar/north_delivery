import 'package:delivary/core/colors.dart';
import 'package:flutter/material.dart';

import '../screens/login_screens.dart';

class SwitchComponent extends StatefulWidget {
  SwitchComponent({super.key, });



  @override
  State<SwitchComponent> createState() => _SwitchComponentState();
}

class _SwitchComponentState extends State<SwitchComponent> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(activeColor: AppColors.primaColor,
        value: rememberMe,
        onChanged: (v) {
          rememberMe=v!;
          setState(() {});
        });
  }
}
