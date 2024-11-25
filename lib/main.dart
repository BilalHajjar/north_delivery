import 'package:delivary/core/cache_helper.dart';
import 'package:delivary/core/theme.dart';
import 'package:delivary/presentation/admin/ads_maneger/screens/ads_screen.dart';
import 'package:delivary/presentation/auth/screens/email_verification_screen.dart';
import 'package:delivary/presentation/auth/screens/login_screens.dart';
import 'package:delivary/presentation/auth/screens/reset_password_screen.dart';
import 'package:delivary/presentation/home/screens/home_screen.dart';
import 'package:delivary/presentation/on_boarding/screens/on_boarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'presentation/admin/setting/srceen/setting_screen.dart';
import 'presentation/admin/user_maneger/screens/users_screen.dart';

String? token;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 bool? onBoarding= await CacheHelper().getDataBool(key: 'onBoarding');
  // token= await CacheHelper().getDataString(key: 'token');
 Widget widget;
 if(onBoarding!=true) {
   widget=OnBoardingScreen();
 } else if(token==null)
   {
     int x=0;
     String y="regitser"
;     widget=LoginScreens();
      y="forget";
     widget=LoginScreens();
   }
 else{
   widget =LoginScreens();
 }
  runApp(MyApp(widget: HomeScreen(),));
}

class MyApp extends StatelessWidget {
  final Widget widget;
  const MyApp({super.key, required this.widget});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme:AppTheme.lightTheme(),
      home:widget,
    );
  }
}



