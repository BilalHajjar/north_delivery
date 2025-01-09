import 'package:delivary/core/not_found.dart';
import 'package:delivary/widgets/button_widget.dart';
import 'package:delivary/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // إنشاء المتحكم
    final CartController cartController = Get.put(CartController());

    // جلب البيانات عند تحميل الصفحة
    cartController.fetchCartItems();
    Future<void> _getLocation() async {
      bool serviceEnabled;
      LocationPermission permission;

      // تحقق من خدمات الموقع
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      // تحقق من الأذونات
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return;
      }

      // الحصول على الموقع الحالي
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // فتح الرابط في Google Maps
      final Uri googleMapUrl = Uri.parse(
          'https://www.google.com/maps?q=${position.latitude},${position.longitude}');
      if (await canLaunch(googleMapUrl.toString())) {
        await launch(googleMapUrl.toString());
      } else {
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('السلة'),
        actions: [
          IconButton(
            onPressed: () {
              cartController.deleteCartItems(context);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Obx(() {
        if (!cartController.x.value) {
          return NotFound(txt: 'السلة فارغة');
        } else if (cartController.cartItems.isEmpty &&cartController. x.value) {
          return Center(child: CircularProgressIndicator());
        }

        double totalPrice = 0.0;
        for (var item in cartController.cartItems) {
          totalPrice += double.tryParse(item.product!.price!)! * item.quantity!;
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartController.cartItems[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius
                          .circular(15)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: CustomImage(image:                                   '${cartItem.product!.imageUrl!}',
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.product?.name ?? 'منتج غير معروف',
                                    style: TextStyle(fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'السعر: \$${cartItem.product!.price!}',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                  SizedBox(height: 5),
                                  Text('الكمية: ${cartItem.quantity}'),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                showEditQuantityDialog(
                                    context, cartController, cartItem);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDeleteConfirmationDialog(
                                    context, cartController, cartItem.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 5);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المجموع:',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ButtonWidget(
                  text: 'إتمام الشراء',
                  onTap: () {},
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void showEditQuantityDialog(BuildContext context,
      CartController cartController, dynamic cartItem) {

    RxInt updatedQuantity=0.obs ;
   updatedQuantity.value=  cartItem.quantity!;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'تعديل الكمية',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                          Icons.remove_circle_outline, color: Colors.redAccent),
                      onPressed: () {
                        if (updatedQuantity > 1) {
                          updatedQuantity.value--;
                        }
                      },
                    ),
                    Text(
                      '$updatedQuantity',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline, color: Colors.green),
                      onPressed: () {
                        updatedQuantity.value++;
                      },
                    ),
                  ],
                );
              }),
              SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                    'تحديث الكمية', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (updatedQuantity > 0) {
                    cartController.updateCartItemQuantity(
                        cartItem.id!, updatedQuantity.value, context);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext context,
      CartController cartController, int itemId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
         actionsAlignment: MainAxisAlignment.center,
          title: Center(child: Text('تأكيد الحذف')),
          content: Text('هل أنت متأكد أنك تريد حذف هذا المنتج؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                cartController.deleteCartItem(itemId, context);
                Navigator.of(context).pop();
              },
              child: Text('حذف', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
