import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الدعم الفني'),
      ),
      body: Column(
        mainAxisAlignment:  MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('assets/images/support.json',width: 300),

          Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
           TextButton(onPressed: ()async{
             await launch('https://wa.me/+905318431698}');

           }, child: Text('هنا')),
           Text('لا تتردد بإعلامنا بالمشاكل ان واجهتها من'),
         ],)
        ],
      ),
    );
  }
}
