// import 'package:delivary/presentation/user/stores/controller/stores_controller.dart';
// import 'package:delivary/widgets/button_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../core/colors.dart';
//
// class FloatFilterButton extends StatelessWidget {
//   const FloatFilterButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (_) {
//             final controller = Get.find<AllStoresController>();
//
//             return AlertDialog(
//               title: const Center(
//                 child: Text(
//                   'تصفية المتاجر',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//               content: SingleChildScrollView(
//                 child: Directionality(
//                   textDirection: TextDirection.rtl,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Divider(),
//                       const Text(
//                         'التصنيفات:',
//                         style: TextStyle(fontSize: 12),
//                       ),
//                       _FilterSection(
//                         isLoading: controller.waitCategories,
//                         items: controller.categoryList,
//                         selectedItem: controller.selectedCategory,
//                         onSelected: (item) => controller.selectedCategory.value = item,
//                         selectedColor: AppColors.primaColor,
//                       ),
//                       const SizedBox(height: 10),
//                       const Text(
//                         'المناطق:',
//                         style: TextStyle(fontSize: 12),
//                       ),
//                       _FilterSection(
//                         isLoading: controller.waitRegions,
//                         items: controller.regionsList,
//                         selectedItem: controller.selectedRegion,
//                         onSelected: (item) => controller.selectedRegion.value = item,
//                         selectedColor: Colors.teal,
//                       ),
//                       const SizedBox(height: 20),
//                       ButtonWidget(
//                         text: 'تم',
//                         onTap: () {
//                           controller.applyFilters();
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//       child: const Icon(Icons.filter_list),
//     );
//   }
// }
//
// class _FilterSection extends StatelessWidget {
//   final RxBool isLoading;
//   final List<dynamic> items;
//   final Rx<dynamic> selectedItem;
//   final void Function(dynamic) onSelected;
//   final Color selectedColor;
//
//   const _FilterSection({
//     required this.isLoading,
//     required this.items,
//     required this.selectedItem,
//     required this.onSelected,
//     required this.selectedColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (isLoading.value) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//       return Wrap(
//         spacing: 8,
//         runSpacing: 8,
//         children: items.map((item) {
//           return ChoiceChip(
//             label: Text(
//               item.name,
//               style: TextStyle(
//                 color: selectedItem.value == item ? Colors.white : Colors.black,
//                 fontSize: 14,
//               ),
//             ),
//             selected: selectedItem.value == item,
//             onSelected: (bool selected) {
//               onSelected(selected ? item : null);
//             },
//             backgroundColor: Colors.grey.shade200,
//             selectedColor: selectedColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             elevation: 3,
//           );
//         }).toList(),
//       );
//     });
//   }
// }
