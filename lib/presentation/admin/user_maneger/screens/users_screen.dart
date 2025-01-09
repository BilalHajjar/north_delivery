import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/admin/user_maneger/controller/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../components/user_component.dart';
import 'add_user_screen.dart';

class UsersScreen extends StatelessWidget {
  UsersScreen({super.key});

  UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('المستخدمين'),
      // ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(AddUserScreen());
        },
        label: const Text('إضافة مستخدم'),
      ),
      body: Obx(() {
        if (controller.isLoading.value&&controller.currentPage==1) {
          return const Center(child: CircularProgressIndicator());
        }
        return Directionality(
          textDirection: TextDirection.rtl,
          child: RefreshIndicator(
            onRefresh: () async{
              controller.usersList=[];
              controller.currentPage=1;
              controller.fetchUsers(); },
            child: ListView.builder(
              controller: controller.scroll,
              itemCount: controller.usersList.length+1,
              itemBuilder: (BuildContext context, int index) {
                if(index<controller.usersList.length) {
                  return UserComponent(
                  controller: controller,
                  userModel: controller.usersList[index],
                );
                } else {
                  if(controller.hasMode==null)
                    return SizedBox();
                  else
                  return Center(child: CircularProgressIndicator(),);
                }
              },
            ),
          ),
        );
      }),
    );
  }
}
