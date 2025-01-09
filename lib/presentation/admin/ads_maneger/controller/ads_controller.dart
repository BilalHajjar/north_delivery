import 'dart:convert';
import 'dart:io';
import 'package:delivary/core/api_connect.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/ads_model.dart';
import 'package:http/http.dart' as http;

class AdsController extends GetxController {
  RxList<AdsModel> adsList = <AdsModel>[].obs; // قائمة الإعلانات
  RxBool isLoading = false.obs; // حالة تحميل البيانات
  File? imagePath; // مسار الصورة
  final ImagePicker picker = ImagePicker(); // مخصص لاختيار الصور

  @override
  onInit() {
    fetchAds();
    super.onInit();
  }

  /// جلب قائمة الإعلانات
  Future<void> fetchAds({bool? isActive}) async {
    isLoading.value = true;
    try {
      String url = 'ads';
      // if (isActive != null) {
      //   url += '?is_active=${isActive ? 1 : 0}';
      // }
      final response = await ApiConnect().getData(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        adsList.value =
            data.map<AdsModel>((ad) => AdsModel.fromJson(ad)).toList();
      } else {

        Get.snackbar('خطأ', jsonDecode(response.body)['message']);
      }
    } catch (e) {
        Get.snackbar('خطأ', 'تعذر جلب الإعلانات. تحقق من اتصال الشبكة.');
    } finally {
      isLoading.value = false;
    }
  }

  /// إضافة إعلان جديد

  /// إضافة إعلان جديد
  Future<void> addAd(context) async {
    if (imagePath == null) {

      appErrorMessage(context, 'يرجى اختيار صورة قبل الإرسال.');
      return;
    }
   try {
      final response =
          await ApiConnect().postDataFile('ads', {}, file: imagePath);
      if (response.statusCode == 201) {
        Get.back();
        fetchAds();
      } else {
        appErrorMessage(context, '${jsonDecode(response.body)['message']}');
      }
    }catch(e){
    appErrorMessage(context, 'تحقق من اتصالك');

    }
  }

  /// تبديل حالة الإعلان (تفعيل/تعطيل)
  Future<void> toggleAdStatus(int adId,context) async {
    isLoading.value = true;
    try {
      final response =
          await ApiConnect().patchData('ads/$adId/toggle-status', {});
      if (response.statusCode == 200) {
        int index = adsList.indexWhere((ad) => ad.id == adId);
        if (adsList[index].isActive == 1) {
          adsList[index].isActive=0; // تحديث الإعلان في القائمة
        }
      else{
          adsList[index].isActive=1; // تحديث الإعلان في القائمة
        }
        appErrorMessage(context, 'تم تبديل حالة الإعلان بنجاح.',title: 'تم');

      } else {
        appErrorMessage(context, jsonDecode(response.body)['message']);

      }
    } catch (e) {
      appErrorMessage(context, 'تعذر تحديث حالة الإعلان. تحقق من اتصال الشبكة.');
    } finally {
      isLoading.value = false;
    }
  }

  /// حذف إعلان
  Future<void> deleteAd(int adId,context) async {
    isLoading.value = true;
    try {
      final response = await ApiConnect().deleteData('ads/$adId',);
      if (response.statusCode == 200) {
        adsList.removeWhere((ad) => ad.id == adId); // حذف الإعلان من القائمة
        appErrorMessage(context, 'تم حذف الإعلان بنجاح.');
      } else {
        appErrorMessage(context, jsonDecode(response.body)['message']);
      }
    } catch (e) {
      appErrorMessage(context, 'تعذر حذف الإعلان. تحقق من اتصال الشبكة.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery, // المصدر هو الاستوديو فقط
        imageQuality: 80, // اختيار جودة الصورة (اختياري)
      );

      if (image != null) {
        imagePath = File(image.path);

        // الصورة تم اختيارها بنجاح
        // يمكنك استخدام الصورة هنا أو تخزينها
      } else {
        // المستخدم لم يختار أي صورة
      }
    } catch (e) {
      // معالجة الأخطاء
    } finally {
      update();
    }
  }
}
