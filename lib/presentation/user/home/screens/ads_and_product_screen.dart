import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/admin/store/model/list_model.dart';
import 'package:delivary/presentation/admin/store/model/store_model.dart';
import 'package:delivary/presentation/auth/screens/email_verification_screen.dart';
import 'package:delivary/presentation/user/home/controller/home_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../widgets/custom_image.dart';
import '../../product/components/product_user_component.dart';
import '../../product/screen/product_user_screen.dart';
import '../components/category_user_component.dart';

class AdsAndProductScreen extends StatelessWidget {
  const AdsAndProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeUserController controller = Get.put(HomeUserController());
    return SingleChildScrollView(
      child: Column(
        children: [
          // عرض الإعلانات
          GetBuilder<HomeUserController>(
            builder: (logic) {
              if (logic.adsList.isNotEmpty) {
                return CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                  ),
                  items: logic.adsList.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade300,
                                Colors.amber.shade700,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CustomImage(image:  i.imageUrl!,)

                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              }
              return Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.white,
                child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,),
                  height: 200.0,
                  width: double.infinity,
                ),
              );
            },
          ),

          // عرض المتاجر
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.keyboard_arrow_left_sharp),
                GestureDetector(
                  onTap: () {
                    controller.current.value = 0;
                  },
                  child: Text('الكل'),
                ),
                Spacer(),
                Text('المتاجر'),
              ],
            ),
          ),
          GetBuilder<HomeUserController>(builder: (logic) {
            if (logic.storeList.isNotEmpty) {
              return SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: logic.storeList.take(5).length,
                  itemBuilder: (BuildContext context, int index) {
                    var store = logic.storeList[index];

                    return InkWell(
                      onTap: () {

                        Get.to(ProductUserScreen(
                          store: logic.storeList[index],

                        ));
                      },
                      child:Hero(
                        tag: 'store-${store.id}', // جعل tag فريدًا باستخدام الفهرس
                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
    ClipRRect(                            borderRadius: BorderRadius.circular(20),
        child: CustomImage(image: store.imageUrl!)),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor.withOpacity(0.85),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                  child: Directionality(textDirection: TextDirection.rtl,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.storefront_outlined, color: AppColors.primaColor, size: 18),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: Text(
                                                store.name!,
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16,
                                                  // fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.location_pin, color: Colors.redAccent, size: 18),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: Text(
                                                store.region!.name!,
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    );
                  },
                ),
              );
            }
            else if(logic.isAuth==false) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Center(child: const Text("تنبيه")),
                    content:
                        const Text("يرجى تأكيد حسابك عبر البريد.",textDirection: TextDirection.rtl,),
                    actions: [
                      TextButton(
                        onPressed: () => Get.offAll(EmailVerificationScreen(email: null)),
                        child: const Text("حسنًا"),
                      ),
                    ],
                  ),
                );
              });
            }
            return Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.white,
              child: SingleChildScrollView(scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 140.0,
                      width: 140,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,),
                    ),
                    Container(
                      height: 140.0,
                      width: 140,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,),
                    ),
                    Container(
                      height: 140.0,
                      width: 140,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,),
                    ),
                  ],
                ),
              ),
            );
          }),

          // عرض المنتجات
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Spacer(),
                Text('الفئات'),
              ],
            ),
          ),
          GetBuilder<HomeUserController>(builder: (logic) {

            if (logic.categoryList.isNotEmpty) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics:const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount:controller. categoryList.length,
                  itemBuilder: (context, index) {
                    final category = controller. categoryList[index];
                    return InkWell (
                        onTap: (){
                          controller.tempForMySelectCategory=ListModel(id: category.id!,name: category.name!) ;

                          controller.changePage(0);
                        },
                        child: CategoryUserComponent(categoryModel: category));
                  },
                ),
              );
            }
            return Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 200.0,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,),
                    ),
                  ),Expanded(
                    child: Container(
                      height: 200.0,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

