import 'package:delivary/widgets/custom_image.dart';
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
            child: SizedBox(width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft:Radius.circular(12) ,topRight:Radius.circular(12) ),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: CustomImage(image:  categoryModel.imageUrl ?? '',
                  ),
                ),
              ),
            ),
          ),
          // const SizedBox(height: 8),
          Padding(
            padding:EdgeInsets.symmetric(vertical: 1),
            child: Text(
              categoryModel.name ?? 'غير موجود',
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
