import 'package:delivary/presentation/admin/setting/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../admin/ads_maneger/screens/ads_screen.dart';
import '../../admin/setting/srceen/setting_screen.dart';
import '../../admin/user_maneger/screens/users_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> adminScreens = [UsersScreen(), AdsScreen(), SettingScreen()];

  int currentScreen = 0;

SettingController controller=Get.put( SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: adminScreens[currentScreen],

      bottomNavigationBar: BottomNavigationBar(
          currentIndex:currentScreen,
          onTap: (i){
            setState(() {

              currentScreen=i;
            });
          },
          items: const [
        BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'المستخدمين'),
        BottomNavigationBarItem(icon: Icon(Icons.image), label: 'الاعلانات'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'الاعدادات')
      ]),
    );
  }
}
