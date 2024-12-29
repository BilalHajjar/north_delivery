import 'package:delivary/core/api_connect.dart';
import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/auth/controller/auth_controller.dart';
import 'package:delivary/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({super.key, required this.email});
final String email;
  final List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());
AuthController controller =Get.put(AuthController());
var formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // الشعار

                  const Center(child: Text('إدخال رمز التحقق المرسل عبر البريد',style: TextStyle(fontSize: 20),)),
                  // const   SizedBox(height: 10),
                  // const Center(
                  //   child: Icon(Icons.email_outlined,size: 150,color: AppColors.primaColor,),
                  // ),

               const   SizedBox(height: 80),
               const   Text('أدخل رمز التحقق المكون من 6 أحرف'),
               const   SizedBox(height: 10),
                  SixDigitTextFieldWidget(controllerList: controllers),
               const   SizedBox(height: 20),

                  ButtonWidget(
                    onTap: () {
                      String verificationCode = controllers.map((controller) => controller.text).join('');
                   if(formKey.currentState!.validate())
                     {
                       controller.verifyEmail(email: email, code: verificationCode);
                     }
                    },
                    text: 'تحقق',
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: Obx(() {
                      return TextButton(
                        onPressed: controller.isButtonEnabledSendEmail.value
                            ? () {
                          controller.startCountdownSendEmail();
                        }
                            : null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.isButtonEnabledSendEmail.value
                                  ? 'لم تتلقَ الرمز؟'
                                  : 'إعادة إرسال الرمز خلال    ${controller
                                  .formatTime(
                                  controller.secondsRemainingSendEmail.value)}',
                              style: TextStyle(
                                color: controller.isButtonEnabledSendEmail.value
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
    );
  }

}

class SixDigitTextFieldWidget extends StatelessWidget {
  SixDigitTextFieldWidget({
    super.key,
    required this.controllerList,
    this.onFieldSubmitted,
  });

  final List<TextEditingController> controllerList;
  final Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) {
          return Container(
            width: 45,
            margin: EdgeInsets.symmetric(horizontal: 3),
            child: TextFormField( validator: (s) {
              if (s!.isEmpty)
                return '';

              else
                return null;
            },
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              controller: controllerList[index],
              textAlign: TextAlign.center,
              maxLength: 1,
              decoration: const InputDecoration(
                counterText: "",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.length == 1 && index < 6) {
                  FocusScope.of(context).nextFocus();
                }
                if (value.isEmpty && index > 0) {
                  Future.microtask(() {
                    FocusScope.of(context).previousFocus();
                  });
                }
              },
              // onSubmitted: onFieldSubmitted,
            ),
          );
        }),
      ),
    );
  }
}
