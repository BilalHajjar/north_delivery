import 'dart:convert';

import 'package:delivary/core/api_connect.dart';
import 'package:delivary/presentation/admin/user_maneger/model/users_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  List<UserModel> usersList = [];
  RxBool isLoading = true.obs;

  onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final response = await ApiConnect().getData('users');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        usersList =
            data.map<UserModel>((ad) => UserModel.fromJson(ad)).toList();
      } else {
        Get.snackbar('خطأ', jsonDecode(response.body)['message']);
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
      if (response.statusCode == 200) {
        fetchUsers();
      } else {
        showErrorSnackbar(context, '${jsonDecode(response.body)['message']}');
      }
    } catch (e) {
      showErrorSnackbar(context, 'تحقق من اتصالك');
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
      if (response.statusCode == 200) {
        fetchUsers();
      } else {
        showErrorSnackbar(context, '${jsonDecode(response.body)['message']}');
      }
    } catch (e) {
      showErrorSnackbar(context, 'تحقق من اتصالك');
    }finally{
      waitAdd.value=false;
    }
  }
  Future<void> deleteUser(
    context, {
    required int id,
  }) async {
    waitAdd.value=true;
    try {
      final response = await ApiConnect().deleteData('users/$id',);
      if (response.statusCode == 200) {
        fetchUsers();
        Navigator.pop(context);
      } else {
        showErrorSnackbar(context, '${jsonDecode(response.body)['message']}');
      }
    } catch (e) {
      showErrorSnackbar(context, 'تحقق من اتصالك');
    }finally{
      waitAdd.value=false;
    }
  }

}
