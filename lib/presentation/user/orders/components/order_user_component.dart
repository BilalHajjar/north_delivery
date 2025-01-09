import 'dart:convert';

import 'package:delivary/core/api_connect.dart';
import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/user/cart/model/card_model.dart';
import 'package:delivary/presentation/user/orders/model/order_user_model.dart';
import 'package:delivary/widgets/custom_image.dart';
import 'package:flutter/material.dart';

class OrderUserComponent extends StatefulWidget {
  const OrderUserComponent({
    super.key,
    required this.order,
  });

  final OrderUserModel order;

  @override
  _OrderUserComponentState createState() => _OrderUserComponentState();
}

class _OrderUserComponentState extends State<OrderUserComponent> {
  bool _expanded = false; // الحالة لتتبع ما إذا كان الحاوية موسعة أو لا
  List<CardModel> cardList = [];
 late IconData icon;
 late Color iconColor;
  String status = '';
  getDetails() async {
    cardList = [];
    await ApiConnect().getData('get-order-details/${widget.order.id}').then((val) {
      if (val.statusCode == 200 || val.statusCode == 201) {
        for (var item in jsonDecode(val.body)['order']['order_items']) {
          cardList.add(CardModel.fromJson(item));
        }
        setState(() {
          _expanded = !_expanded;
        });
      } else {
        appErrorMessage(context, jsonDecode(val.body)['message']);
      }
    });
  }
  @override
  Widget build(BuildContext context) {


    // تحديد الأيقونة ولون الأيقونة بناءً على الحالة
    switch (widget.order.status) {
      case 'pending':
        icon = Icons.access_time;
        iconColor = Colors.deepOrange;
        status = 'قيد الانتظار';
        break;
      case 'processing':
        icon = Icons.autorenew;
        iconColor = Colors.blue;
        status = 'قيد المعالجة';
        break;
      case 'completed':
        icon = Icons.check_circle;
        iconColor = Colors.green;
        status = 'مكتمل';
        break;
      case 'canceled':
        icon = Icons.cancel;
        iconColor = Colors.red;
        status = 'ملغي';
        break;
      default:
        icon = Icons.help_outline; // في حال كانت الحالة غير معروفة
        iconColor = Colors.grey;
    }


    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text('رقم الطلب #${widget.order.id}'),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('الاجمالي: \$${widget.order.totalPrice}'),
                Row(
                  children: [
                    Icon(icon, color: iconColor, size: 13),
                    Text('  الحالة: ${status}'),
                  ],
                ),
              ],
            ),
            trailing: Icon(
              !_expanded ? Icons.keyboard_arrow_left_sharp : Icons.keyboard_arrow_down_outlined,
              color: AppColors.grey,
            ),
            onTap: () {
              !_expanded?  getDetails():
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
          // إذا كانت الحاوية موسعة، قم بعرض المزيد من البيانات
          AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 150), // مدة التمدد البطيء
            height: _expanded ? 120 + (cardList.length * 80).toDouble() : 0, // إضافة مساحة للعناصر المحملة
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('العنوان: ${widget.order.address}'),
                  Text('الملاحظات: ${widget.order.notes ?? 'لا توجد ملاحظات'}'),
                  SizedBox(height: 10),
                  // عرض العناصر المحملة في القائمة
                  ...cardList.map((card) {
                    return Card(
                      color: Color(0xfffdf9ed),
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: SizedBox(
                            width: 50,

                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CustomImage(image: card.product!.imageUrl!))),
                        title: Text(card.product?.name ?? 'منتج غير معروف'),
                        subtitle: Text('الكمية: ${card.quantity}'),
                        trailing: Text('\$${card.product?.price}'),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
