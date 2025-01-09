import 'dart:convert';
import 'dart:io';

import 'package:delivary/core/api_connect.dart';
import 'package:delivary/presentation/store_owner/products/model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  List<ProductModel> productList = [];
  RxBool isLoading = true.obs;
  String? hasMode;
  int currentPage=1;
  final scroll=ScrollController();
  @override
  onInit() {
    super.onInit();
    getProduct();
       scroll.addListener((){
      if(scroll.position.maxScrollExtent==scroll.offset){

          int page=++currentPage;
          getProduct(page: page++);
    }});
  }

  getProduct({int page = 1}) async {
    if (page == 1)
    {
      productList.clear();
    }
    isLoading.value = true;
    try {
      final response = await ApiConnect().getData('products?page=$page');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data']['data'];

        for(var val in data){
          productList.add(ProductModel.fromJson(val));
        }
        hasMode = jsonDecode(response.body)['data']['next_page_url'];
      } else {
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
        getProduct(page: 1);
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        appErrorMessage(context, jsonDecode(response.body)['message']);
      }
    } catch (e) {

      appErrorMessage(context,'تعذر جلب الإعلانات. تحقق من اتصال الشبكة.');
    } finally {
      waitingDelete.value = false;
    }
  }

  RxBool waitingAdd = false.obs;

  addProduct(context,
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
        getProduct(page: 1);
        Get.back();
        appErrorMessage(context, 'تمت إضافة المنتج بنجاح',title: 'تم');
      } else {
        appErrorMessage(context, jsonDecode(value.body)['message']);
      }
    }).catchError((e) {
      waitingAdd.value = false;
      appErrorMessage(context, 'تعذرت الاضافة. تحقق من اتصال الشبكة.');
    });
  }

  updateProduct(context,
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
      getProduct(page: 1);
      Get.back();
      appErrorMessage(context, 'تم تعديل المنتج بنجاح',title: 'تم');
    } else {
        appErrorMessage(context, jsonDecode(value.body)['message']);
    }}catch(e){
      appErrorMessage(context,'تعذر التعديل. تحقق من اتصال الشبكة.');
    }finally{

      waitingAdd.value=false;
    }
  }
}
