import 'dart:convert';

import 'package:delivary/core/api_connect.dart';
import 'package:delivary/presentation/admin/store/model/list_model.dart';
import 'package:delivary/presentation/admin/store/model/store_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  List<StoreModel> storeList = [];
  List<ListModel> userWithoutStoreList = [];
  List<ListModel> regionsList = [];
  List<CategoryModel> categoriesList = [];

  @override
  onInit() {
    super.onInit();
    getStores();
  }

  RxBool waitStoreList = true.obs;
  deleteStore(context,int id) async {

    waitStoreList.value = true;
    try {
      final response = await ApiConnect().deleteData('stores/$id',);
      if (response.statusCode == 200) {
        storeList.removeWhere((ad) => ad.id == id); // حذف الإعلان من القائمة
        Get.snackbar('نجاح', 'تم حذف المتجر بنجاح.');
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Get.snackbar('خطأ', jsonDecode(response.body)['message']);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر حذف الإعلان. تحقق من اتصال الشبكة.');
    } finally {
      waitStoreList.value = false;
    }
  }
  getStores() async {storeList=[];
    waitStoreList.value = true;
    var response = await ApiConnect().getData('stores');
    try {
      for (Map<String, dynamic> val in jsonDecode(response.body)['data']['data']) {
        storeList.add(StoreModel.fromJson(val));
      }
    } catch (e) {
    } finally {
      waitStoreList.value = false;
    }
  }

  getUserWithoutStore() async {
    await ApiConnect().getData('store-owners/available').then((val) {

    });
  }

  getRegions() async {
    await ApiConnect().getData('regions').then((val) {});
  }

  getCategories() async {
    await ApiConnect().getData('categories').then((val) {});
  }
}
