import 'package:delivary/core/cache_helper.dart';
import 'package:delivary/core/theme.dart';
import 'package:delivary/firebase_options.dart';
import 'package:delivary/presentation/auth/screens/login_screens.dart';
import 'package:delivary/presentation/home/screens/splash_screen.dart';
import 'package:delivary/presentation/on_boarding/screens/on_boarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';


String? token;
String? role;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // استخدام الإعدادات من firebase_options.dart
  );
  bool? onBoarding = await CacheHelper().getDataBool(key: 'onBoarding');
  token= await CacheHelper().getDataString(key: 'token');
  role= await CacheHelper().getDataString(key: 'role');
  Widget widget;
  if (onBoarding != true) {
    widget = OnBoardingScreen();
  } else if (token == null) {
    widget = LoginScreens();
  } else {
    widget = SplashScreen();
  }
  runApp(MyApp(
    widget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget widget;

  const MyApp({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme(),
      home: widget,
    );
  }
}
/*
بدنا نعدل صفحة المنتجات بالمتجر اذا  دخلنا عليه
عبتختفى الصورة اذا دخلنا و طلعنا بسبب الانيميشن

*/