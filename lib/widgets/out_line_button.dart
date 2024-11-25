
import 'package:delivary/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OutLineButton extends StatelessWidget {
  const OutLineButton({
    super.key, required this.icn, required this.text, required this.func,
  });
final IconData icn;
final String text;
final Function() func;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaColor),
          borderRadius: BorderRadius.circular(18),
          // color:AppColors.primaColor
        ),
        child:  Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // مسافة بسيطة بين الأيقونة والنص
              Text(
                text,
              ),
              SizedBox(width: 10),
              FaIcon(
                icn,
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}