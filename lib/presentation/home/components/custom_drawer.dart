import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/admin/ads_maneger/screens/ads_screen.dart';
import 'package:delivary/presentation/admin/setting/srceen/setting_screen.dart';
import 'package:delivary/presentation/admin/store/screens/store_screen.dart';
import 'package:delivary/presentation/admin/user_maneger/model/users_model.dart';
import 'package:delivary/presentation/admin/user_maneger/screens/users_screen.dart';
import 'package:delivary/presentation/auth/components/password_widget.dart';
import 'package:delivary/presentation/home/controller/home_controller.dart';
import 'package:delivary/presentation/home/screens/support_screen.dart';
import 'package:delivary/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAdminDrawer extends StatelessWidget {
  final UserModel userModel;

  const CustomAdminDrawer({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // padding: EdgeInsets.zero,
        children: <Widget>[
          Spacer(),
          Center(
              child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                  radius: 60,
                  child: Image.asset(
                    'assets/images/logo1.png',
                  )),
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
                                      preIcon: Icons.person,
                                      controller: phoneController),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            Obx(() {
                              return TextButton(
                                  onPressed: () {
                                    if (!controller.waitUpdate.value)
                                      controller.updateProfile(context,
                                          name: nameController.text,
                                          phoneNumber: phoneController.text,
                                          email: userModel.email!);
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
                child: CircleAvatar(
                    backgroundColor: AppColors.grey,
                    radius: 15,
                    child: Icon(
                      Icons.edit,
                      color: AppColors.secondColor,
                      size: 15,
                    )),
              ),
            ],
          )),
          Center(
              child: Text(
            '${userModel.name}',
            style: TextStyle(color: AppColors.blackColor, fontSize: 20),
          )),
          SizedBox(
            height: 10,
          ),
          Center(
              child: Text(
            '${userModel.email}',
            style: TextStyle(color: AppColors.blackColor, fontSize: 14),
          )),
          SizedBox(
            height: 10,
          ),
          Center(
              child: Text(
            '${userModel.phoneNumber ?? '-'}',
            style: TextStyle(color: AppColors.blackColor, fontSize: 14),
          )),
          Divider(),
          SizedBox(
            height: 10,
          ),
          _createDrawerItem(
            icon: Icons.home,
            text: 'الصفحة الرئيسية',
            onTap: () {
              controller.changeScreen(screen: 0);
              Navigator.pop(context);
            },
          ),
          _createDrawerItem(
            icon: Icons.groups,
            text: 'إدارة المستخدمين',
            onTap: () {
          controller.changeScreen(screen: 2);
          Navigator.pop(context);
            },
          ),_createDrawerItem(
            icon: Icons.store_mall_directory_rounded,
            text: 'إدارة المتاجر',
            onTap: () {
              controller.changeScreen(screen: 1);
              Navigator.pop(context);
            },
          ),
          _createDrawerItem(
            icon: Icons.link,
            text: 'إدارة الروابط',
            onTap :() {
              controller.changeScreen(screen: 4);
              Navigator.pop(context);

            },
          ), _createDrawerItem(
            icon: Icons.add_to_home_screen,
            text: 'إدارة الإعلانات',
            onTap:  () {
              controller.changeScreen(screen: 3);
              Navigator.pop(context);

            },
          ),
          _createDrawerItem(
            icon: Icons.password,
            text: 'تغيير كلمة المرور',
            onTap:  () {
            showDialog(context: context, builder: (_){
              TextEditingController currentPasswordController=TextEditingController();
              TextEditingController passwordController=TextEditingController();
              TextEditingController confirmPasswordController=TextEditingController();
              return AlertDialog(
                actionsAlignment: MainAxisAlignment.center,
                title: Center(child: Text('تغيير كلمة المرور')),content: SingleChildScrollView(
                child: Directionality(textDirection: TextDirection.rtl,
                  child: Column(children: [
                    Text('كلمة المرور الحالية'),
                  PasswordTextField(controller: currentPasswordController,),
                  SizedBox(height: 10,),
                  Text('كلمة المرور الجديدة'),
                  PasswordTextField(controller: passwordController,),
                    SizedBox(height: 10,),
                  Text('تأكيد كلمة المرور'),

                  PasswordTextField(controller: confirmPasswordController,),
                              ],),
                ),
              ),actions: [
                Obx(() {
                  return TextButton(
                      onPressed: () {
                        if (!controller.waitUpdate.value)
                          controller.updateProfile(context,
                              name: userModel.name!,
                              phoneNumber: userModel.phoneNumber!,
                              email: userModel.email!,

                              password:passwordController.text ,currentPassword: currentPasswordController.text,passwordConfirmation:confirmPasswordController.text );
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
              ],);});
            },
          ),

          // _createDrawerItem(
          //   icon: Icons.notifications,
          //   text: 'الإشعارات',
          //   onTap: () =>
          //       Navigator.pushReplacementNamed(context, '/notifications'),
          // ),
          // _createDrawerItem(
          //   icon: Icons.policy,
          //   text: 'سياسة الاستخدام',
          //   onTap: () => Navigator.pushReplacementNamed(context, '/policy'),
          // ),
          // _createDrawerItem(
          //   icon: Icons.info,
          //   text: 'عن التطبيق',
          //   onTap: () => Navigator.pushReplacementNamed(context, '/about'),
          // ),
          _createDrawerItem(
            icon: Icons.support,
            text: 'الدعم الفني',
            onTap: (){
              Get.to(SupportScreen());
            },
          ),
          _createDrawerItem(
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
                            child: Text('إلغاء')),],
                    );
                  });
            },
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData? icon, String? text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: AppColors.secondColor,
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text(
              text!,
              style: TextStyle(color: AppColors.blackColor),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
