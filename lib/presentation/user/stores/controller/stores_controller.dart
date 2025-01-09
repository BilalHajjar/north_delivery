import 'dart:convert';

import 'package:delivary/presentation/admin/store/model/list_model.dart';
import 'package:delivary/presentation/admin/store/model/store_model.dart';
import 'package:delivary/presentation/user/home/controller/home_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/api_connect.dart';

class AllStoresController extends GetxController {
  List<StoreModel> storeList = [];
  List<ListModel> categoryList = [];
  List<ListModel> regionsList = [];
  var selectedCategory = Rxn<ListModel>();
  var selectedRegion = Rxn<ListModel>();
  var waitCategories = true.obs;
  var waitRegions = false.obs;
  var wait = true.obs;
  String? hasMode;
  int currentPage=1;
  final scroll=ScrollController();
  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
    scroll.addListener((){
      if(scroll.position.maxScrollExtent==scroll.offset){
        int page=++currentPage;
        if (selectedCategory.value != null && selectedRegion.value != null) {
           fetchStoresByCategoryAndRegion(
          selectedCategory.value!.id!,
          selectedRegion.value!.id!,page: page
          );
        } else if (selectedCategory.value != null) {
           fetchStoresByCategory(selectedCategory.value!.id!,page: page);
        } else if (selectedRegion.value != null) {
           fetchStoresByRegion(selectedRegion.value!.id!,page: page);
        } else {
          getAllStores(page: page);
        }
      }});
  }

  void fetchInitialData() {

    // \\\\\\\\\t\\\\\\\\\\\\\\\\\/////////////////////////////////////////////////////////////////////////////

    getAllCategories();
    getRegions();
  }

  // تطبيق الفلاتر
  Future<void> applyFilters() async {
    currentPage=1;
    wait.value = true;
    hasMode=null;
    storeList.clear();
    update();

    if (selectedCategory.value != null && selectedRegion.value != null) {
      await fetchStoresByCategoryAndRegion(
        selectedCategory.value!.id!,
        selectedRegion.value!.id!,
      );
    } else if (selectedCategory.value != null) {
      await fetchStoresByCategory(selectedCategory.value!.id!);
    } else if (selectedRegion.value != null) {
      await fetchStoresByRegion(selectedRegion.value!.id!);
    } else {
      await getAllStores();
    }

    wait.value = false;
    update();
  }

  // جلب كل المتاجر
  Future<void> getAllStores({int page=1}) async {

    wait.value = true;
    if(page==1)
    {
      storeList.clear();
    }
    final response = await ApiConnect().getData('all-stores?page=$page');
    if (response.statusCode == 200) {
      var data =
          jsonDecode(response.body)['stores']['data'];
      hasMode = jsonDecode(response.body)['stores']['next_page_url'];
      for(var val in data){
        storeList.add(StoreModel.fromJson(val));
      }



    }
    wait.value = false;
    update();
  }

  // جلب المتاجر حسب التصنيف
  Future<void> fetchStoresByCategory(int categoryId,{int page=1}) async {
    wait.value = true;
    final response = await ApiConnect().getData('stores/category/$categoryId?page=$page');
    if (response.statusCode == 200) { var data =
    jsonDecode(response.body)['stores']['data'];
    hasMode = jsonDecode(response.body)['stores']['next_page_url'];
    for(var val in data){
      storeList.add(StoreModel.fromJson(val));
    }
    }
    wait.value = false;
    update();
  }

  // جلب المتاجر حسب المنطقة
  Future<void> fetchStoresByRegion(int regionId,{int page=1}) async {
    wait.value = true;
    final response =
    await ApiConnect().getData('regions/$regionId/get-stores?page=$page',);
    if (response.statusCode == 200) { var data =
    jsonDecode(response.body)['stores']['data'];
    hasMode = jsonDecode(response.body)['stores']['next_page_url'];
    for(var val in data){
      storeList.add(StoreModel.fromJson(val));
    }
    }
    wait.value = false;
    update();
  }

  Future<void> fetchStoresByCategoryAndRegion(
      int categoryId, int regionId,{int page=1}) async {
    wait.value = true;

    final response = await ApiConnect()
        .getData('stores/category/$categoryId/region/$regionId?page=$page');
    if (response.statusCode == 200) { var data =
    jsonDecode(response.body)['stores']['data'];
    hasMode = jsonDecode(response.body)['stores']['next_page_url'];
    for(var val in data){
      storeList.add(StoreModel.fromJson(val));
    }
    }
    wait.value = false;
    update();
  }

  Future<void> getAllCategories() async {
    waitCategories.value = true;
    final response = await ApiConnect().getData('all-categories');
    if (response.statusCode == 200) {
      categoryList = List<ListModel>.from(
        jsonDecode(response.body)['data']
            .map((category) => ListModel.fromJson(category)),
      );
    }
    waitCategories.value = false;
    update();
  }

  Future<void> getRegions() async {
    waitRegions.value = true;
    final response = await ApiConnect().getData('regions');
    if (response.statusCode == 200) {
      regionsList = List<ListModel>.from(
        jsonDecode(response.body)['data']
            .map((region) => ListModel.fromJson(region)),
      );
    }
    waitRegions.value = false;
    update();
  }
}
