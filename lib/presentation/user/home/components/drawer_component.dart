import 'package:delivary/presentation/admin/setting/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/colors.dart';
import '../../../../widgets/text_field_widget.dart';
import '../../../admin/user_maneger/model/users_model.dart';
import '../../../auth/components/password_widget.dart';
import '../../../home/controller/home_controller.dart';
import '../../../home/screens/support_screen.dart';
import '../controller/home_user_controller.dart';

class CustomStoreDrawer extends StatelessWidget {
  final UserModel userModel;

  const CustomStoreDrawer({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    SettingController settingController = Get.put(SettingController());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Color(0xffefefef),
        child: Column(
          children: <Widget>[
            // الجزء العلوي (صورة المستخدم)
            Container(
              width: 250,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaColor.withOpacity(0.8),
                    AppColors.secondColor.withOpacity(0.5)
                  ],
                  end: Alignment.topRight,
                  begin: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo1.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                TextEditingController nameController =
                                TextEditingController();
                                TextEditingController phoneController =
                                TextEditingController();
                                nameController.text = '${userModel.name}';
                                phoneController.text =
                                '${userModel.phoneNumber ?? '-'}';
                                return AlertDialog(
                                  actionsAlignment: MainAxisAlignment.center,
                                  title: Center(child: Text('تعديل بياناتك')),
                                  content: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          TextFieldWidget(
                                              txt: 'الاسم',
                                              preIcon: Icons.person,
                                              controller: nameController),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFieldWidget(
                                              txt: 'رقم الهاتف',
                                              preIcon: Icons.phone,
                                              controller: phoneController),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    Obx(() {
                                      return TextButton(
                                          onPressed: () {
                                            if (!controller.waitUpdate.value) {
                                              controller.updateProfile(context,
                                                  name: nameController.text,
                                                  phoneNumber:
                                                  phoneController.text,
                                                  email: userModel.email!);
                                            }
                                          },
                                          child: Text(
                                            'تعديل',
                                            style: TextStyle(
                                                color: controller
                                                    .waitUpdate.value
                                                    ? AppColors.grey
                                                    : null),
                                          ));
                                    }),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('إلغاء')),
                                  ],
                                );
                              });
                        },
                        child: CircleAvatar(
                          backgroundColor: AppColors.grey,
                          radius: 18,
                          child: Icon(
                            Icons.edit,
                            color: AppColors.secondColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${userModel.name}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${userModel.email}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${userModel.phoneNumber ?? '-'}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // القائمة
            Expanded(
              child: ListView(
                children: [
                  _createCardItem(
                    icon: Icons.password,
                    text: 'تغيير كلمة المرور',
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            TextEditingController currentPasswordController =
                            TextEditingController();
                            TextEditingController passwordController =
                            TextEditingController();
                            TextEditingController confirmPasswordController =
                            TextEditingController();
                            return AlertDialog(
                              actionsAlignment: MainAxisAlignment.center,
                              title: Center(child: Text('تغيير كلمة المرور')),
                              content: SingleChildScrollView(
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                                          Text('كلمة المرور الحالية'),

                                      PasswordTextField(
                                        controller:
                                        currentPasswordController,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                                        Text('كلمة المرور الجديدة'),

                                      PasswordTextField(
                                        controller: passwordController,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                                        Text('تأكيد كلمة المرور'),

                                      PasswordTextField(
                                        controller:
                                        confirmPasswordController,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                Obx(() {
                                  return TextButton(
                                      onPressed: () {
                                        if (!controller.waitUpdate.value) {
                                          controller.updateProfile(context,
                                              name: userModel.name!,
                                              phoneNumber:
                                              userModel.phoneNumber!,
                                              email: userModel.email!,
                                              password:
                                              passwordController.text,
                                              currentPassword:
                                              currentPasswordController
                                                  .text,
                                              passwordConfirmation:
                                              confirmPasswordController
                                                  .text);
                                        }
                                      },
                                      child: Text(
                                        'تعديل',
                                        style: TextStyle(
                                            color: controller.waitUpdate.value
                                                ? AppColors.grey
                                                : null),
                                      ));
                                }),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('إلغاء')),
                              ],
                            );
                          });
                    },
                  ),
                  _createCardItem(
                    icon: Icons.support,
                    text: 'الدعم الفني',
                    onTap: () {
                      Get.to(SupportScreen());
                    },
                  ),
                  _createCardItem(
                    icon: Icons.logout,
                    text: 'تسجيل الخروج',
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Center(child: Text('تسجيل الخروج')),
                              content: Text('هل أنت متأكد من تسجيل الخروج؟'),
                              actions: [
                                Obx(() {
                                  return TextButton(
                                      onPressed: () {
                                        if (!controller.waitLogout.value)
                                          controller.logout(context);
                                      },
                                      child: Text(
                                        'خروج',
                                        style: TextStyle(
                                            color: controller.waitLogout.value
                                                ? AppColors.grey
                                                : null),
                                      ));
                                }),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('إلغاء')),
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
            ),

            // التواصل الاجتماعي
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    'بإمكانك متابعتنا أو التواصل معنا عبر',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Obx(() {
                    if(settingController.waitSetting.value)
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton(
                            icon: FontAwesomeIcons.whatsapp,
                            url:
                            '',
                            color: Colors.green,
                          ),
                          SizedBox(width: 20),
                          _socialButton(
                            icon: FontAwesomeIcons.facebook,
                            url:
                            '',
                            color: Colors.blue,
                          ),
                        ],
                      );
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialButton(
                          icon: FontAwesomeIcons.whatsapp,
                          url:
                          'https://wa.me/${settingController.settingModel!
                              .phone}',
                          color: Colors.green,
                        ),
                        SizedBox(width: 20),
                        _socialButton(
                          icon: FontAwesomeIcons.facebook,
                          url:
                          '${settingController.settingModel!.facebook}',
                          color: Colors.blue,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _createCardItem({required IconData icon,
    required String text,
    required GestureTapCallback onTap}) {
    return Card(
      color: AppColors.whiteColor,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.secondColor),
        title: Text(
          text,
          style: TextStyle(color: AppColors.blackColor),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required String url,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        }
      },
      child: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        radius: 25,
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
