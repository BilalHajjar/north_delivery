import 'package:delivary/core/colors.dart';
import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/auth/controller/auth_controller.dart';
import 'package:delivary/presentation/auth/screens/reset_password_screen.dart';
import 'package:delivary/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void forgetPasswordDialog(context) {
  AuthController controller = Get.find();
  showDialog(
      context: context,
      builder: (_) {
        final formKey = GlobalKey<FormState>();
        TextEditingController resendConfirmationEmailResetController =
        TextEditingController();
        return Form(
          key: formKey,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Text(
                'إعادة تعيين كلمة السر',
                style: TextStyle(fontSize: 16),
              ),
              content: TextFieldWidget(
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
                  preIcon: Icons.password,
                  txt: 'ادخل الايميل',
                  controller: resendConfirmationEmailResetController),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'إلغاء',
                      style: TextStyle(color: AppColors.primaColor),
                    )),
                Obx(() {
                  return TextButton(
                      onPressed: () {
                        if(!controller.sendPasswordResetLinkWait.value)
                        if (formKey.currentState!.validate()) {
                          controller.sendPasswordResetLink(context,
                              email: resendConfirmationEmailResetController
                                  .text);
                        }

                        // controller.forgotPassword(context);
                      },
                      child: Text(
                        'موافق',
                        style: TextStyle(color:!controller.sendPasswordResetLinkWait.value? AppColors.primaColor:AppColors.grey),
                      ));
                }),
              ],
            ),
          ),
        );
      });
}
