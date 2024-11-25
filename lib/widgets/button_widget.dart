import 'package:delivary/core/colors.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
   ButtonWidget({super.key,required this.text,required this.onTap});
final String text;
 var onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color:AppColors.primaColor
        ),
        child: Center(child: Text('$text',style: TextStyle(color: AppColors.whiteColor),)),
      ),
    );
  }
}
