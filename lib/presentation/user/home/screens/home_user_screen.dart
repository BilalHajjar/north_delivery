import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/admin/user_maneger/model/users_model.dart';
import 'package:delivary/presentation/store_owner/products/screens/products_screen.dart';
import 'package:delivary/presentation/user/cart/screen/cart_screen.dart';
import 'package:delivary/presentation/user/home/controller/home_user_controller.dart';
import 'package:delivary/presentation/user/orders/screen/order_screen.dart';
import 'package:delivary/presentation/user/product/components/product_user_component.dart';
import 'package:delivary/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../store_owner/home_store/screen/home_store_screen.dart';
import '../../stores/controller/stores_controller.dart';
import '../../stores/screen/stores_screen.dart';
import '../components/drawer_component.dart';
import '../components/float_filltert_button.dart';
import '../components/text_animation_component.dart';
import 'ads_and_product_screen.dart';
class HomeUserScreen extends StatelessWidget {
  HomeUserScreen({super.key, required this.userModel});

  final UserModel userModel;

  final HomeUserController controller = Get.put(HomeUserController());

  final List<Widget> screen = [
    StoresScreen(),
    AdsAndProductScreen(),
    OrderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextAni(),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(CartScreen());
            },
            icon: Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: SafeArea(
        child: Obx(() => screen[controller.current.value]),
      ),
      // floatingActionButton: Obx(
      //       () => controller.current.value == 0
      //       ? FloatFilterButton()
      //       : SizedBox(),
      // ),
      drawer: Drawer(
        child: CustomStoreDrawer(
          userModel: userModel,
        ),
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.store_mall_directory),
              label: 'المتاجر',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              label: 'الطلبات',
            ),
          ],
          currentIndex: controller.current.value,
          onTap: (index) {
            controller.changePage(index); // تحديث الصفحة
          },
        ),
      ),
    );
  }
}
