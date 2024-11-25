import 'package:delivary/presentation/admin/ads_maneger/screens/ads_screen.dart';
import 'package:delivary/presentation/admin/setting/srceen/setting_screen.dart';
import 'package:delivary/presentation/admin/user_maneger/screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{
  List<Widget> adminScreens=[AdsScreen(),UsersScreen(),SettingScreen()];
}