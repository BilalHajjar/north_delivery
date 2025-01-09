import 'dart:convert';

import 'package:delivary/core/api_connect.dart';
import 'package:delivary/core/cache_helper.dart';
import 'package:delivary/presentation/admin/ads_maneger/screens/ads_screen.dart';
import 'package:delivary/presentation/admin/setting/srceen/setting_screen.dart';
import 'package:delivary/presentation/admin/user_maneger/screens/users_screen.dart';
import 'package:delivary/presentation/auth/screens/login_screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HomeController extends GetxController {
  // List<Widget> adminScreens = [AdsScreen(), UsersScreen(), SettingScreen()];
  RxBool waitUpdate = false.obs;
  RxBool waitLogout = false.obs;
  int currentScreen = 0;
  changeScreen({required int screen}){
    currentScreen=screen;
    update();

  }
  logout(context)async{
    waitLogout.value=true;
    await ApiConnect().postData('logout', {

    }).then((val){

    if(val.statusCode==200)
      {OneSignal.logout();

        Get.offAll(LoginScreens());
        CacheHelper.removeData(key: 'token');
      }else{
      appErrorMessage(context, '${jsonDecode(val.body)['message']}');
    }
    waitLogout.value=false;

    }).catchError((e){
      waitLogout.value=false;

    appErrorMessage(context, 'تحقق من اتصالك بالشبكة');
  });}
  updateProfile(
    context, {
    required String name,
    required String phoneNumber,
    required String email,
    String? currentPassword,
    String? password,
    String? passwordConfirmation,
  }) async {
    waitUpdate.value = true;
    await ApiConnect().putData('update-profile', {
      "name": "${name}",
      "email": "$email",
      "phone_number": "${phoneNumber}",
      "current_password": "$currentPassword",
      if(password!=null)
      "password": "${password}",
      if(password!=null)
      "password_confirmation": "${passwordConfirmation}",
    }).then((value) {
      if (value.statusCode == 200)
        appErrorMessage(context, 'تم التعديل بنجاح');
      else {
        appErrorMessage(context, '${jsonDecode(value.body)['message']}');
      }
      Navigator.pop(context);
      waitUpdate.value=false;
    }).catchError((e) { waitUpdate.value=false;
      appErrorMessage(context, 'تحقق من اتصالك بالانترنت');
    });
  }
}
