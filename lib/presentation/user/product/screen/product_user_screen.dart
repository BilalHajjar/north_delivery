import 'package:delivary/presentation/store_owner/products/controller/product_controller.dart';
import 'package:delivary/presentation/store_owner/products/screens/products_screen.dart';
import 'package:delivary/presentation/user/product/controller/product_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/colors.dart';
import '../../../admin/store/model/store_model.dart';
import '../../cart/screen/cart_screen.dart';
import '../components/product_user_component.dart';

class ProductUserScreen extends StatelessWidget {
  ProductUserScreen({
    super.key,
    required this.store,
  });

  final StoreModel store;
  final ProductUserController controller = Get.put(ProductUserController());

  @override
  Widget build(BuildContext context) {
    // استدعاء `getAllProduct` مرة واحدة عند بدء الصفحة
    controller.getAllProduct(store.id!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaColor,
        title: Text(store.name ?? "تفاصيل المتجر"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // الانتقال إلى السلة
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // عرض تفاصيل المتجر
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عرض الصورة مع تأثير Hero
                    Hero(
                      tag: 'store-${store.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          store.imageUrl!,
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
        
                    // اسم المتجر
                    Text(
                      store.name ?? "اسم المتجر",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
        
                    // وصف المتجر
                    if (store.description != null)
                      Text(
                        store.description!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 8),
        
                    // الموقع
                    if (store.region != null)
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            store.region!.name ?? "الموقع غير متوفر",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
        
                    // التصنيفات
                    if (store.categories != null && store.categories!.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: store.categories!.map((category) {
                          return Chip(
                            label: Text(category.name ?? "بدون اسم"),
                            backgroundColor: AppColors.primaColor.withOpacity(0.2),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
        
            // قائمة المنتجات
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Obx(() {
                  if (controller.waitProduct.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
        
                  if (controller.productList.isEmpty) {
                    return const Center(
                      child: Text(
                        "لا توجد منتجات متوفرة حاليًا.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
        
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //   crossAxisCount: 2,
                      //   crossAxisSpacing: 10,
                      //   mainAxisSpacing: 10,
                      //   childAspectRatio: 0.8,
                      // ),
                      itemCount: controller.productList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductUserComponent(
                          productModel: controller.productList[index],
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
