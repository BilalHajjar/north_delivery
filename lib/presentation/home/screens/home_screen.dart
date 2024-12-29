import 'package:delivary/presentation/admin/setting/controller/setting_controller.dart';
import 'package:delivary/presentation/admin/store/screens/store_screen.dart';
import 'package:delivary/presentation/admin/user_maneger/model/users_model.dart';
import 'package:delivary/presentation/home/components/custom_drawer.dart';
import 'package:delivary/presentation/home/controller/home_controller.dart';
import 'package:delivary/presentation/store_owner/products/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../admin/ads_maneger/screens/ads_screen.dart';
import '../../admin/orders/screen/order_Admin_screen.dart';
import '../../admin/setting/srceen/setting_screen.dart';
import '../../admin/user_maneger/screens/users_screen.dart';

class HomeAdminScreen extends StatelessWidget {
  HomeAdminScreen({super.key, required this.userModel});

  final UserModel userModel;
  List<Widget> adminScreens = [
    const OrderAdminScreen(),
    const StoreScreen(),
    UsersScreen(),
    AdsScreen(),
    SettingScreen()
  ];

  List<String> appBar = [
     'إدارة الطلبات',
    'إدارة المتاجر',
    'إدارة المستخدمين',
    'إدارة الإعلانات',
    'إدارة التواصل'
  ];

  SettingController controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: GetBuilder(
        init:HomeController() ,
        builder: ( logic) {
          return Text(appBar[logic.currentScreen]);
        },
      ),),
      body: GetBuilder(
        init:HomeController() ,
        builder: ( logic) {
          return adminScreens[logic.currentScreen];
        },
      ),
      endDrawer: Drawer(child: CustomAdminDrawer(userModel: userModel)),
    );
  }
}
