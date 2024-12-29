import 'package:delivary/core/not_found.dart';
import 'package:delivary/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    cartController.fetchCartItems();

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
        } else if (cartController.cartItems.isEmpty && cartController.x.value) {
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
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
                                child: Image.network(
                                  '${cartItem.product!.imageUrl!}',
                                  fit: BoxFit.cover,
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
                                    style: TextStyle(
                                        fontSize: 16,
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
                    const Text(
                      'المجموع:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  onTap: () {
                    showCheckoutDialog(context, cartController, totalPrice);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void showCheckoutDialog(
      BuildContext context, CartController cartController, double totalPrice) {
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController notesController = TextEditingController();
    final RxString myLocation = ''.obs; // لحفظ الموقع كحالة ملاحظة
    final RxBool locationFetched = false.obs; // لحالة تحديد الموقع

    Future<void> _getLocation() async {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

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

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final Uri googleMapUrl = Uri.parse(
          'https://www.google.com/maps?q=${position.latitude},${position.longitude}');
      myLocation.value = googleMapUrl.toString();
      locationFetched.value = true; // تغيير الحالة إلى تم تحديد الموقع
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // للسماح بالتمرير مع الكيبورد
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // لضمان رفع BottomSheet مع الكيبورد
          ),
          child: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'إتمام الشراء',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'رقم الهاتف'),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: 'العنوان'),
                  ),
                  SizedBox(height: 10),
                  Obx(() {
                    return ElevatedButton.icon(
                      onPressed: () async {
                        await _getLocation();
                      },
                      icon: locationFetched.value
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : Icon(Icons.location_on, color: Colors.white),
                      label: Text(locationFetched.value
                          ? 'تم تحديد الموقع'
                          : 'تحديد الموقع'),
                    );
                  }),
                  SizedBox(height: 10),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(labelText: 'ملاحظات'),
                    maxLines: 5, // عدد الأسطر القصوى
                    minLines: 3, // عدد الأسطر الأدنى
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('إتمام الشراء',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      // معالجة بيانات الإتمام
                      cartController.createOrder(
                        context,
                        phone: phoneController.text,
                        note: notesController.text,
                        address: addressController.text,
                        link: myLocation.value
                        ,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showEditQuantityDialog(
      BuildContext context, CartController cartController, dynamic cartItem) {
    RxInt updatedQuantity = 0.obs;
    updatedQuantity.value = cartItem.quantity!;

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
                      icon: Icon(Icons.remove_circle_outline,
                          color: Colors.redAccent),
                      onPressed: () {
                        if (updatedQuantity > 1) {
                          updatedQuantity.value--;
                        }
                      },
                    ),
                    Text(
                      '$updatedQuantity',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                child:
                    Text('تحديث الكمية', style: TextStyle(color: Colors.white)),
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

  void showDeleteConfirmationDialog(
      BuildContext context, CartController cartController, int itemId) {
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
