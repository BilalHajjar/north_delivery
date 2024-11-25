import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/auth/screens/email_verification_screen.dart';
import 'package:flutter/material.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/text_field_widget.dart';
import '../components/password_widget.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  // Controllers for form fields
  TextEditingController emailController = TextEditingController();
  TextEditingController resetPasswordController = TextEditingController();
  TextEditingController resetPasswordConfirmationController = TextEditingController();
  final List<TextEditingController> controllers =
  List.generate(6, (index) => TextEditingController());
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl, // RTL text direction
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo Image
                    const Center(
                        child: Text(
                          'إعادة تعيين كلمة المرور',
                          style: TextStyle(fontSize: 20),
                        )),
                    const SizedBox(height: 30),

                    // Email TextField
                    const Text('ادخل البريد الإلكتروني'),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      validator: (s) {
                        if (s!.isEmpty) {
                          return 'يجب تعبئة الحقل';
                        } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(s)) {
                          return 'الرجاء إدخال بريد إلكتروني صالح';
                        }
                        return null;
                      },
                      controller: emailController,
                      txt: 'example@email.com',
                      preIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 15),

                    // Verification Code TextField
                    const Text('أدخل رمز التحقق'),
                    const SizedBox(height: 10),
                    SixDigitTextFieldWidget(
                      controllerList: controllers,
                    ),
                    const SizedBox(height: 15),

                    // New Password TextField
                    const Text('أدخل كلمة المرور الجديدة'),
                    const SizedBox(height: 10),
                    PasswordTextField(
                      validator: (s) {
                        if (s!.isEmpty)
                          return 'يجب تعبئة الحقل';
                        else if (s.length < 8)
                          return 'كلمة المرور يجب ان تكون اكثر من 8 محارف';
                        else
                          return null;
                      },
                      controller: resetPasswordController,
                    ),
                    const SizedBox(height: 15),

                    // Confirm Password TextField
                    const Text('تأكيد كلمة المرور الجديدة'),
                    const SizedBox(height: 10),
                    PasswordTextField(
                      validator: (s) {
                        if (s!.isEmpty)
                          return 'يجب تعبئة الحقل';
                        else
                        if (s != resetPasswordConfirmationController.text) {
                          return 'لا يوجد تطابق بين كلمات المرور';
                        } else
                          return null;
                      },
                      controller: resetPasswordConfirmationController,
                    ),
                    const SizedBox(height: 20),

                    // Reset Password Button
                    Obx(() { if(authController.resetPasswordWait.value) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ButtonWidget(
                        text: 'إعادة تعيين كلمة المرور',
                        onTap: () {

                          if (formKey.currentState!.validate()) {
                            String verificationCode = controllers.map((e) =>
                            e.text).join('');

                            authController.resetPassword(context,
                                email: emailController.text,
                                verificationCode: verificationCode,
                                resetPassword: resetPasswordController.text,
                                resetPasswordConfirmation: resetPasswordConfirmationController
                                    .text);
                          }
                        },
                      );
                    }
                    }),
                    const SizedBox(height: 20),

                    // Resend Code Button with Countdown
                    Center(
                      child: Obx(() {
                        return TextButton(
                          onPressed: authController.isButtonEnabledForgetPassword.value
                              ? () {
                            authController.startCountdownForgetPassword();
                          }
                              : null,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                authController.isButtonEnabledForgetPassword.value
                                    ? 'لم تتلقَ الرمز؟'
                                    : 'إعادة إرسال الرمز خلال    ${authController
                                    .formatTime(
                                    authController.secondsRemainingForgetPassword.value)}',
                                style: TextStyle(
                                  color: authController.isButtonEnabledForgetPassword.value
                                      ? AppColors.primaColor
                                      : AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    )
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
