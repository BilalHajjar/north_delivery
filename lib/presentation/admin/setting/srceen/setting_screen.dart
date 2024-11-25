import 'package:delivary/presentation/admin/setting/controller/setting_controller.dart';
import 'package:delivary/widgets/button_widget.dart';
import 'package:delivary/widgets/out_line_button.dart';
import 'package:delivary/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  TextEditingController phoneController = TextEditingController();
  TextEditingController faceBookController = TextEditingController();
  SettingController controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الإعدادات'),),
      body: Directionality(textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Obx(() {
                if(controller.waitSetting.value)
                  return Center(child: CircularProgressIndicator());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: OutLineButton(icn:FontAwesomeIcons.whatsapp , text: 'رقم الوتساب', func: () {  },)),
                        SizedBox(width: 5,),
                        Expanded(child: OutLineButton(icn: FontAwesomeIcons.facebook, text: 'صفحة الفيسبوك', func: () {  },)),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('رقم الهاتف'),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: TextFieldWidget(

                          txt: '01234567899+',
                          preIcon: Icons.phone,
                          controller: phoneController),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('صفحة الفيسبوك'),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextFieldWidget(
                          txt: 'www.facebook.com',
                          preIcon: FontAwesomeIcons.facebook,
                          controller: faceBookController),
                    ),
                    SizedBox(height: 20,),
                    Obx(() {
                      if (controller.loadingPut.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ButtonWidget(text: 'تعديل', onTap: () {
                        controller.putSetting(
                            context, phone: phoneController.text,
                            facebook: faceBookController.text);
                      });
                    })
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
