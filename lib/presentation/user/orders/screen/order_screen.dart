import 'package:delivary/core/not_found.dart';
import 'package:delivary/presentation/user/orders/model/order_user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivary/presentation/user/orders/controller/order_controller.dart';

import '../components/order_user_component.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrderController controller = Get.put(OrderController());
    controller.fetchOrders();  // استدعاء الدالة لجلب البيانات عند تحميل الشاشة

    return GetBuilder<OrderController>(
      builder: (controller) {
        if (controller.waitOrder) {
          return Center(child: CircularProgressIndicator());  // أثناء التحميل
        } else if (controller.orderList.isEmpty) {
          return NotFound(txt: 'لا يوجد طلبات');  // في حالة لا توجد بيانات
        }
        // عرض قائمة الطلبات
        return Directionality(textDirection: TextDirection.rtl,
          child: ListView.builder(
            itemCount: controller.orderList.length,
            itemBuilder: (context, index) {
              final order = controller.orderList[index];
              return OrderUserComponent(order: order);
            },
          ),
        );
      },
    );
  }
}


