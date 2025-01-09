import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,required this.image
  });
  final String image;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      image,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child; // عند اكتمال التحميل، عرض الصورة مباشرة
        } else {
          // إذا كان هناك تحميل
          double progress = loadingProgress.expectedTotalBytes != null
              ? (loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1))
              : 0;
          return Center(

              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      value: progress,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.grey[700],
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%', // نسبة التحميل
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

          );
        }
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        // عند حدوث خطأ في تحميل الصورة، تظهر أيقونة الفشل
        return const Center(
          child: Icon(
            Icons.error,
            color: Colors.red,
            size: 50,
          ),
        );
      },
    );
  }
}
