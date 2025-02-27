import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/api_connect.dart';
import '../model/order_admin_model.dart';

class OrderAdminController extends GetxController {
  RxList<OrderAdminModel> orders = <OrderAdminModel>[].obs;
  RxBool isLoading = false.obs;
  int currentPage=1;
  final scroll=ScrollController();
  String? hasMode;
  onInit() {
    super.onInit();
    // fetchOrders();
    scroll.addListener((){
      if(scroll.position.maxScrollExtent==scroll.offset){

          int page=currentPage++;
          fetchOrders(page:page++);
    }});
  }
  // تحميل الطلبات
  Future<void> fetchOrders({int page=1}) async {
    try {
      isLoading.value = true;
      final response = await ApiConnect().getData('orders?page=$page');
      if(response.statusCode==200) {
        final List<dynamic> jsonData = jsonDecode(response.body)['orders']['data'];

        hasMode = jsonDecode(response.body)['orders']['next_page_url'];
        for(var ad in jsonData) {
          orders.add(OrderAdminModel.fromJson(ad));
        }
      }
      else{
        // Get.snackbar('خطأ', '${ jsonDecode(response.body)['message']}');

      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل الطلبات: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // تحديث حالة الطلب
  Future<void> updateOrderStatus(int orderId, String newStatus,context) async {
    try {
    var val=  await ApiConnect()
          .putData('orders/$orderId/status', {'status': newStatus});
      final index = orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        // إعادة إنشاء الكائن واستبداله
        final updatedOrder = OrderAdminModel(
          id: orders[index].id,
          address: orders[index].address,
          addressLink: orders[index].addressLink,
          notes: orders[index].notes,
          phoneNumber: orders[index].phoneNumber,
          status: newStatus, // تحديث الحالة
          totalPrice: orders[index].totalPrice,
          userId: orders[index].userId,
          createdAt: orders[index].createdAt,
          updatedAt: DateTime.now().toString(), // تحديث الوقت إذا لزم الأمر
          orderItemsCount: orders[index].orderItemsCount,
          user: orders[index].user,
          orderItems: orders[index].orderItems,
        );

        // استبدال الكائن في القائمة
        orders[index] = updatedOrder;
      }if(val.statusCode==201||val.statusCode==200){
      appErrorMessage(context, 'تم تعديل حالة الطلب بنجاح',title:  'تم');
    }
        else
      appErrorMessage(context, jsonDecode(val.body)['message']);
    } catch (e) {
      appErrorMessage(context, 'حدث خطأ غير متوقع');    }
  }


  // حذف الطلب
  Future<void> deleteOrder(int orderId,context) async {
    try {
      await ApiConnect().deleteData('orders/$orderId');
      orders.removeWhere((order) => order.id == orderId);
      appErrorMessage(context, 'تم حذف الطلب بنجاح');
    } catch (e) {
      appErrorMessage(context, 'فشل في حذف الطلب: $e');
    }
  }
}
