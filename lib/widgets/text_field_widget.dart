import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    super.key,
    required this.txt,
    required this.preIcon,
    required this.controller,
    this.onTapSuff,
    this.obscure = false,
    this.suffIcon,
    this.validator,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String txt;
  final IconData preIcon;
  final IconData? suffIcon;
  final bool obscure;
  final Function()? onTapSuff;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscure,
      controller: controller,
      keyboardType: keyboardType,  // دعم أنواع الإدخال المختلفة
      decoration: InputDecoration(
        labelText: txt,
        prefixIcon: Icon(preIcon),
        suffixIcon: suffIcon != null
            ? IconButton(
          icon: Icon(suffIcon),
          onPressed: onTapSuff,
        )
            : null,  // إذا كان suffIcon فارغًا، لا يتم عرض أي شيء
      ),
    );
  }
}
