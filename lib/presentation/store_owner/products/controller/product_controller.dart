import 'dart:convert';
import 'dart:io';

import 'package:delivary/core/api_connect.dart';
import 'package:delivary/presentation/store_owner/products/model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  List<ProductModel> productList = [];
  RxBool isLoading = true.obs;

  @override
  onInit() {
    super.onInit();
    getProduct();
  }

  getProduct() async {
    isLoading.value = true;
    try {
      final response = await ApiConnect().getData('products');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data']['data'];
        productList =
            data.map<ProductModel>((ad) => ProductModel.fromJson(ad)).toList();
      } else {
        Get.snackbar('خطأ', jsonDecode(response.body)['message']);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر جلب المنتجات. تحقق من اتصال الشبكة.');
    } finally {
      isLoading.value = false;
    }
  }

  RxBool waitingDelete = false.obs;

  deleteProduct(context, id) async {
    waitingDelete.value = true;
    try {
      final response = await ApiConnect().deleteData('products/$id');
      if (response.statusCode == 200) {
        getProduct();
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Get.snackbar('خطأ', jsonDecode(response.body)['message']);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر جلب الإعلانات. تحقق من اتصال الشبكة.');
    } finally {
      waitingDelete.value = false;
    }
  }

  RxBool waitingAdd = false.obs;

  addProduct(
      {required String name,
      required String description,
      required String price,
      required File file}) async {
    waitingAdd.value = true;
    await ApiConnect()
        .postDataFile(
            'products',
            {
              'name': name,
              'description': description,
              'price': price,
            },
            file: file)
        .then((value) {
      waitingAdd.value = false;
      if (value.statusCode == 201) {
        getProduct();
        Get.back();
        Get.snackbar('تم', 'تمت إضافة المنتج بنجاح');
      } else {
        Get.snackbar('خطأ', jsonDecode(value.body)['message']);
      }
    }).catchError((e) {
      waitingAdd.value = false;
      Get.snackbar('خطأ', 'تعذرت الاضافة. تحقق من اتصال الشبكة.');
    });
  }

  updateProduct(
      {required int id,
      required String name,
      required String description,
      required String price,
      required int isAvailable,
      File? file}) async {
    waitingAdd.value = true;
    var value;
    try {
      if(file!=null) {
        value = await ApiConnect().postDataFile(
          'products/$id?_method=PUT',
          {
            'name': name,
            'description': description,
            'price': price,
            'is_available': '$isAvailable'
          },
          file: file);
      } else{
         value = await ApiConnect().postData(
            'products/$id?_method=PUT',
            {
              'name': name,
              'description': description,
              'price': price,
              'is_available': '$isAvailable'
            },);
      }
      if (value.statusCode == 201 || value.statusCode == 200) {
      getProduct();
      Get.back();
      Get.snackbar('تم', 'تمت إضافة المنتج بنجاح');
    } else {
      Get.snackbar('خطأ', jsonDecode(value.body)['message']);
    }}catch(e){
      Get.snackbar('خطأ', 'تعذر التعديل. تحقق من اتصال الشبكة.');
    }finally{

      waitingAdd.value=false;
    }
  }
}
