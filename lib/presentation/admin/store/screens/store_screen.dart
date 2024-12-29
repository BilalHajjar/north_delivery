import 'package:delivary/core/colors.dart';
import 'package:delivary/core/not_found.dart';
import 'package:delivary/presentation/admin/store/controller/store_controller.dart';
import 'package:delivary/presentation/admin/store/model/store_model.dart';
import 'package:delivary/presentation/admin/store/screens/add_store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            Get.to(AddStoreScreen(
              storeController: controller,
            ));
          }),
      body: Obx(() {
        // Show loading indicator while fetching data
        if (controller.waitStoreList.value) {
          return Center(child: CircularProgressIndicator());
        }
else if(controller.storeList.length==0)
  return NotFound(txt: 'لا يوجد متاجر');

        return Directionality(
          textDirection: TextDirection.rtl,
          child: RefreshIndicator(
            onRefresh: () async{ controller.getStores(); },
            child: ListView.builder(
              itemCount: controller.storeList.length,
              itemBuilder: (BuildContext context, int index) {
                var store = controller.storeList[index]; // Get the store at index

                return InkWell(
                  onTap: () {
                    Get.to(AddStoreScreen(
                      storeModel: controller.storeList[index],
                      storeController: controller,
                    ));
                  },
                  child: StoreComponent(store: store),
                );
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
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                child:
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(tag: 'store-${store.id}',
                      child: Image.network(
                        store.imageUrl!,
                        fit: BoxFit.fitHeight,
                        errorBuilder: (_, p, o) {
                          return Icon(Icons.image_search);
                        },
                      ),
                    ),
                ),
            ),
            SizedBox(
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
                      Text(
                        ' ${store.name}', // Display store name
                        style: const TextStyle(
                            fontSize: 22,
                            // fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      const Spacer(),
                      const Icon(Icons.location_on,size: 12,color: AppColors.primaColor,),
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
