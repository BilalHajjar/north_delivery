import 'package:delivary/core/not_found.dart';
import 'package:delivary/presentation/user/stores/controller/stores_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/colors.dart';
import '../../../../widgets/out_line_button.dart';
import '../../../admin/store/screens/store_screen.dart';
import '../../product/screen/product_user_screen.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AllStoresController controller = Get.put(AllStoresController());
    final RxBool showFilters = false.obs; // للتحكم في إظهار الفلاتر

    return Directionality(textDirection: TextDirection.rtl,
      child: Column(
        children: [
          // زر إظهار/إخفاء الفلاتر
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
          // الفلاتر مع حركة إظهار/إخفاء

    Obx(() => AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut, // إضافة منحنى لزيادة سلاسة الأنيميشن
    height: showFilters.value ? 220 : 0, // استخدم ارتفاعاً محدداً بدلاً من null
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
                scrollDirection: Axis.horizontal, // جعل التمرير أفقياً
                child: Row(
                  children: controller.categoryList.map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0), // إضافة مسافة صغيرة بين العناصر
                      child: ChoiceChip(
                        label: Text(
                          category.name!,
                          style: TextStyle(
                            color: controller.selectedCategory.value == category
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: controller.selectedCategory.value == category,
                        onSelected: (selected) {
                          controller.selectedCategory.value = selected ? category : null;
                        },
                        backgroundColor: Colors.grey.shade200,
                        selectedColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 2,
                      ),
                    );
                  }).toList(),
                ),
              )
;
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
                children: controller.regionsList.map((region) {
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
                    controller.selectedRegion.value == region,
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
                  if (controller.selectedCategory.value == null &&
                      controller.selectedRegion.value == null) {
                    controller.getAllStores(); // جلب كل البيانات
                  } else {
                    controller.applyFilters(); // تطبيق الفلاتر إذا كانت محددة
                  }
                  showFilters.value = false; // إخفاء الفلاتر بعد الضغط
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
                if (controller.wait == true) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (controller.storeList.isEmpty) {
                  return NotFound(txt: 'لا يتوفر متاجر');
                }
                return ListView.builder(
                  itemCount: controller.storeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final store = controller.storeList[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ProductUserScreen(store: store));
                      },
                      child: StoreComponent(store: store),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
