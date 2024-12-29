import 'package:flutter/material.dart';

import '../../../../core/colors.dart';
import '../../../admin/store/model/store_model.dart';

class CategoryUserComponent extends StatelessWidget {
  const CategoryUserComponent({super.key,required this.categoryModel});
  final CategoryModel categoryModel;

  @override
  Widget build(BuildContext context) {

    return Card(
      color: AppColors.whiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft:Radius.circular(12) ,topRight:Radius.circular(12) ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  categoryModel.imageUrl ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          // const SizedBox(height: 8),
          Padding(
            padding:EdgeInsets.symmetric(vertical: 1),
            child: Text(
              categoryModel.name ?? 'Unknown',
              style: const TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
