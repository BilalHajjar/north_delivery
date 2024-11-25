import 'package:delivary/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
   PasswordTextField({super.key, required this.controller,this.validator});

  final TextEditingController controller;
var validator;
  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obsc = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      validator:widget. validator,
      obscure: obsc,
      controller: widget.controller,
      txt: '*********',
      suffIcon:
      !obsc ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      onTapSuff: () {
        setState(() {
          obsc = !obsc;
        });
      },
      preIcon: Icons.password,
    );
  }
}
