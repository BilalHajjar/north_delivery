import 'dart:convert';

import 'package:delivary/presentation/store_owner/products/model/product_model.dart';
import 'package:get/get.dart';

import '../../../../core/api_connect.dart';

class ProductUserController extends GetxController {
  var productList = <ProductModel>[].obs; // استخدام RxList
  var waitProduct = false.obs; // استخدام RxBool
  var count = 0.obs;

  Future<void> getAllProduct(int id) async {
    waitProduct.value = true;
    try {
      var response = await ApiConnect().getData('stores/$id/products');
      if (response.statusCode == 200) {
        var products = jsonDecode(response.body)['products']['data'] as List;
        productList.value = products
            .map((product) => ProductModel.fromJson(product))
            .toList();
      }
    } catch (e) {
    } finally {
      waitProduct.value = false;
    }
  }

  Future<void> addCard(int id, int quantity) async {
    try {
      var response = await ApiConnect().postData('cart', {
        "product_id": id,
        "quantity": quantity,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', jsonDecode(response.body)['message']);
      }
    } catch (e) {
    }
  }
}
