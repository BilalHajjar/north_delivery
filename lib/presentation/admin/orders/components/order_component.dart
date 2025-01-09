import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/admin/orders/controller/order_admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // إضافة مكتبة الحافظة

import '../model/order_admin_model.dart';

class OrderComponent extends StatefulWidget {
  const OrderComponent({
    super.key,
    required this.order,
    required this.controller,
  });

  final OrderAdminModel order;
  final OrderAdminController controller;

  @override
  State<OrderComponent> createState() => _OrderComponentState();
}

class _OrderComponentState extends State<OrderComponent> {
  late IconData icon;
  late Color iconColor;
  String status = '';
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

    return Card(
      color: AppColors.whiteColor,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text('رقم الطلب: ${widget.order.id}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الاسم: ${widget.order.user!.name! ?? "غير متوفر"}'),
            Text('العنوان: ${widget.order.address! ?? "غير متوفر"}'),
            Text('رقم الهاتف: ${widget.order.phoneNumber ?? "غير متوفر"}'),
            Text('القيمة: ${widget.order.totalPrice ?? "0"}'),
            Text('عدد العناصر: ${widget.order.orderItemsCount ?? 0}'),
            Row(
              children: [
                Icon(icon, color: iconColor, size: 13),
                Text('  الحالة: ${status}'),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (action) async {
            if (action == 'delete') {
              // تأكيد الحذف
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('تأكيد الحذف'),
                  content: Text('هل تريد حذف الطلب رقم ${widget.order.id}؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('حذف'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await widget.controller.deleteOrder(widget.order.id!,context);
              }
            } else if (action == 'copy') {
              // نسخ المحتويات إلى الحافظة
              String orderDetails = '''
رقم الطلب: ${widget.order.user!.id! ?? "غير متوفر"}
الاسم: ${widget.order.user!.name! ?? "غير متوفر"}
العنوان: ${widget.order.address! ?? "غير متوفر"}
الخريطة: ${widget.order.addressLink! ?? "غير متوفر"}
رقم الهاتف: ${widget.order.phoneNumber ?? "غير متوفر"}
القيمة: ${widget.order.totalPrice ?? "0"}
عدد العناصر: ${widget.order.orderItemsCount ?? 0}

تفاصيل العناصر:
${widget.order.orderItems!.map((item) => '''
- اسم المنتج: ${item.product?.name ?? "غير متوفر"}
  السعر: ${item.price ?? "غير متوفر"}
  الكمية: ${item.quantity ?? "غير متوفر"}
  متجر المنتج: ${item.product!.store!.name ?? "غير متوفر"}
''').join('\n')}
''';
              await Clipboard.setData(ClipboardData(text: orderDetails));
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text('تم نسخ التفاصيل إلى الحافظة')),
              // );
            } else {
              // تعديل الحالة
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('تأكيد التحديث'),
                  content: Text('هل تريد تغيير الحالة إلى $action؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('تأكيد'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await widget.controller.updateOrderStatus(widget.order.id!, action,context);
              }
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'pending',
              child: Text('قيد الانتظار'),
            ),
            const PopupMenuItem(
              value: 'processing',
              child: Text('جاري المعالجة'),
            ),
            const PopupMenuItem(
              value: 'completed',
              child: Text('مكتمل'),
            ),
            const PopupMenuItem(
              value: 'canceled',
              child: Text('ملغي'),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'delete',
              child: Text('حذف الطلب', style: TextStyle(color: Colors.red)),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'copy',
              child: Text('نسخ المحتويات'),
            ),
          ],
        ),
      ),
    );
  }
}
