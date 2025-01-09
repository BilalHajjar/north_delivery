import 'dart:convert';
import 'dart:io';

import 'package:delivary/core/api_connect.dart';
import 'package:delivary/presentation/admin/store/controller/store_controller.dart';
import 'package:delivary/presentation/admin/store/model/list_model.dart';
import 'package:delivary/presentation/admin/store/model/store_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddStoreController extends GetxController {
  List<User> userWithoutStoreList = [];
  User? selectUserWithoutStore;
  List<ListModel> regionsList = [];
  ListModel? selectedRegion;
  List<CategoryModel> categoriesList = [];
  List<CategoryModel> selectedCategories = []; // قائمة الفئات المحددة
  @override
  onInit() {
    super.onInit();
    getUserWithoutStore();
    getRegions();
    getCategories();
  }

  RxInt wait = 0.obs;

  getUserWithoutStore() async {
    await ApiConnect().getData('store-owners/available').then((val) {
      for (var value in jsonDecode(val.body)['data']) {
        userWithoutStoreList.add(User.fromJson(value));
      }
      wait.value++;
    });
  }

  getRegions() async {
    await ApiConnect().getData('regions').then((val) {
      for (var value in jsonDecode(val.body)['data']) {
        regionsList.add(ListModel.fromJson(value));
      }
      wait.value++;
    });
  }

  getCategories() async {
    await ApiConnect().getData('categories').then((val) {
      for (var value in jsonDecode(val.body)['data']) {
        categoriesList.add(CategoryModel.fromJson(value));
      }
      wait.value++;
    });
  }

  addCategories(String name,File image) async {
    wait.value--;
    await ApiConnect().postDataFile('categories', {'name': '$name'},file: image).then((val) {
      if(val.statusCode==201) {
        imagePath=null;
        categoriesList.add(
            CategoryModel(name: name, id: jsonDecode(val.body)['data']['id']));
        Get.back();
      }
      update();
      wait.value++;
    });
  }

  updateCategories(String name, int id,File? file) async {
    wait.value--;
    if(file==null) {
      await ApiConnect().postData(
          'categories/$id?_method=PUT', {'name': '$name'}).then((val) {
        int index = categoriesList.indexWhere((category) => category.id == id);
        if (index != -1) { imagePath=null;
          categoriesList[index] =
              CategoryModel(name: name, id: id); // تحديث العنصر مباشرة
        }update();
        Get.back();
        wait.value++;
      });
    }
    else{
      await ApiConnect().postDataFile(
          'categories/$id?_method=PUT', {'name': '$name'},file: file!).then((val) {
        int index = categoriesList.indexWhere((category) => category.id == id);
        if (index != -1) { imagePath=null;
          categoriesList[index] =
              CategoryModel(name: name, id: id); // تحديث العنصر مباشرة
        }update();
        Get.back();
        wait.value++;
      });
    }
  }

  deleteCategories(int id) async {
    wait.value--;
    await ApiConnect().deleteData('categories/$id').then((val) {
      int index = categoriesList.indexWhere((category) => category.id == id);
      if (index != -1) {
        categoriesList.removeAt(index); // حذف العنصر من القائمة
      }
      Get.back();
      wait.value++;
    });
  }

  RxBool loadingAdd = false.obs;

  addStore(
    context, {
    required String name,
    required String description,
    required int userId,
    required int regionIid,
         File? file,
    required List<int> categories,
    required StoreController controller,
  }) async {
    loadingAdd.value = true;
    await ApiConnect().postDataFile('stores', {
      "name": name,
      "description": description,
      "user_id": userId,
      "region_id": regionIid,
      "categories": categories
    },file: file).then((val) {
      if (val.statusCode == 201||val.statusCode == 200||val.statusCode == 202) {
        controller.getStores(page: 1);
        loadingAdd.value = false;Get.back();
      } else {
        appErrorMessage(context, jsonDecode(val.body)['message']);
      }
    });loadingAdd.value=false;
  }

  updateStore(
    context, {
    required String name,
    required String description,
    required int userId,
    required int regionIid,
         File? file,
    required List<int> categories,
    required StoreController controller,
  }) async {
    loadingAdd.value = true;
    if(file==null)
      { await ApiConnect().postData('stores/$userId?_method=PUT', {
        "name": name,
        "description": description,
        // "user_id": userId,
        "region_id": regionIid,
        "categories": categories
      },
          ).then((val) {
        if (val.statusCode == 201||val.statusCode == 200||val.statusCode == 202) {
          controller.getStores(page: 1);
          loadingAdd.value = false;Get.back();
        } else {
          appErrorMessage(context, jsonDecode(val.body)['errors']);
        }
      });

      }else {
      await ApiConnect().postDataFile('stores/$userId?_method=PUT', {
      "name": name,
      "description": description,
      // "user_id": userId,
      "region_id": regionIid,
      "categories": categories
    },
        file: file).then((val) {
      if (val.statusCode == 201||val.statusCode == 200||val.statusCode == 202) {
        controller.getStores(page: 1);
        loadingAdd.value = false;Get.back();
      } else {
        appErrorMessage(context, jsonDecode(val.body)['errors']);
      }
    });
    }
    loadingAdd.value=false;
  }
  File? imagePath; // مسار الصورة
  final ImagePicker picker = ImagePicker(); // مخصص لاختيار الصور

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
