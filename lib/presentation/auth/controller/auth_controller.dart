import 'dart:async';
import 'dart:convert';

import 'package:delivary/core/api_connect.dart';
import 'package:delivary/core/cache_helper.dart';
import 'package:delivary/main.dart';
import 'package:delivary/presentation/auth/screens/email_verification_screen.dart';
import 'package:delivary/presentation/auth/screens/login_screens.dart';
import 'package:delivary/presentation/auth/screens/reset_password_screen.dart';
import 'package:delivary/presentation/home/screens/home_screen.dart';
import 'package:delivary/presentation/home/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthController extends GetxController {
  var secondsRemainingSendEmail = 60.obs;
  Timer? _timerSendEmail;
  var isButtonEnabledSendEmail = true.obs;
  int incrementSendEmail = 1;
  var secondsRemainingForgetPassword = 60.obs;
  Timer? _timerForgetPassword;
  var isButtonEnabledForgetPassword = true.obs;
  int incrementForgetPassword = 1;


  void startCountdownSendEmail(context,{required String email}) {


    secondsRemainingSendEmail.value = 10 * incrementSendEmail;
    sendVerificationCode(context,email: email);
    _timerSendEmail = Timer.periodic(const Duration(seconds: 1), (timer) {

      if (secondsRemainingSendEmail.value > 0) {
        secondsRemainingSendEmail.value--;
        isButtonEnabledSendEmail.value = false; // تعطيل الزر أثناء العداد
      } else {
        _timerSendEmail?.cancel();
        isButtonEnabledSendEmail.value = true; // تفعيل الزر بعد العداد
      }
    });
    incrementSendEmail++;
  }

  void startCountdownForgetPassword(context,email) {
    secondsRemainingForgetPassword.value = 10 * incrementForgetPassword;
    sendPasswordResetLink(context,email: '$email');
    _timerForgetPassword = Timer.periodic(const Duration(seconds: 1), (timer) {

      if (secondsRemainingForgetPassword.value > 0) {
        secondsRemainingForgetPassword.value--;
        isButtonEnabledForgetPassword.value = false; // تعطيل الزر أثناء العداد
      } else {
        _timerForgetPassword?.cancel();
        isButtonEnabledForgetPassword.value = true; // تفعيل الزر بعد العداد
      }
    });
    incrementForgetPassword++;
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  RxBool registerWait = false.obs;

  register(context,
      {required String name,
      required String email,
      required String password,
      required String passwordConfirmation}) async {
    registerWait.value = true;
    await ApiConnect().postData('register', {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
    }).then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {

        // CacheHelper.saveData(key: 'checkingEmail', value: jsonDecode(value.body)['token']);
        token = jsonDecode(value.body)['token'];
        role = jsonDecode(value.body)['role'];
        if (rememberMe == true) {
          CacheHelper.saveData(key: 'token', value: token);
          CacheHelper.saveData(key: 'role', value: role);
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return EmailVerificationScreen(
            email: email,
          );
        }));
      } else {
        appErrorMessage(context,
            '${jsonDecode(value.body)['message'] ?? jsonDecode(value.body)['email'][0]}');
      }
      registerWait.value = false;
    }).catchError((r) {
      registerWait.value = false;
      appErrorMessage(context, 'تحقق من اتصالك بالشبكة');
    });
  }

  RxBool loginWait = false.obs;

  // دالة تسجيل الدخول
  login(
    context, {
    required String email,
    required String password,
  }) async {
    loginWait.value = true;
    await ApiConnect().postData('login', {
      // "email": email,
      // "password": password,
      "email": email,
      "password": password
    }).then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {
        OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

        OneSignal.initialize('6f35037c-58d8-45f4-be58-a1865089f286');
        OneSignal.login('${jsonDecode(value.body)['user_id']}');
        // OneSignal.User.addAlias("email", "$email");
        OneSignal.Notifications.requestPermission(true);
        token = jsonDecode(value.body)['token'];
        role = jsonDecode(value.body)['role'];
        if (rememberMe == true) {
          CacheHelper.saveData(key: 'token', value: token);
          CacheHelper.saveData(key: 'role', value: role);
        }
        Get.offAll(SplashScreen());
        loginWait.value = false;
      } else {
        loginWait.value = false;
        appErrorMessage(context, jsonDecode(value.body)['message']);
      }
    }).catchError((r) {
      loginWait.value = false;
      appErrorMessage(context, 'تحقق من اتصالك بالشبكة');
    });
  }
  googleLogin(
    context, {
    required String email,
    required String password,
  }) async {
    loginWait.value = true;
    await ApiConnect().postData('login', {
      // "email": email,
      // "password": password,
      "email": email,
      "password": password
    }).then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {
        token = jsonDecode(value.body)['token'];
        role = jsonDecode(value.body)['role'];
        if (rememberMe == true) {
          CacheHelper.saveData(key: 'token', value: token);
          CacheHelper.saveData(key: 'role', value: role);
        }
        Get.offAll(SplashScreen());
        onSignal(email);
        loginWait.value = false;
      } else {
        loginWait.value = false;
        appErrorMessage(context, jsonDecode(value.body)['message']);
      }
    }).catchError((r) {
      loginWait.value = false;
      appErrorMessage(context, 'تحقق من اتصالك بالشبكة');
    });
  }

  // دالة إرسال رمز التحقق
  sendVerificationCode(context,{
    required String email,
  }) async {
    await ApiConnect().postData('send-verification-code', {
      "email": email,
    }).then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {
      appErrorMessage(context, 'تم اعادة طلب الكود',title: 'تم');
      } else {

            }
    });
  }

  RxBool verifyEmailWait = false.obs;

  // دالة التحقق من البريد الإلكتروني
  verifyEmail(context,{
    required String email,
    required String code,
  }) async {
    verifyEmailWait.value = true;
    await ApiConnect().postData('verify-email', {
      "email": email,
      "code": code,
    }).then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {

        Get.offAll(LoginScreens());
        appErrorMessage(context, jsonDecode(value.body)['message'],title: 'تم');
      } else {
        appErrorMessage(context, jsonDecode(value.body)['message']);
      }
      verifyEmailWait.value = false;
    }).catchError((e) {
      verifyEmailWait.value = true;
    });
  }

  RxBool sendPasswordResetLinkWait = false.obs;

  sendPasswordResetLink(
    context, {
    required String email,
  }) async {
    sendPasswordResetLinkWait.value = true;

    await ApiConnect().postData('send-password-reset-link', {
      "email": email,
    }).then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return ResetPasswordScreen(email: email,);
        }));
      } else {
        appErrorMessage(context, jsonDecode(value.body)['message']);
      }
      sendPasswordResetLinkWait.value = false;
    }).catchError((r) {
      sendPasswordResetLinkWait.value = false;

      appErrorMessage(context, 'تحقق من اتصالك بالشبكة');
    });
  }

  RxBool resetPasswordWait = false.obs;

  // دالة إعادة تعيين كلمة المرور
  resetPassword(
    context, {
    required String email,
    required String verificationCode,
    required String resetPassword,
    required String resetPasswordConfirmation,
  }) async {
    resetPasswordWait.value = true;
    await ApiConnect().postData('reset-password', {
      "email": email,
      "code": verificationCode,
      "password": resetPassword,
      "password_confirmation": resetPasswordConfirmation,
    }).then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {
        appErrorMessage(context, 'تمت إعادة تعيين كلمة المرور',title: 'تم');
        Get.offAll(LoginScreens());
      } else {
        appErrorMessage(context, jsonDecode(value.body)['message']);
      }
      resetPasswordWait.value = false;
    }).catchError((e) {
      resetPasswordWait.value = false;

      appErrorMessage(context, 'تحقق من اتصالك بالشبكة');
    });
  }
  Future onSignal(id)async{


    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize('6f35037c-58d8-45f4-be58-a1865089f286');
    OneSignal.login('$id');
    OneSignal.Notifications.requestPermission(true);
  }
  @override
  void onClose() {
    super.onClose();
  }
}



