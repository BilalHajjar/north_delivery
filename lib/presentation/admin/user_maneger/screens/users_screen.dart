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
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Directionality(
          textDirection: TextDirection.rtl,
          child: RefreshIndicator(
            onRefresh: () async{ controller.fetchUsers(); },
            child: ListView.builder(
              itemCount: controller.usersList.length,
              itemBuilder: (BuildContext context, int index) {
                return UserComponent(
                  controller: controller,
                  userModel: controller.usersList[index],
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
