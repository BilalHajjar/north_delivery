import 'package:delivary/core/colors.dart';
import 'package:delivary/core/not_found.dart';
import 'package:delivary/presentation/admin/store/controller/store_controller.dart';
import 'package:delivary/presentation/admin/store/model/store_model.dart';
import 'package:delivary/presentation/admin/store/screens/add_store_screen.dart';
import 'package:delivary/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../user/product/screen/product_user_screen.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    StoreController controller = Get.put(StoreController());

    return Scaffold(
      // appBar: AppBar(
      //
      //   title: Text("إدارة المتاجر"),
      // ),
      floatingActionButton: FloatingActionButton.extended(
          label: Text('إضافة متجر'),
          onPressed: () {
            Get.to(AddStoreScreen());
          }),
      body: Obx(() {
        // Show loading indicator while fetching data
        if (controller.waitStoreList.value && controller.currentPage == 1) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.storeList.length == 0)
          return NotFound(txt: 'لا يوجد متاجر');

        return Directionality(
          textDirection: TextDirection.rtl,
          child: RefreshIndicator(
            onRefresh: () async {
              controller.storeList = [];
              controller.currentPage = 1;
              controller.getStores();
            },
            child: ListView.builder(
              controller: controller.scroll,
              itemCount: controller.storeList.length + 1,
              itemBuilder: (BuildContext context, int index) {
                // Get the store at index
                if (index < controller.storeList.length) {
                  var store = controller.storeList[index];
                  return GestureDetector(
                      onTap: () {
                        Get.to(() => AddStoreScreen(
                              storeModel: store,
                            ));
                      },
                      child: StoreComponent(store: store));
                } else {
                  if (controller.hasMode == null) {
                    return const SizedBox();
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              },
            ),
          ),
        );
      }),
    );
  }
}

class StoreComponent extends StatelessWidget {
  const StoreComponent({
    super.key,
    required this.store,
  });

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2)
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 130,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: 'store-${store.id}',
                  child: CustomImage(image: store.imageUrl!),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          ' ${store.name}', // Display store name
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                      // const Spacer(),
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: AppColors.primaColor,
                      ),
                      Text(
                        ' ${store.region!.name!}', // Display store name
                        style: const TextStyle(
                            fontSize: 12,
                            // fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),

                  // Store description
                  // Text(
                  //   'الوصف: ${store.description??'-'}',
                  //   // Display store description
                  //   style: TextStyle(fontSize: 16, color: Colors.black54),
                  // ),
                  // SizedBox(height: 10),

                  // User details
                  // Text(
                  //   'المالك: ${store.user!.name}', // Display user name
                  //   style: TextStyle(fontSize: 16, color: Colors.black87),
                  // ),
                  // Text(
                  //   'البريد: ${store.user!.email}', // Display user email
                  //   style: TextStyle(fontSize: 16, color: Colors.blue),
                  // ),

                  SizedBox(height: 10),

                  // Categories
                  const Text(
                    'التصنيفات:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  Column(
                    children: store.categories!.map<Widget>((category) {
                      return Row(
                        children: [
                          Icon(Icons.category, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            category.name!, // Display category name
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
