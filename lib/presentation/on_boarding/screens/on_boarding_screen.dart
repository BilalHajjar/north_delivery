import 'package:delivary/core/cache_helper.dart';
import 'package:delivary/core/colors.dart';
import 'package:delivary/presentation/auth/screens/login_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:flutter_svg/flutter_svg.dart';

// //Copy this CustomPainter code to the Bottom of the File
// class RPSCustomPainter extends CustomPainter {
// @override
// void paint(Canvas canvas, Size size) {
//
// Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
// paint_0_fill.color = Color(0xffFFAF0B).withOpacity(0.14);
// canvas.drawCircle(Offset(size.width*0.5002671,size.height*0.4704545),size.width*0.3544521,paint_0_fill);
//
// Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
// paint_1_fill.color = Color(0xffFE8C00).withOpacity(1.0);
// canvas.drawCircle(Offset(size.width*0.1347390,size.height*0.1470173),size.width*0.03322986,paint_1_fill);
//
// Paint paint_2_fill = Paint()..style=PaintingStyle.fill;
// paint_2_fill.color = Color(0xffFE8C00).withOpacity(1.0);
// canvas.drawCircle(Offset(size.width*0.1181240,size.height*0.8232955),size.width*0.04430651,paint_2_fill);
//
// Paint paint_3_fill = Paint()..style=PaintingStyle.fill;
// paint_3_fill.color = Color(0xffFE8C00).withOpacity(1.0);
// canvas.drawCircle(Offset(size.width*0.9101027,size.height*0.2646309),size.width*0.04430651,paint_3_fill);
//
// Paint paint_4_fill = Paint()..style=PaintingStyle.fill;
// paint_4_fill.color = Color(0xffFE8C00).withOpacity(1.0);
// canvas.drawCircle(Offset(size.width*0.8491815,size.height*0.06615773),size.width*0.02769158,paint_4_fill);
//
// Path path_5 = Path();
// path_5.moveTo(149.312,25.875);
// path_5.cubicTo(127.536,25.875,108.272,36.6359,96.549,53.1305);
// path_5.cubicTo(92.721,52.2277,88.7288,51.75,84.625,51.75);
// path_5.cubicTo(56.0443,51.75,32.875,74.9193,32.875,103.5);
// path_5.cubicTo(32.875,132.081,56.0443,155.25,84.625,155.25);
// path_5.lineTo(214,155.25);
// path_5.cubicTo(239.008,155.25,259.281,134.977,259.281,109.969);
// path_5.cubicTo(259.281,84.9606,239.008,64.6875,214,64.6875);
// path_5.cubicTo(212.224,64.6875,210.471,64.7898,208.748,64.9888);
// path_5.cubicTo(198.836,41.9816,175.955,25.875,149.312,25.875);
// path_5.close();
//
// Paint paint_5_fill = Paint()..style=PaintingStyle.fill;
// paint_5_fill.color = Color(0xffF9F5FF).withOpacity(1.0);
// canvas.drawPath(path_5,paint_5_fill);
//
// Paint paint_6_fill = Paint()..style=PaintingStyle.fill;
// paint_6_fill.shader = ui.Gradient.linear(Offset(size.width*0.1537274,size.height*0.3150364), Offset(size.width*0.4670377,size.height*0.7056818), [Color(0xffFFAF0B).withOpacity(0.44),Colors.white.withOpacity(0)], [0,0.997917]);
// canvas.drawCircle(Offset(size.width*0.2898116,size.height*0.4704545),size.width*0.1772260,paint_6_fill);
//
// Paint paint_7_fill = Paint()..style=PaintingStyle.fill;
// paint_7_fill.shader = ui.Gradient.linear(Offset(size.width*0.3412387,size.height*0.2173750), Offset(size.width*0.7328767,size.height*0.7056818), [Color(0xffFFAF0B).withOpacity(0.44),Colors.white.withOpacity(0)], [0,0.997917]);
// canvas.drawCircle(Offset(size.width*0.5113425,size.height*0.4116477),size.width*0.2215325,paint_7_fill);
//
// Paint paint_8_fill = Paint()..style=PaintingStyle.fill;
// paint_8_fill.shader = ui.Gradient.linear(Offset(size.width*0.6138014,size.height*0.3638673), Offset(size.width*0.8879486,size.height*0.7056818), [Color(0xffFFAF0B).withOpacity(0.44),Colors.white.withOpacity(0)], [0,0.997917]);
// canvas.drawCircle(Offset(size.width*0.7328767,size.height*0.4998591),size.width*0.1550726,paint_8_fill);
//
// Paint paint_9_fill = Paint()..style=PaintingStyle.fill;
// paint_9_fill.color = Color(0xffFE8C00).withOpacity(1.0);
// canvas.drawRRect(RRect.fromRectAndCorners(Rect.fromLTWH(size.width*0.3451952,size.height*0.4410509,size.width*0.3101455,size.height*0.4116477),bottomRight: Radius.circular(size.width*0.1550726),bottomLeft:  Radius.circular(size.width*0.1550726),topLeft:  Radius.circular(size.width*0.1550726),topRight:  Radius.circular(size.width*0.1550726)),paint_9_fill);
//
// Path path_10 = Path();
// path_10.moveTo(163.059,159.293);
// path_10.lineTo(156.455,152.689);
// path_10.moveTo(161.172,141.369);
// path_10.cubicTo(161.172,150.226,153.992,157.406,145.135,157.406);
// path_10.cubicTo(136.278,157.406,129.098,150.226,129.098,141.369);
// path_10.cubicTo(129.098,132.512,136.278,125.332,145.135,125.332);
// path_10.cubicTo(153.992,125.332,161.172,132.512,161.172,141.369);
// path_10.close();
//
// Paint paint_10_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01107664;
// paint_10_stroke.color=Colors.white.withOpacity(1.0);
// paint_10_stroke.strokeCap = StrokeCap.round;
// paint_10_stroke.strokeJoin = StrokeJoin.round;
// canvas.drawPath(path_10,paint_10_stroke);
//
// Paint paint_10_fill = Paint()..style=PaintingStyle.fill;
// paint_10_fill.color = Color(0xff000000).withOpacity(1.0);
// canvas.drawPath(path_10,paint_10_fill);
//
// }

