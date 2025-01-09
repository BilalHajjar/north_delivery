import 'package:delivary/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:delivary/presentation/store_owner/products/model/product_model.dart';

import '../components/add_to_card_item.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name ?? "تفاصيل المنتج"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                // الصورة مع تأثير Hero
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    height: 250,

                    child: CustomImage(image:product.imageUrl!,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
            
                // اسم المنتج
                Text(
                  product.name ?? "اسم المنتج",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
            
                // السعر
                Text(
                  'LT ${product.price ?? "0"}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
            
                // وصف المنتج
                Text(
                  product.description ?? "وصف المنتج غير متوفر.",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                // AddToCardItem(productModel: product,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
