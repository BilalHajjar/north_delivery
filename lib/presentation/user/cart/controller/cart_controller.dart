import 'package:delivary/core/api_connect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/card_model.dart';

class CartController extends GetxController {
  RxList<CardModel> cartItems = <CardModel>[].obs;
  RxBool x = true.obs;

  createOrder(context,
      {required String phone,
      required String note,
      required String address,
      required String link}) async {
    await ApiConnect()
        .postData('create-order', {
          "address": address,
          /* 'required|string' */
          "address_link": link,
          /* 'required|string' */
          "notes": note,
          /* 'nullable|string' */
          "phone_number": phone /* 'required|string|max:20' */
        })
        .then((val) {
          if(val.statusCode==200||val.statusCode==201){
            fetchCartItems();
            appErrorMessage(context, 'تم ارسال الطلب بنجاح');
          }else{appErrorMessage(context, jsonDecode(val.body)['message']);}
    })
        .catchError((e) {});
  }

  // جلب البيانات من API
  Future<void> fetchCartItems() async {
    x.value = true;
    final response = await ApiConnect().getData('cart');

    if (response.statusCode == 200) {
      // إذا كانت الاستجابة ناجحة، قم بتحويل البيانات
      if (jsonDecode(response.body)['message'] != 'السلة فارغة.') {
        List<dynamic> data = jsonDecode(response.body)['cart'];
        cartItems.value = data.map((item) => CardModel.fromJson(item)).toList();
      } else {
        x.value = false;
      }
    } else {
      x.value = false;
      throw Exception('فشل في تحميل البيانات');
    }
  }

  Future<void> deleteCartItems(BuildContext context) async {
    final response = await ApiConnect().deleteData('cart');
    if (response.statusCode == 200) {
      fetchCartItems();
    } else {
      appErrorMessage(context, jsonDecode(response.body)['message']);
    }
  }

  // دالة لتعديل كمية عنصر
  Future<void> updateCartItemQuantity(
      int id, int quantity, BuildContext context) async {
    final response =
        await ApiConnect().putData('cart/$id', {"quantity": quantity});

    if (response.statusCode == 200) {
      // تحديث الكمية محلياً
      int index = cartItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        cartItems[index].quantity = quantity;
        cartItems.refresh();
      }
    } else {
      appErrorMessage(context, jsonDecode(response.body)['message']);
    }
  }

  // دالة لحذف عنصر من السلة
  Future<void> deleteCartItem(int id, BuildContext context) async {
    final response = await ApiConnect().deleteData('cart/$id');

    if (response.statusCode == 200) {
      // حذف العنصر محلياً
      cartItems.removeWhere((item) => item.id == id);
    } else {
      appErrorMessage(context, jsonDecode(response.body)['message']);
    }
  }
}
