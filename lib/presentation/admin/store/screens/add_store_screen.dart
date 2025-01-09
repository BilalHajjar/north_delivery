import 'dart:io';

import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/admin/store/components/category_widget.dart';
import 'package:delivary/presentation/admin/store/components/region_combo_box.dart';
import 'package:delivary/presentation/admin/store/controller/add_store_controller.dart';
import 'package:delivary/presentation/admin/store/controller/store_controller.dart';
import 'package:delivary/presentation/admin/store/model/store_model.dart';
import 'package:delivary/widgets/button_widget.dart';
import 'package:delivary/widgets/custom_image.dart';
import 'package:delivary/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../components/user_combo_box.dart';

class AddStoreScreen extends StatefulWidget {
  AddStoreScreen({super.key, this.storeModel, });

  StoreModel? storeModel;

  @override
  State<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();

   StoreController storeController=Get.find();
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // تحديث الصورة بعد الاختيار
      });
    }
  }


  Future<void> _cropImage() async {
    if (_image != null) {
      final croppedFile = await _cropper.cropImage(
        sourcePath: _image!.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'قص الصورة',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: false,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _image = File(croppedFile.path); // تحديث الصورة بعد القص
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();


    AddStoreController controller = Get.put(AddStoreController());
    if (widget.storeModel != null) {
      nameController.text = widget.storeModel!.name!;
      descriptionController.text = widget.storeModel!.description ?? '';
    }

    void _showBottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('استخدام الكاميرا'),
                    onTap: () {
                      _pickImage(ImageSource.camera);
                      Navigator.pop(context); // إغلاق الـ BottomSheet
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('اختيار من الاستوديو'),
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.pop(context); // إغلاق الـ BottomSheet
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة متجر'),
        actions: [
          if (widget.storeModel != null)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text('حذف المتجر'),
                      content: Text('هل تريد حذف المتجر؟'),
                      actions: [
                        Obx(() {
                          return TextButton(
                            onPressed: () {
                              storeController.deleteStore(
                                  context, widget.storeModel!.id!);
                            },
                            child: Text(
                              'حذف',
                              style: TextStyle(
                                  color: storeController
                                      .waitStoreList.value
                                      ? AppColors.grey
                                      : null),
                            ),
                          );
                        }),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('إلغاء'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.delete),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (controller.wait.value != 3) {
            return const Center(child: CircularProgressIndicator());
          }
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('اختر فئة:'),
                  CategoryWidget(
                    controller: controller,
                    category: widget.storeModel?.categories,
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: _showBottomSheet,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                      widget.storeModel != null && _image == null
                          ? Center(
                        child: CustomImage(image:  widget.storeModel!.imageUrl!),
                      )
                          : _image == null
                          ? const Center(child: Icon(Icons.camera_alt))
                          :
                      Center(
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                            if (_image != null)
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: _cropImage,
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                  ,
                  SizedBox(height: 10),
                  RegionComboBox(
                    controller: controller,
                    region: widget.storeModel?.region,
                  ),
                  SizedBox(height: 10),
                  if (widget.storeModel == null)
                    UserComboBox(
                      controller: controller,
                      user: widget.storeModel?.user,
                    ),
                  SizedBox(height: 10),
                  TextFieldWidget(
                      txt: 'محمد علي',
                      preIcon: Icons.person,
                      controller: nameController),
                  SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.description),
                      labelText: 'وصف ظهور المتجر',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),
                  Obx(() {
                    if (controller.loadingAdd.value) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ButtonWidget(
                      text: widget.storeModel == null ? 'إضافة' : 'تعديل',
                      onTap: () {
                        List<int> tempCategory = [];
                        for (int i = 0; i < controller.selectedCategories.length; i++) {
                          tempCategory.add(controller.selectedCategories[i].id!);
                        }
                        widget.storeModel == null
                            ? controller.addStore(
                            context,
                            name: nameController.text,
                            description: descriptionController.text,
                            userId: controller.selectUserWithoutStore!.id!,
                            regionIid: controller.selectedRegion!.id!,
                            file: _image!,
                            categories: tempCategory,
                            controller: storeController)
                            : controller.updateStore(
                            context,
                            name: nameController.text,
                            description: descriptionController.text,
                            userId: widget.storeModel!.id!,
                            regionIid: controller.selectedRegion!.id!,
                            file: _image,
                            categories: tempCategory,
                            controller: storeController);
                      },
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
