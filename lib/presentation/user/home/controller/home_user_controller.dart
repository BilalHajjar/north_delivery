import 'dart:convert';

import 'package:delivary/core/api_connect.dart';
import 'package:delivary/presentation/admin/ads_maneger/model/ads_model.dart';
import 'package:delivary/presentation/admin/store/model/store_model.dart';
import 'package:delivary/presentation/auth/screens/login_screens.dart';
import 'package:get/get.dart';
import '../../../admin/store/model/list_model.dart';
class HomeUserController extends GetxController {
  List<AdsModel> adsList = [];
  List<CategoryModel> categoryList = [];
  List<StoreModel> storeList = [];
  bool isAuth=true;
  bool isLoading = false;
  ListModel? tempForMySelectCategory;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }  RxInt current = 1.obs;

  void changePage(int index) {
    current.value = index;
  }

  Future<void> loadData() async {
    isLoading = true;
    update();
    await Future.wait([getAds(), getAllProduct(), getAllStores()]);
    isLoading = false;
    update();
  }

  Future<void> getAllStores() async {
    try {
      var response = await ApiConnect().getData('all-stores');
      if (response.statusCode == 200) {
        var stores = jsonDecode(response.body)['stores']['data'];
        storeList = stores
            .map<StoreModel>((store) => StoreModel.fromJson(store))
            .toList();
      }
    } catch (e) {
    }
  }

  Future<void> getAds() async {
    try {
      var response = await ApiConnect().getData('get-active-ads');
      if (response.statusCode == 200) {
        var ads = jsonDecode(response.body)['data'];
        adsList = ads.map<AdsModel>((ad) => AdsModel.fromJson(ad)).toList();
      }
    } catch (e) {
    }
  }

  Future<void> getAllProduct() async {
    try {

      var response = await ApiConnect().getData('all-categories');

      if (response.statusCode == 200) {
        var products = jsonDecode(response.body)['data'];
        categoryList = products
            .map<CategoryModel>((product) => CategoryModel.fromJson(product))
            .toList();
      }else if(jsonDecode(response.body)['message']=='لم يتم تأكيد عنوان بريدك الإلكتروني.'){
isAuth=false;
update();
      }else if(jsonDecode(response.body)['message']=='ليس لديك الصلاحية المطلوبة.'){
        Get.offAll(LoginScreens());
      }
    } catch (e) {
    }
  }
}