// @override
// bool shouldRepaint(covariant CustomPainter oldDelegate) {
// return true;
// }
// }
class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<Map<String, dynamic>> myMapTitleAndDescription = [
    {'title': 'كل ما تحتاجه، في متناول يدك', 'description': 'سواء كان طعامًا، مستلزمات يومية، أو أدوات منزلية، نوفر لك خدمة توصيل تلبي احتياجاتك بسرعة وسهولة'},
    {'title': 'توصيل سريع لجميع احتياجاتك', 'description': 'من خلال شبكتنا الواسعة، نضمن لك وصول طلباتك بسرعة وأمان، أينما كنت وفي أي وقت تشاء'},
    {'title': 'الأمانة من اولوياتنا', 'description': 'اطلب ما تحتاجه من طعام، مستلزمات يومية، أو أي منتجات أخرى، وستصلك كما بأفضل جودة.'}
  ];
List<Widget> images=[];
  @override
  void initState() {
    super.initState();
    images=[ Image.asset(
      'assets/images/img.png',
      fit: BoxFit.cover,
    ), Image.asset(
      'assets/images/img_1.png',
      fit: BoxFit.cover,
    ), Image.asset(
      'assets/images/img_2.png',
      fit: BoxFit.cover,
    )];
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 5,
      width: _currentPage == index ? 32 : 16,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.whiteColor : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                images[0],
                images[1],
                images[2],
              ],
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Container(
                height: 400,
                margin:const EdgeInsets.only(top: 200, left: 32, right: 32),
                padding:const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.primaColor,
                  borderRadius: BorderRadius.circular(48),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      myMapTitleAndDescription[_currentPage]['title'],
                      textAlign: TextAlign.center,
                      style:const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  const  SizedBox(height: 16),
                    SizedBox(height: 120,
                      child: Center(
                        child: Text(
                          myMapTitleAndDescription[_currentPage]['description'],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  const  SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return _buildDot(index: index);
                      }),
                    ),
                  const  Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (_currentPage == 3) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreens()),
                              );
                            } else {
                              _pageController.previousPage(
                                duration:const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            }
                          },
                          child:const Text(
                            'السابق',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            if (_currentPage == 2) {
                              CacheHelper.saveData(key: 'onBoarding', value: true);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreens()),
                              );
                            } else {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            }
                          },
                          child: Text(
                            _currentPage == 2 ? 'لنبدأ' : 'التالي',
                            style:const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

