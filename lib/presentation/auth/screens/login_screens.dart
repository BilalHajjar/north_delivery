import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/auth/components/forget_password_dialog.dart';
import 'package:delivary/presentation/auth/components/password_widget.dart';
import 'package:delivary/presentation/auth/controller/auth_controller.dart';
import 'package:delivary/presentation/auth/screens/register_screen.dart';
import 'package:delivary/widgets/button_widget.dart';
import 'package:delivary/widgets/out_line_button.dart';
import 'package:delivary/widgets/text_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../components/switch_component.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<void> signInWithGoogle() async {
  try {
    // تسجيل الدخول إلى Google
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // الحصول على التوكن
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        // استدعاء الـ API مع التوكن
        final response = await http.post(
          Uri.parse('https://northdeliveryservices.com/api/auth/google/callback'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: '{"token": "$idToken"}',
        );

        if (response.statusCode == 200) {
          // نجاح الطلب
          print('Login successful: ${response.body}');
        } else {
          // فشل الطلب
          print('Failed to login: ${response.statusCode}');
        }
      }
    }
  } catch (error) {
    print('Error during Google sign-in: $error');
  }
}

bool rememberMe = true;

class LoginScreens extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    var _formKey=GlobalKey<FormState>();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 105,
                      child: Center(
                          child: Image.asset(
                        'assets/images/logo1.png',
                        width: 180,
                        // height: 200,
                      )),
                    ),

                    // SizedBox(height: 30),
                    // const Text(
                    //   'رجاء... املأ الحقول لتسجيل الدخول للتطبيق',
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    const SizedBox(height: 30),
                    // Email TextField
                    const Text('ادخل البريد الالكتروني'),
                    const SizedBox(height: 10),
                    TextFieldWidget(validator: (s) {
                      if (s!.isEmpty) {
                        return 'يجب تعبئة الحقل';
                      } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(s)) {
                        return 'الرجاء إدخال بريد إلكتروني صالح';
                      }
                      return null;
                    },

                      controller: emailController,
                      txt: 'example@email.com',
                      preIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 15),
                    // Password TextField
                    const Text('ادخل كلمة المرور'),
                    const SizedBox(height: 10),
                    PasswordTextField(
                      controller: passwordController,
                        validator: (s) {
                          if (s!.isEmpty) {
                            return 'يجب تعبئة الحقل';
                          } else if(s!.length<8)
                            return 'كلمة المرور يجب ان تكون اكثر من 8 محارف';
                          else
                            return null;
                        },

                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        SwitchComponent(),
                        Text('تذكرني'),
                        Spacer(),
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                            onPressed: () {
                              forgetPasswordDialog(context);
                            },
                            child: const Text(
                              'نسيت كلمة المرور؟',
                              style: TextStyle(color: AppColors.primaColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Obx(() {
                      if (controller.loginWait.value) {
                        return const SizedBox(
                            height: 55,
                            child: Center(child: CircularProgressIndicator()));
                      }
                      return ButtonWidget(
                        text: 'تسجيل الدخول',
                        onTap: () {
                          if(_formKey.currentState!.validate()) {
                            controller.login(context,
                              email: emailController.text,
                              password: passwordController.text);
                          }
                        },
                      );
                    }),
                    const SizedBox(height: 20),
                    OutLineButton(icn: FontAwesomeIcons.google, text: 'سجل باستخدام غوغل', func: () {
                      signInWithGoogle();

                    },),
                    const SizedBox(height: 30),

                    // Register
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "ليس لديك حساب؟   ",
                          style: const TextStyle(
                              color: Colors.black, fontFamily: 'FontApp'),
                          children: [
                            TextSpan(
                              text: 'أنشئ واحداً',
                              style: TextStyle(
                                  color: Colors.orange, fontFamily: 'FontApp'),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterScreen()),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

