import 'dart:convert';

import 'package:delivary/core/api_connect.dart';
import 'package:delivary/presentation/admin/user_maneger/model/users_model.dart';
import 'package:delivary/presentation/auth/screens/email_verification_screen.dart';
import 'package:delivary/presentation/user/home/screens/home_user_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../../../core/splash.dart';
import '../../../main.dart';
import '../../store_owner/home_store/screen/home_store_screen.dart';
import 'home_screen.dart'; // For delay

// شاشة البداية (Splash Screen)
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    // await ApiConnect().getData('check-email-verification').then((value)async {
    //   if(value.statusCode==200)
      await ApiConnect().getData('user').then((val) {
        UserModel userModel = UserModel.fromJson(jsonDecode(val.body));
        Future.delayed(Duration(seconds: 1)).then((c) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              if (role == 'admin')
                return
                  HomeAdminScreen(userModel: userModel);
              else if (role == 'user')
                return HomeUserScreen(userModel: userModel);
              else
                return HomeStoreScreen(userModel: userModel);
            }),
          );
        });
      });
    //   else{
    //     Get.offAll(EmailVerificationScreen(email: email));
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CustomPaint(
              size: Size(375, 812),
              painter: RPSCustomPainter(),
            ),
            Directionality(textDirection: TextDirection.rtl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset('assets/images/logo1.png')),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'يتم تحضير البيانات ......  ',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),CircularProgressIndicator(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
