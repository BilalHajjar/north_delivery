import 'package:delivary/presentation/store_owner/products/controller/product_controller.dart';
import 'package:delivary/presentation/store_owner/products/model/product_model.dart';
import 'package:delivary/presentation/store_owner/products/screens/add_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProductController controller = Get.put(ProductController());
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(AddProductScreen());
        },
        label: const Text('إضافة منتج'),
      ),
      body: Obx(() {
        if (controller.isLoading.value&&controller.currentPage==1) {
          return const Center(child: CircularProgressIndicator());
        }
        return Directionality(
          textDirection: TextDirection.rtl,
          child: ListView.builder(
            controller: controller.scroll,
            itemCount: controller.productList.length+1,
            itemBuilder: (BuildContext context, int index) {
                if(index<controller.productList.length) {
              return InkWell(
                  onTap: () {
                    Get.to(AddProductScreen(
                      productModel: controller.productList[index],
                    ));
                  },
                  child:
                      ProductCard(productModel: controller.productList[index]));
               } else {
                  if(controller.hasMode==null)
                    return SizedBox();
                  else
                  return Center(child: CircularProgressIndicator(),);
                }
            },
          ),
        );
      }),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel productModel;

  ProductCard({
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عرض الصورة
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: '${productModel.id}' ?? 'defaultTag', // استخدم معرف المنتج كـ Hero Tag
                child: Image.network(
                  '${productModel.imageUrl!}',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // الصورة تم تحميلها بالكامل
                    }
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.grey.withOpacity(0.5),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null, // مؤشر مع نسبة التحميل
                        ),
                      ),
                    );
                  },
                  errorBuilder: (con, ob, t) {
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.grey.withOpacity(0.5)),
                      child: const Center(
                          child: Icon(
                            Icons.image_search,
                            size: 30,
                          )),
                    );
                  },
                ),
              ),
            ),


            const SizedBox(width: 16),
            // عرض التفاصيل
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المنتج
                  Text(
                    productModel.name!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // الوصف
                  Text(
                    productModel.description!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // السعر
                  Text(
                    'LT ' + productModel.price!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // حالة التوفر
                  Text(
                    productModel.isAvailable == 1 ? 'متوفر' : 'غير متوفر',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: productModel.isAvailable == 1
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
