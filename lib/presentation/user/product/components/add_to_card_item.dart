
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/api_connect.dart';
import '../../../../core/colors.dart';
import '../../../store_owner/products/model/product_model.dart';

class AddToCardItem extends StatefulWidget {
  const AddToCardItem({
    super.key,
    required this.productModel,
  });

  final ProductModel productModel;

  @override
  State<AddToCardItem> createState() => _AddToCardItemState();
}

class _AddToCardItemState extends State<AddToCardItem> {
  int i = 0;
  bool isLoading = false;

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (i == 0) {
      return InkWell(
        onTap: () {
          setState(() {
            i++;
          });
        },
        child: Container(
          height: 35,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.primaColor,
          ),
          child: widget.productModel.inCart!
              ? const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_shopping_cart,
                size: 15,
              ),
              Text(
                '  زيادة العدد؟',
                style: TextStyle(),
              )
            ],
          )
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_checkout_sharp,
                size: 15,
                color: AppColors.whiteColor,
              ),
              Text(
                '  إلى السلة؟',
                style: TextStyle(color: AppColors.whiteColor),
              )
            ],
          ),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  TextEditingController controllerEdit =
                  TextEditingController();
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      title: const Text(
                        'إجمالي العدد',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      content: TextField(
                        controller: controllerEdit,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'أدخل العدد الجديد',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'رجوع',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              i = int.parse(controllerEdit.text);
                            });
                            Navigator.pop(context);
                          },
                          child: Text('موافق'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 15),
            ),
          ),
          const SizedBox(width: 2),
          InkWell(
            onTap: () {
              setState(() {
                i--;
              });
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              child: Icon(i < 2 ? Icons.delete : Icons.remove,
                  color: Colors.white, size: 15),
            ),
          ),
          const SizedBox(width: 2),
          Container(
            margin:const EdgeInsets.symmetric(horizontal: 2),
            padding:const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '$i',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                i++;
              });
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 15),
            ),
          ),
          InkWell(
            onTap: isLoading
                ? null
                : () async {
              setState(() {
                isLoading = true;
              });

              bool hasInternet = await checkInternetConnection();

              if (!hasInternet) {
                setState(() {
                  isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('لا يوجد اتصال بالإنترنت'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              await ApiConnect().postData('cart', {
                "product_id": widget.productModel.id!,
                "quantity": i
              }).then((response) {
                if (response.statusCode == 200 ||
                    response.statusCode == 201) {
                  setState(() {
                    i = 0;
                    widget.productModel.inCart = true;
                  });
                } else {
                  appErrorMessage(
                      context, jsonDecode(response.body)['message']);
                }
              }).catchError((error) {
                appErrorMessage(
                    context, 'تحقق من الاتصال');
              }).whenComplete(() {
                setState(() {
                  isLoading = false;
                });
              });
            },
            child: Container(
              height: 35,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: isLoading ? Colors.grey : AppColors.primaColor,
              ),
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
                    : const Text(
                  'إضافة',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
