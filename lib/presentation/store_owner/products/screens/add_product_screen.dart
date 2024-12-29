import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/store_owner/products/controller/product_controller.dart';
import 'package:delivary/presentation/store_owner/products/model/product_model.dart';
import 'package:delivary/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart'; // استيراد مكتبة قص الصور
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, this.productModel});

  final ProductModel? productModel;

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}
class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? _image;
  ProductController controller = Get.put(ProductController());
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper(); // تعريف كائن لمكتبة قص الصور

  bool isAvailable = false; // متغير لحالة المنتج (متاح أو غير متاح)

  @override
  void initState() {
    super.initState();
    if (widget.productModel != null) {
      nameController.text = widget.productModel!.name!;
      descriptionController.text = widget.productModel!.description!;
      priceController.text = widget.productModel!.price!;
      isAvailable = widget.productModel!.isAvailable==1?true:false ; // تحديد حالة المنتج عند التعديل
    }
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

  // الدالة لاختيار الصورة من الكاميرا أو الاستوديو
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // الدالة لقص الصورة
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
              lockAspectRatio: false
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _image = File(croppedFile.path);
        });
      }
    }
  }

  // الدالة لحفظ المنتج
  void _saveProduct() {
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        _image != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إضافة المنتج بنجاح!')),
      );
      nameController.clear();
      descriptionController.clear();
      priceController.clear();
      setState(() {
        _image = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى ملء جميع البيانات!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:  Text(widget.productModel != null?'تعديل المنتج':'إضافة منتج'),
          actions: [
            if(widget.productModel != null)
              IconButton(onPressed: () {
                showDialog(context: context, builder: (_) {
                  return AlertDialog(title: Text('حذف المنتج'),
                    content: Text('هل تريد حذف المنتج؟'),
                    actions: [
                      Obx(() {
                        return TextButton(onPressed: () {
                          controller.deleteProduct(
                              context, widget.productModel!.id!);
                        },
                            child: Text('حذف', style: TextStyle(
                                color: controller.waitingDelete.value
                                    ? AppColors.grey
                                    : null),));
                      }),
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text('إلغاء')),
                    ],
                  );
                });
              }, icon: Icon(Icons.delete))
          ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Directionality(textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // حقل إدخال اسم المنتج
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المنتج',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // حقل إدخال الوصف
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'الوصف',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // حقل إدخال السعر
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'السعر',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // حقل الـ Switch لتحديد حالة المنتج
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAvailable ? 'المنتج متاح' : 'المنتج غير متاح',
                      style: TextStyle(fontSize: 16),
                    ),
                    Switch(
                      value: isAvailable,
                      onChanged: (value) {
                        setState(() {
                          isAvailable = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

              GestureDetector(
                onTap: _showBottomSheet,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: widget.productModel != null && _image == null
                      ? Hero(
                    tag: widget.productModel!.id ?? 'defaultTag', // استخدم نفس Hero Tag
                    child: Center(
                      child: Image.network(widget.productModel!.imageUrl!,
                          errorBuilder: (con, ob, t) {
                            return Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColors.grey.withOpacity(0.5)),
                                child: const Center(
                                    child: Icon(
                                      Icons.image_search,
                                      size: 30,
                                    )));
                          }),
                    ),
                  )
                      : _image == null
                      ? const Center(child: Icon(Icons.camera_alt))
                      : Center(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Hero(
                          tag: widget.productModel?.id ?? 'defaultTag', // نفس Hero Tag
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
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
              ),

                const SizedBox(height: 16),

                Obx(() {
                  if(controller.waitingAdd.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ButtonWidget(
                      text: widget.productModel == null ? 'إضافة' : 'تعديل',
                      onTap: () {
                        widget.productModel == null ?   controller.addProduct(name: nameController.text,
                            description: descriptionController.text,
                            price: priceController.text,
                            file: _image!,):
                        controller.updateProduct(name: nameController.text,
                            description: descriptionController.text,
                            price: priceController.text,
                            file: _image,
                            isAvailable: isAvailable==true?1:0, id: widget.productModel!.id!)
                        ;
                      });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
