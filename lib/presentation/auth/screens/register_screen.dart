import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/auth/components/password_widget.dart';
import 'package:delivary/presentation/auth/controller/auth_controller.dart';
import 'package:delivary/presentation/auth/screens/email_verification_screen.dart';
import 'package:delivary/presentation/auth/screens/login_screens.dart';
import 'package:delivary/widgets/button_widget.dart';

// import 'package:delivary/widgets/button_widget.dart';
import 'package:delivary/widgets/text_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController checkedPasswordController = TextEditingController();
  AuthController controller = Get.find<AuthController>();
  var formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding:const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 20,),
                      SizedBox(
                        height: 105,
                        child: Center(
                            child: Image.asset(
                              'assets/images/logo1.png',
                              width: 180,
                              // height: 200,
                            )),
                      ),
                      const SizedBox(height: 10),
                      // Email TextField
                      const  Text('الاسم الكامل'),
                      const  SizedBox(height: 10),
                      TextFieldWidget(
                        validator: (s) {
                          if (s!.isEmpty) {
                            return 'يجب تعبئة الحقل';
                          } else if (s.length<6) {
                            return 'يجب ادخال اسم صحيح';
                          }
                          return null;
                        },
                        controller: nameController,
                        txt: 'محمد العلي ',
                        preIcon: Icons.person_outline
                        ,
                      ),
                      const   SizedBox(height: 15),const Text('ادخل البريد الالكتروني'),
                      const  SizedBox(height: 10),
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
                      const  SizedBox(height: 15),
                      // Password TextField
                      const Text('ادخل كلمة المرور'),
                      const SizedBox(height: 10),
                      PasswordTextField(
                        validator: (s) {
                          if (s!.isEmpty)
                            return 'يجب تعبئة الحقل';
                          else if(s!.length<8)
                            return 'كلمة المرور يجب ان تكون اكثر من 8 محارف';
                          else
                            return null;
                        },
                        controller: passwordController,
                      ),
                      SizedBox(height: 15),
                      // Password TextField
                      const Text('تأكيد كلمة المرور'),
                      const SizedBox(height: 10),
                      PasswordTextField(
                        validator: (s) {
                          if (s!.isEmpty)
                            return 'يجب تعبئة الحقل';
                          if (s != passwordController.text) {
                            return 'لا يوجد تطابق بين كلمات المرور';
                          }
                          else
                            return null;
                        },
                        controller: checkedPasswordController,
                      ),
                      // SizedBox(height: 8),

                      const SizedBox(height: 20),
                      Obx(() {
                        if(controller.registerWait.value) {
                          return const Center(child: CircularProgressIndicator(),);
                        }
                        return ButtonWidget(
                          text: 'إنشاء الحساب',
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              controller.register(
                                  context, name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  passwordConfirmation: checkedPasswordController
                                      .text);
                            }

                          },
                        );
                      }),
                      // const SizedBox(height: 20),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Container(
                      //     height: 55,
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //       border: Border.all(color: AppColors.primaColor),
                      //       borderRadius: BorderRadius.circular(18),
                      //       // color:AppColors.primaColor
                      //     ),
                      //     child: const Center(
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Text(
                      //             'أنشئ باستخدام غوغل',
                      //           ),
                      //           SizedBox(width: 10),
                      //           FaIcon(
                      //             FontAwesomeIcons.google,
                      //             color: Colors.orange,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 20),

                      // Register
                      // Center(
                      //   child: RichText(
                      //     text: TextSpan(
                      //       text: "لديك حساب سابق؟   ",
                      //       style: const TextStyle(
                      //           color: Colors.black, fontFamily: 'FontApp'),
                      //       children: [
                      //         TextSpan(
                      //           text: 'سجل الآن',
                      //           style: const TextStyle(
                      //               color: Colors.orange,
                      //               fontFamily: 'FontApp'),
                      //           recognizer: TapGestureRecognizer()
                      //             ..onTap = () {
                      //               Navigator.pushReplacement(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) => LoginScreens()),
                      //               );
                      //             },
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
