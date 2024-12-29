import 'dart:convert';

import 'package:delivary/presentation/admin/store/model/list_model.dart';
import 'package:delivary/presentation/admin/store/model/store_model.dart';
import 'package:get/get.dart';

import '../../../../core/api_connect.dart';

class AllStoresController extends GetxController {
  // الخصائص
  List<StoreModel> storeList = [];
  List<ListModel> categoryList = [];
  List<ListModel> regionsList = [];
  var selectedCategory = Rxn<ListModel>();
  var selectedRegion = Rxn<ListModel>();
  var waitCategories = true.obs;
  var waitRegions = false.obs;
  var wait = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  // جلب البيانات الأولية عند بدء التشغيل
  void fetchInitialData() {
    getAllStores();
    getAllCategories();
    getRegions();
  }

  // تطبيق الفلاتر
  Future<void> applyFilters() async {
    wait.value = true;
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
  Future<void> getAllStores() async {
    wait.value = true;
    final response = await ApiConnect().getData('all-stores');
    if (response.statusCode == 200) {
      storeList = List<StoreModel>.from(
        jsonDecode(response.body)['stores']['data']
            .map((store) => StoreModel.fromJson(store)),
      );
    }
    wait.value = false;
    update();
  }

  // جلب المتاجر حسب التصنيف
  Future<void> fetchStoresByCategory(int categoryId) async {
    wait.value = true;
    storeList.clear();
    final response = await ApiConnect().getData('stores/category/$categoryId');
    if (response.statusCode == 200) {
      storeList = List<StoreModel>.from(
        jsonDecode(response.body)['stores']['data']
            .map((store) => StoreModel.fromJson(store)),
      );
    }
    wait.value = false;
    update();
  }

  // جلب المتاجر حسب المنطقة
  Future<void> fetchStoresByRegion(int regionId) async {
    wait.value = true;
    storeList.clear();
    final response =
    await ApiConnect().getData('regions/$regionId/get-stores');
    if (response.statusCode == 200) {
      storeList = List<StoreModel>.from(
        jsonDecode(response.body)['stores']['data']
            .map((store) => StoreModel.fromJson(store)),
      );
    }
    wait.value = false;
    update();
  }

  // جلب المتاجر حسب التصنيف والمنطقة
  Future<void> fetchStoresByCategoryAndRegion(
      int categoryId, int regionId) async {
    wait.value = true;
    storeList.clear();
    final response = await ApiConnect()
        .getData('stores/category/$categoryId/region/$regionId');
    if (response.statusCode == 200) {
      storeList = List<StoreModel>.from(
        jsonDecode(response.body)['stores']['data']
            .map((store) => StoreModel.fromJson(store)),
      );
    }
    wait.value = false;
    update();
  }

  // جلب التصنيفات
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

  // جلب المناطق
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
