import 'package:delivary/core/api_connect.dart';
import 'package:delivary/core/cache_helper.dart';
import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/auth/controller/auth_controller.dart';
import 'package:delivary/widgets/button_widget.dart';
import 'package:delivary/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({super.key, required this.email});

  String? email;
  final TextEditingController otpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final AuthController controller = Get.put(AuthController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> checkEmail() async {
    if (email != null) {
      await CacheHelper.saveData(key: 'email', value: email);
    } else {
      email = await CacheHelper().getDataString(key: 'email');
    }
    emailController.text=email!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkEmail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Center(
                        child: Text(
                          'إدخال رمز التحقق المرسل عبر البريد',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 80),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFieldWidget(
                          txt: 'example@email.com',
                          preIcon: Icons.email_outlined,
                          controller: emailController,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text('أدخل رمز التحقق المكون من 6 أحرف'),
                      const SizedBox(height: 10),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: otpController,
                        animationType: AnimationType.scale,

                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (value) {
                          // print("Value changed: $value");
                        },
                        onCompleted: (value) {
                          // print("Completed: $value");
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                          selectedFillColor: Colors.grey[200]!,
                          // لون الخلفية للحقل المحدد
                          inactiveFillColor: Colors.grey[300]!,
                          // لون الخلفية للحقل غير المحدد
                          activeColor: Colors.blue,
                          // لون الحافة للحقل النشط
                          selectedColor: AppColors.primaColor,
                          // لون الحافة للحقل المحدد
                          inactiveColor: Colors
                              .grey, // لون الحافة للحقل غير المحدد
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        if(controller.verifyEmailWait.value)
                          return Center(child: CircularProgressIndicator());
                        return ButtonWidget(
                          onTap: () {
                            String verificationCode = otpController.text;
                            if (formKey.currentState!.validate()) {
                              controller.verifyEmail(
                                context,
                                email: email!,
                                code: verificationCode,
                              );
                            }
                          },
                          text: 'تحقق',
                        );
                      }),
                      const SizedBox(height: 20),
                      Center(
                        child: Obx(() {
                          return TextButton(
                            onPressed: controller.isButtonEnabledSendEmail.value
                                ? () {
                              controller.startCountdownSendEmail(
                                context,
                                email: email!,
                              );
                            }
                                : null,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.isButtonEnabledSendEmail.value
                                      ? 'لم تتلقَ الرمز؟'
                                      : 'إعادة إرسال الرمز خلال ${controller
                                      .formatTime(
                                      controller.secondsRemainingSendEmail
                                          .value)}',
                                  style: TextStyle(
                                    color: controller.isButtonEnabledSendEmail
                                        .value
                                        ? AppColors.primaColor
                                        : AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

