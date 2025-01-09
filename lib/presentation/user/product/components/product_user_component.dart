import 'dart:convert';
import 'dart:io';

import 'package:delivary/core/api_connect.dart';
import 'package:delivary/presentation/store_owner/products/controller/product_controller.dart';
import 'package:delivary/presentation/store_owner/products/model/product_model.dart';
import 'package:delivary/presentation/user/product/controller/product_user_controller.dart';
import 'package:delivary/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/colors.dart';
import '../screen/product_details_screen.dart';
import 'add_to_card_item.dart';

class ProductUserComponent extends StatelessWidget {
  final ProductModel productModel;

  ProductUserComponent({
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    ProductUserController controller = Get.put(ProductUserController());
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailsScreen(product: productModel));
      },
      child: Card(
        color: AppColors.whiteColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عرض الصورة مع banner إذا كان غير متوفر
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      ColorFiltered(
                        colorFilter: productModel.isAvailable == 1
                            ? ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.multiply,
                              )
                            : ColorFilter.mode(
                                Colors.grey,
                                BlendMode.saturation,
                              ),
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: CustomImage(image: productModel.imageUrl!,
                          ),
                        ),
                      ),
                      if (productModel.isAvailable != 1)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.red.withOpacity(0.8),
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: const Text(
                              'غير متوفر',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // عرض التفاصيل
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المنتج
                    Text(
                      productModel.name!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // الوصف
                    Text(
                      productModel.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // السعر
                    Text(
                      'LT ' + productModel.price!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AddToCardItem(
                      productModel: productModel,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
