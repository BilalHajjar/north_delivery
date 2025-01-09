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
  List<CategoryModel> categoriesList = [];int currentPage=1;
 final scroll=ScrollController();
 String? hasMode;
  @override
  onInit() {
    super.onInit();
    getStores();
    scroll.addListener((){
      if(scroll.position.maxScrollExtent==scroll.offset){

          int page=++currentPage;
          getStores(page:page++);
    }});
  }

  RxBool waitStoreList = true.obs;
  deleteStore(context,int id) async {

    waitStoreList.value = true;
    try {
      final response = await ApiConnect().deleteData('stores/$id',);
      if (response.statusCode == 200||response.statusCode == 201) {
        storeList.removeWhere((ad) => ad.id == id);
        appErrorMessage(context, 'تم حذف المتجر بنجاح.',title: 'تم');
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        appErrorMessage(context, jsonDecode(response.body)['message']);
      }
    } catch (e) {
      appErrorMessage(context,'تعذر حذف الإعلان. تحقق من اتصال الشبكة.');
    } finally {
      waitStoreList.value = false;
    }
  }
  getStores({int page=1}) async {
    if (page == 1)
    {
      storeList.clear();
    }
    waitStoreList.value = true;
    var response = await ApiConnect().getData('stores?page=$page');
    try {

      hasMode = jsonDecode(response.body)['data']['next_page_url'];
      for (Map<String, dynamic> val in jsonDecode(response.body)['data']['data']) {
        storeList.add(StoreModel.fromJson(val));
      }
    } catch (e) {
    } finally {
      waitStoreList.value = false;
    }
  }



}
