import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key,required this.txt});
final String txt;
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: 200,
            child: Lottie.asset('assets/images/not_found.json',width: 200)),
        Text('$txt'),
      ],
    ));
  }
}
