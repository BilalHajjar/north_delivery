import 'package:delivary/core/api_connect.dart';
import 'package:delivary/presentation/user/orders/model/order_user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class OrderController extends GetxController {
  List<OrderUserModel> orderList = [];
  bool waitOrder = true;
  String? hasMode;
  int currentPage=1;
  final scroll=ScrollController();
  onInit(){
 fetchOrders();
  super.onInit();
    scroll.addListener((){
      if(scroll.position.maxScrollExtent==scroll.offset){

        int page=++currentPage;
        fetchOrders(page: page++);
      }});
  }
  // دالة لجلب البيانات من API
  Future<void> fetchOrders({int page=1}) async {
    // final url = Uri.parse('https://northdeliveryservices.com/api/get-user-orders');
    try {
      final response = await ApiConnect().getData('get-user-orders?page=$page');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final ordersData = responseData['orders']['data'] as List;



        for(var val in ordersData){
          orderList.add(OrderUserModel.fromJson(val));
        }
        hasMode = jsonDecode(response.body)['orders']['next_page_url'];
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
