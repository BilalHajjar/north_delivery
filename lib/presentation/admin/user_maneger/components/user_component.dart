import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/admin/user_maneger/controller/users_controller.dart';
import 'package:delivary/presentation/admin/user_maneger/model/users_model.dart';
import 'package:delivary/presentation/admin/user_maneger/screens/add_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class UserComponent extends StatelessWidget {
  const UserComponent({
    super.key,
    required this.controller,required this.userModel
  });

  final UserController controller;
final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 3),
                color: AppColors.blackColor.withOpacity(0.25),
                blurRadius: 5)
          ]),
      child: ListTile(
        onTap: (){Get.to(AddUserScreen(userModel: userModel,));},
        leading: Icon(
          userModel.role == 'admin'
              ? FontAwesomeIcons.crown
              : userModel.role == 'user'
              ? FontAwesomeIcons.userAlt
              : Icons.assured_workload_sharp,
          color: AppColors.secondColor,
        ),
        subtitle: Text(userModel.email!),
        title: Text(userModel.name!),
        trailing: Icon(
          FontAwesomeIcons.whatsapp,
          color: Colors.green,
        ),
      ),
    );
  }
}