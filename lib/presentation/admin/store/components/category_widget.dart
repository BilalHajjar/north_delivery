import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/admin/store/controller/add_store_controller.dart';
import 'package:delivary/presentation/admin/store/model/list_model.dart';
import 'package:delivary/presentation/admin/store/model/store_model.dart';
import 'package:delivary/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryWidget extends StatefulWidget {
  CategoryWidget({super.key, required this.controller,this.category});

  final AddStoreController controller;
final List< CategoryModel>? category;
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  void initState() {
    super.initState();
if(widget.category!=null)
  {
    for(CategoryModel item in widget.controller.categoriesList!)
    for(int i=0;i<widget.category!.length;i++)
      {
        if(item.id==widget.category![i].id!)
        widget.controller.selectedCategories.add(item);
      }
  }
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
  
      spacing: 3,
      children: [
        ...List.generate(widget.controller.categoriesList.length, (i) {
          return GestureDetector(
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    TextEditingController categoryController =
                    TextEditingController();
                    AddStoreController controller = Get.find();

                    categoryController.text=widget.controller.categoriesList[i].name!;
                    return AlertDialog(
                      title: Center(child: Text('تعديل فئة')),
                      content:
                      Directionality(textDirection: TextDirection.rtl,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [

                              TextFieldWidget(
                                  txt: 'اسم الفئة',
                                  preIcon: Icons.title,
                                  controller: categoryController),
                              SizedBox(height: 5,),
                              GetBuilder<AddStoreController>(builder: (logic) {
                                if(logic.imagePath==null) {
                                  return ElevatedButton(onPressed: () {
                                    controller.pickImageFromGallery();
                                  }, child: Text('حمل الصورة'));
                                }else{
                                  return SingleChildScrollView(child: Center(child: Text('تم التحميل بنجاح')));
                                }
                              }),
                            ],
                          ),
                        ),
                      ),

                      actions: [
                        Obx(() {
                          return TextButton(onPressed: () {
                            controller.wait.value==3?    controller.updateCategories(categoryController.text,widget.controller.categoriesList[i].id!,controller.imagePath):null;
                          }, child: Text('تعديل',style: TextStyle(color: controller.wait.value==3?null:AppColors.grey),));
                        }), Obx(() {
                          return TextButton(onPressed: () {
                            controller.wait.value==3?    controller.deleteCategories(widget.controller.categoriesList[i].id!):null;
                          }, child: Text('حذف',style: TextStyle(color: controller.wait.value==3?null:AppColors.grey),));
                        }),
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        }, child: Text('إلغاء')),

                      ],
                    );
                  });
            },
            child: ChoiceChip(
              label: Text('${widget.controller.categoriesList[i].name}'),
              selected: widget.controller.selectedCategories
                  .contains(widget.controller.categoriesList[i]),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    widget.controller.selectedCategories
                        .add(widget.controller.categoriesList[i]);
                  } else {
                    widget.controller.selectedCategories
                        .remove(widget.controller.categoriesList[i]);
                  }
                });
              },
            ),
          )
;
        }),

        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  TextEditingController categoryController =
                  TextEditingController();
                  AddStoreController controller = Get.find();

                  return AlertDialog(
                    title: Center(child: Text('إضافة فئة')),
                    content:
                    Directionality(textDirection: TextDirection.rtl,
                      child:SingleChildScrollView(
                        child: Column(
                          children: [

                            TextFieldWidget(
                                txt: 'اسم الفئة',
                                preIcon: Icons.title,
                                controller: categoryController),
                            SizedBox(height: 5,),
                            GetBuilder<AddStoreController>(builder: (logic) {
                              if(logic.imagePath==null) {
                                return ElevatedButton(onPressed: () {
                                  controller.pickImageFromGallery();
                                }, child: Text('حمل الصورة'));
                              }else{
                                return SingleChildScrollView(child: Center(child: Text('تم التحميل بنجاح')));
                              }
                            }),
                          ],
                        ),
                      ),
                    ),

                    actions: [
                      Obx(() {

                        return TextButton(onPressed: () {
                          controller.wait.value==3?    controller.addCategories(categoryController.text,controller.imagePath!):null;
                        }, child: Text('إضافة',style: TextStyle(color: controller.wait.value==3?null:AppColors.grey),));
                      }),
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text('إلغاء')),

                    ],
                  );
                });
          },
        ),
      ],
    );
  }
}
