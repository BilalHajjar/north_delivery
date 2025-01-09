import 'dart:convert';

import 'package:delivary/core/api_connect.dart';
import 'package:delivary/presentation/admin/user_maneger/model/users_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  List<UserModel> usersList = [];
  RxBool isLoading = true.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  int currentPage=1;
  final scroll=ScrollController();
  String? hasMode;
  onInit() {
    super.onInit();
    fetchUsers();
    scroll.addListener((){
      if(scroll.position.maxScrollExtent==scroll.offset){

          int page=++currentPage;
        fetchUsers(page:page++);
    }});
  }

  Future<void> fetchUsers({int page=1}) async {
    if (page == 1)
  {
    usersList.clear();
  }
    isLoading.value = true;
    try {
      final response = await ApiConnect().getData('users?page=$page');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data']['data'];
        hasMode = jsonDecode(response.body)['data']['next_page_url'];
        for(var ad in data) {
          usersList.add(UserModel.fromJson(ad));
        }
      } else {

        // Get.snackbar('خطأ', jsonDecode(response.body)['message']);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر جلب الإعلانات. تحقق من اتصال الشبكة.');
    } finally {
      isLoading.value = false;
    }
  }
RxBool waitAdd=false.obs;
  Future<void> addUser(
    context, {
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
    required String role,
  }) async {
    waitAdd.value=true;
    try {
      final response = await ApiConnect().postData('users', {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "phone_number": phoneNumber,
        "role": role
      });
      if (response.statusCode == 200||response.statusCode==201) {
        Get.back();
        appErrorMessage(context, 'تم إضافة المستخدم بنجاح',title: 'تم');

        fetchUsers(page: 1);
      } else {
        appErrorMessage(context, jsonDecode(response.body)['message']);
        // appErrorMessage(context, '${jsonDecode(response.body)['message']}');
      }
    } catch (e) {
      appErrorMessage(context, 'تحقق من اتصالك');
    }finally{
      waitAdd.value=false;
    }
  }Future<void> updateUser(
    context, {
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
    required String role,
    required int id,
  }) async {
    waitAdd.value=true;
    try {
      final response = await ApiConnect().putData('users/$id', {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "phone_number": phoneNumber,
        "role": role
      });
      if (response.statusCode == 200||response.statusCode == 201) {
        fetchUsers(page: 1);
        appErrorMessage(context, 'تم تعديل المستخدم بنجاح',title: 'تم');
        Get.back();
      } else {
        appErrorMessage(context, jsonDecode(response.body)['message']);
      }
    } catch (e) {
      appErrorMessage(context, 'تحقق من اتصالك');
    }finally{
      waitAdd.value=false;
    }
  }
  reset(){
    currentPage=1;
  }
  Future<void> deleteUser(
    context, {
    required int id,
  }) async {
    waitAdd.value=true;
    try {
      final response = await ApiConnect().deleteData('users/$id',);
      if (response.statusCode == 200) {

        fetchUsers(page: 1);
        Navigator.pop(context);
      } else {
        appErrorMessage(context, '${jsonDecode(response.body)['message']}');
      }
    } catch (e) {
      appErrorMessage(context, 'تحقق من اتصالك');
    }finally{
      waitAdd.value=false;
    }
  }

}
