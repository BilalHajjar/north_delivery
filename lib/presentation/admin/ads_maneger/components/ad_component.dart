import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/admin/ads_maneger/controller/ads_controller.dart';
import 'package:delivary/presentation/admin/ads_maneger/model/ads_model.dart';
import 'package:delivary/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdsComponent extends StatelessWidget {
  AdsComponent({super.key, required this.ad});

  final AdsModel ad;
  AdsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.whiteColor,
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: CustomImage(image: ad.imageUrl ?? '')),
            ),
            ListTile(
              title: Text(ad.isActive == 1 ? 'نشط' : 'غير نشط'),
              subtitle: Text('تاريخ: ${ad.createdAt!.substring(0, 10)}'),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'edit') {
                  } else if (value == 'delete') {
                    controller.deleteAd(ad.id!, context);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    onTap: () {
                      controller.toggleAdStatus(ad.id!,context);
                    },
                    child: Text('تغيير الحالة'),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      controller.deleteAd(ad.id!, context);
                    },
                    value: 'delete',
                    child: Text('حذف'),
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

void showAdDialog(BuildContext context) {
  // final TextEditingController imageController = TextEditingController();
  AdsController controller = Get.find();
  showDialog(
    context: context,
    builder: (context) {
      controller.imagePath = null;
      return AlertDialog(
        title: const Text('إضافة إعلان جديد'),
        content: GetBuilder<AdsController>(builder: (logic) {
          if (logic.imagePath == null) {
            return ElevatedButton(
                onPressed: () {
                  controller.pickImageFromGallery();
                },
                child: Text('حمل الصورة'));
          } else {
            return SingleChildScrollView(
                child: Center(child: Text('تم التحميل بنجاح')));
          }
        }),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              controller.addAd(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      );
    },
  );
}
