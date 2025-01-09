import 'package:flutter/material.dart';

import '../model/list_model.dart';
import 'package:delivary/presentation/admin/store/controller/add_store_controller.dart';

import '../model/store_model.dart';

class UserComboBox extends StatefulWidget {
  const UserComboBox({super.key, required this.controller, this.user});
  final AddStoreController controller;
  final User? user;

  @override
  State<UserComboBox> createState() => _UserComboBoxState();
}

class _UserComboBoxState extends State<UserComboBox> {
  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      widget.controller.userWithoutStoreList.add(widget.user!);
      for (int i = 0; i < widget.controller.userWithoutStoreList.length; i++) {
        if (widget.controller.userWithoutStoreList[i].id == widget.user!.id) {
          widget.controller.selectUserWithoutStore =
          widget.controller.userWithoutStoreList[i];
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<User>(
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          value: widget.controller.selectUserWithoutStore,
          items: widget.controller.userWithoutStoreList.map((user) {
            return DropdownMenuItem<User>(
              value: user,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      user.name![0],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    user.name!,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (User? newValue) {
            setState(() {
              widget.controller.selectUserWithoutStore = newValue;
            });
          },
          hint: Text(
            'اختر مالك',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
        ),
      ),
    );
  }
}
