import 'package:delivary/core/api_connect.dart';
import 'package:delivary/presentation/user/orders/model/order_user_model.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class OrderController extends GetxController {
  List<OrderUserModel> orderList = [];
  bool waitOrder = true;

  // دالة لجلب البيانات من API
  Future<void> fetchOrders() async {
    // final url = Uri.parse('https://northdeliveryservices.com/api/get-user-orders');
    try {
      final response = await ApiConnect().getData('get-user-orders');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // استخراج البيانات من الرد
        final ordersData = responseData['orders']['data'] as List;

        // تحويل البيانات إلى قائمة من OrderUserModel
        orderList = ordersData.map((order) => OrderUserModel.fromJson(order)).toList();

        waitOrder = false;  // بيانات تم تحميلها، تغيير حالة الانتظار
        update();  // تحديث واجهة المستخدم
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      waitOrder = false;
      update();
    }
  }
}
