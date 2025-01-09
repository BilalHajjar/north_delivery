import 'package:delivary/core/not_found.dart';
import 'package:delivary/presentation/user/stores/controller/stores_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/out_line_button.dart';
import '../../../admin/store/model/list_model.dart';
import '../../../admin/store/screens/store_screen.dart';
import '../../home/controller/home_user_controller.dart';
import '../../product/screen/product_user_screen.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AllStoresController controller = Get.put(AllStoresController());
    HomeUserController homeController = Get.find<HomeUserController>();
    final RxBool showFilters = false.obs;
    if (homeController.tempForMySelectCategory != null) {
      controller.storeList.clear();
      controller.selectedCategory.value =
          homeController.tempForMySelectCategory;
      WidgetsBinding.instance.addPostFrameCallback((_) {

        controller.applyFilters();
      });
    }
    if (homeController.tempForMySelectCategory == null) {
    controller.getAllStores();
    }
    return WillPopScope(
      onWillPop: ()async {
        homeController.changePage(1);  return false;    },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'تصفية المتاجر',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Obx(() => Icon(
                          showFilters.value
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        )),
                    onPressed: () {
                      showFilters.value = !showFilters.value;
                    },
                  ),
                ],
              ),
            ),

            Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: showFilters.value ? 220 : 0,
                  child: showFilters.value
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'تصفية حسب التصنيفات:',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Obx(() {
                                  if (controller.waitCategories.value) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    // جعل التمرير أفقياً
                                    child: Row(
                                      children:
                                          controller.categoryList.map((category) {
                                        if (homeController
                                                .tempForMySelectCategory !=
                                            null) {
                                          for (ListModel val
                                              in controller.categoryList) {
                                            if (val.id ==
                                                homeController
                                                    .tempForMySelectCategory!
                                                    .id!) {
                                              controller.selectedCategory.value =
                                                  val;
                                            }
                                          }
                                        }
                                        homeController.tempForMySelectCategory =
                                            null;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          // إضافة مسافة صغيرة بين العناصر
                                          child: ChoiceChip(
                                            label: Text(
                                              category.name!,
                                              style: TextStyle(
                                                color: controller.selectedCategory
                                                            .value ==
                                                        category
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            selected: controller
                                                    .selectedCategory.value ==
                                                category,
                                            onSelected: (selected) {
                                              controller.selectedCategory.value =selected ? category : null;
                                            },
                                            backgroundColor: Colors.grey.shade200,
                                            selectedColor: Colors.teal,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            elevation: 2,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 10),
                                const Text(
                                  'تصفية حسب المناطق:',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Obx(() {
                                  if (controller.waitRegions.value) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  return Wrap(
                                    spacing: 8,
                                    // runSpacing: 8,
                                    children:
                                        controller.regionsList.map((region) {
                                      return ChoiceChip(
                                        label: Text(
                                          region.name!,
                                          style: TextStyle(
                                            color:
                                                controller.selectedRegion.value ==
                                                        region
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                        selected:
                                            controller.selectedRegion.value ==
                                                region,
                                        onSelected: (selected) {
                                          controller.selectedRegion.value =
                                              selected ? region : null;
                                        },
                                        backgroundColor: Colors.grey.shade200,
                                        selectedColor: Colors.teal,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        elevation: 2,
                                      );
                                    }).toList(),
                                  );
                                }),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: OutLineButton(
                                    func: () {
                                      // التحقق إذا لم يتم تحديد أي فلتر
                                      if (controller.selectedCategory.value ==
                                              null &&
                                          controller.selectedRegion.value ==
                                              null) {
                                        controller
                                            .getAllStores(); // جلب كل البيانات
                                      } else {
                                        controller
                                            .applyFilters(); // تطبيق الفلاتر إذا كانت محددة
                                      }
                                      showFilters.value =
                                          false; // إخفاء الفلاتر بعد الضغط
                                    },
                                    icn: Icons.filter_list,
                                    text: 'تطبيق الفلاتر',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : null, // عند الإخفاء، استخدم null بدلاً من SizedBox.shrink()
                )),
            const Divider(),
            // عرض قائمة المتاجر
            Expanded(
              child: GetBuilder<AllStoresController>(
                init: AllStoresController(),
                builder: (controller) {
                  if (controller.wait == true && controller.currentPage == 1) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (controller.storeList.isEmpty) {
                    return const NotFound(txt: 'لا يتوفر متاجر');
                  }
                  return ListView.builder(
                    controller: controller.scroll,
                    itemCount: controller.storeList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < controller.storeList.length) {
                        final store = controller.storeList[index];
                        return GestureDetector(
                            onTap: (){
                              Get.to(() => ProductUserScreen(  store: store, ));
                            },
                            child: StoreComponent(store: store));
                      } else {
                        if (controller.hasMode == null) {
                          return const SizedBox();
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
