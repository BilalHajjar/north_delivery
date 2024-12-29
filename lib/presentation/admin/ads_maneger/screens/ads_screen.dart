import 'package:delivary/presentation/admin/ads_maneger/components/ad_component.dart';
import 'package:delivary/presentation/admin/ads_maneger/controller/ads_controller.dart';
import 'package:delivary/presentation/admin/ads_maneger/model/ads_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdsScreen extends StatelessWidget {
  AdsScreen({super.key});

  final AdsController controller = Get.put(AdsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('إدارة الإعلانات'),
      //   centerTitle: true,
      //
      // ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => showAdDialog(context), label: Text('إضافة إعلان'),),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.adsList.isEmpty) {
          return const Center(child: Text('لا توجد إعلانات حاليًا'));
        } else {
          return ListView.builder(
            itemCount: controller.adsList.length,
            itemBuilder: (context, index) {
              final ad = controller.adsList[index];
              return AdsComponent( ad: ad,);
            },
          );
        }
      }),
    );
  }



}
