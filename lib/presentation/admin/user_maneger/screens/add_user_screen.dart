import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/admin/user_maneger/controller/users_controller.dart';
import 'package:delivary/presentation/admin/user_maneger/model/users_model.dart';
import 'package:delivary/presentation/auth/components/password_widget.dart';
import 'package:delivary/widgets/button_widget.dart';
import 'package:delivary/widgets/out_line_button.dart';
import 'package:delivary/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUserScreen extends StatelessWidget {
  AddUserScreen({super.key, this.userModel});

  UserModel? userModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    if (userModel != null) {
      nameController.text = userModel!.name!;
      emailController.text = userModel!.email!;
      phoneController.text = userModel!.phoneNumber ??'';
      role=userModel!.role!;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة مستخدم'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15)),
          child: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الاسم'),
                  TextFieldWidget(
                      txt: 'محمد العلي',
                      preIcon: Icons.person,
                      controller: nameController),
                  const   Text('البريد الالكتروني'),
                  TextFieldWidget(
                      txt: 'example@email.com',
                      preIcon: Icons.email,
                      controller: emailController),
                  const  Text('كلمة المرور'),
                  PasswordTextField(controller: passwordController),
                  const   Text('تأكيد كلمة المرور'),
                  PasswordTextField(controller: confirmPasswordController),
                  const    Text('رقم الهاتف'),
                  TextFieldWidget(
                      txt: '1234567890+',
                      preIcon: Icons.phone,
                      controller: phoneController),
                  RadioWidget(),
                  if(userModel==null)
                  Obx(() {
                    if (controller.waitAdd.value)
                      return Center(child: CircularProgressIndicator());
                    return ButtonWidget(
                        text: userModel==null?'إضافة':'تعديل',
                        onTap: () {
                          if (userModel == null) {
                            controller.addUser(context,
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                passwordConfirmation:confirmPasswordController.text,
                                phoneNumber: phoneController.text,
                                role: role);
                          } else {
                            controller.updateUser(context,
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                passwordConfirmation: confirmPasswordController.text,
                                phoneNumber: phoneController.text,
                                role: role,
                                id: userModel!.id!);
                          }
                        });
                  }),
                  if(userModel!=null)
                    Obx(() {
                      if (controller.waitAdd.value)
                        return Center(child: CircularProgressIndicator());
                      return Row(
                        children: [
                          Expanded(
                            child: OutLineButton(
                                text: 'تعديل',
                                func: () {
                            
                                    controller.updateUser(context,
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        passwordConfirmation: confirmPasswordController.text,
                                        phoneNumber: phoneController.text,
                                        role: role,
                                        id: userModel!.id!);
                            
                                }, icn: Icons.edit,),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                                child: OutLineButton(
                                text: 'حذف',
                                
                                func: () {
                                
                                    controller.deleteUser(context,
                                        id: userModel!.id!);
                                
                                }, icn: Icons.delete,),
                              ),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String role = 'store-owner';

class RadioWidget extends StatefulWidget {
  RadioWidget({super.key});

  @override
  State<RadioWidget> createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
            title: Text('مدير'),
            value: 'admin',
            groupValue: role,
            onChanged: (v) {
              setState(() {
                role = 'admin';
              });
            }),
        // RadioListTile(
        //     title: Text('مستخدم'),
        //     value: 'user',
        //     groupValue: widget.type,
        //     onChanged: (v) {
        //       setState(() {
        //         widget.type = 'user';
        //       });
        //     }),
        RadioListTile(
            title: Text('بائع'),
            value: 'store-owner',
            groupValue: role,
            onChanged: (v) {
              setState(() {
                role = 'store-owner';
              });
            }), RadioListTile(
            title: Text('مستخدم'),
            value: 'user',
            groupValue: role,
            onChanged: (v) {
              setState(() {
                role = 'user';
              });
            }),
      ],
    );
  }
}
