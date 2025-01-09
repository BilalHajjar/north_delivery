import 'dart:convert';

import 'package:delivary/presentation/store_owner/products/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/api_connect.dart';

class ProductUserController extends GetxController {
  var productList = <ProductModel>[].obs; // استخدام RxList
  var waitProduct = false.obs; // استخدام RxBool
  var count = 0.obs;
  String? hasMode;
  int currentPage=1;
  final scroll=ScrollController();
  @override
  onInit() {
    super.onInit();
    scroll.addListener((){
      if(scroll.position.maxScrollExtent==scroll.offset){

        int page=++currentPage;
        getAllProduct(page: page++);
      }});
  }
  int? id;
  Future<void> getAllProduct({int page=1}) async {
    if(page==1){
      productList.clear();
    }
    waitProduct.value = true;
    try {
      var response = await ApiConnect().getData('stores/$id/products?page=$page');
      if (response.statusCode == 200) {
        var products = jsonDecode(response.body)['products']['data'] as List;
        hasMode = jsonDecode(response.body)['products']['next_page_url'];

        for(var val in products){
          productList.add(ProductModel.fromJson(val));
        }

      }
    } catch (e) {
    } finally {
      waitProduct.value = false;
    }
  }

  // Future<void> addCard(int id, int quantity,context) async {
  //   try {
  //     var response = await ApiConnect().postData('cart', {
  //       "product_id": id,
  //       "quantity": quantity,
  //     });
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       appErrorMessage(context, jsonDecode(response.body)['message'],title: 'تم');
  //     }else{
  //
  //       appErrorMessage(context, jsonDecode(response.body)['message']);
  //     }
  //   } catch (e) {
  //     appErrorMessage(context, 'تحقق من اتصالك بالشبكة');
  //
  //   }
  // }
}
