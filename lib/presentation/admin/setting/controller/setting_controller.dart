import 'dart:convert';

import 'package:delivary/core/api_connect.dart';
import 'package:delivary/presentation/admin/setting/model/setting_model.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  RxBool loadingPut=false.obs;
  RxBool waitSetting=true.obs;
  @override
  onInit(){
    getSetting();
    super.onInit();
  }
  SettingModel? settingModel;
 void putSetting(context, {required String phone, required String facebook}) async {
    loadingPut.value=true;
    try{
    await ApiConnect()
        .putData('settings', {
      if(phone!='')
          "phone": phone,
      if(facebook!='')
      "facebook": facebook}).then((val) {
      if (val.statusCode == 200 || val.statusCode == 201) {
        showErrorSnackbar(context, 'تم التعديل بنجاح');
      } else {
        showErrorSnackbar(context, '${jsonDecode(val.body)['errors']}');
      }
    });}catch(e){
      showErrorSnackbar(context, 'تحقق من اتصالك بالشبكة');

    }finally{
      loadingPut.value=false;
    }
  }
  void getSetting()async {
    waitSetting.value = true;
    try {

      final response = await ApiConnect().getData('settings');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        settingModel =
            SettingModel.fromJson(data);
      } else {
        Get.snackbar('خطأ', jsonDecode(response.body)['message']);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر جلب الإعلانات. تحقق من اتصال الشبكة.');
    } finally {
      waitSetting.value = false;
    }
  }

}
