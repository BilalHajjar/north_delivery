import 'package:delivary/core/not_found.dart';
import 'package:delivary/presentation/admin/orders/model/order_admin_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../components/order_component.dart';
import '../controller/order_admin_controller.dart';

class OrderAdminScreen extends StatelessWidget {
  const OrderAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderAdminController());
    controller.fetchOrders(); // تحميل الطلبات عند فتح الشاشة

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {  
          return const NotFound(txt: 'لا توجد طلبات حالياً.');
        }

        return RefreshIndicator(
          onRefresh: controller.fetchOrders, // التحديث عند السحب للأسفل
          child: ListView.builder(
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              return OrderComponent(order: order, controller: controller);
            },
          ),
        );
      }),
    );
  }
}

