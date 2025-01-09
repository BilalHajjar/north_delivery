
import 'dart:async';

import 'package:flutter/material.dart';

class TextAni extends StatefulWidget {
  const TextAni({super.key});

  @override
  State<TextAni> createState() => _TextAniState();
}

class _TextAniState extends State<TextAni> {
  final List<String> _texts = [
    "شو الغدا اليوم؟",
    "عبالك شي؟",
    "وقتك ضيق؟",
    "اطلب الآن",
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _texts.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Text(
        _texts[_currentIndex],
        key: ValueKey<String>(_texts[_currentIndex]),
        style: TextStyle(fontSize: 20, ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

