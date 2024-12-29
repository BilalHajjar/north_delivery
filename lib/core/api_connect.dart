
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:delivary/core/cache_helper.dart';
import 'package:delivary/main.dart';
import 'package:delivary/presentation/auth/screens/login_screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


import 'package:http_parser/http_parser.dart';

class ApiConnect {
  static const int timeoutDuration = 30;
  String baseUrl='https://northdeliveryservices.com/api';

  Future<http.Response> getData(String url) async {
    try {
      final response = await http
          .get(
        Uri.parse('$baseUrl/$url'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
          'Bearer $token'
        },
      )
          .timeout(Duration(seconds: timeoutDuration)); // إضافة timeout
      if(response.statusCode==401)
        {
          CacheHelper.removeData(key: 'token');
          Get.offAll(LoginScreens());
        }
      return response;
    } on http.ClientException catch (e) {
      rethrow;
    } on TimeoutException catch (_) {
      throw Exception("Request timeout");
    }
  }
  Future<http.Response> deleteData(String url) async {
    try {
      final response = await http
          .delete(
        Uri.parse('$baseUrl/$url'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
          'Bearer $token'
        },
      )
          .timeout(Duration(seconds: timeoutDuration)); // إضافة timeout

      return response;
    } on http.ClientException catch (e) {
      rethrow;
    } on TimeoutException catch (_) {
      throw Exception("Request timeout");
    }
  }
  Future<http.Response> postDataFile(String url, Map<String, dynamic> body, {File? file, String? mimeType}) async {
    final uri = Uri.parse('$baseUrl/$url');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',  // تغيير نوع المحتوى إلى form-urlencoded
      'Authorization': 'Bearer $token'
    };

    try {
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers);

      // إضافة البيانات إلى الـ fields مع التعامل مع المصفوفات
      body.forEach((key, value) {
        if (value is List) {
          // إرسال المصفوفات كـ حقل منفصل لكل عنصر
          for (var i = 0; i < value.length; i++) {
            request.fields['${key}[$i]'] = value[i].toString();
          }
        } else {
          request.fields[key] = value.toString();
        }
      });

      // إضافة الملف إذا كان موجوداً
      if (file != null) {
        final imageFileName = file.path.split('/').last;
        final multipartFile = await http.MultipartFile.fromPath(
          'image',
          file.path,
          filename: imageFileName,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        );
        request.files.add(multipartFile);
      }

      final response = await request.send();
      return await http.Response.fromStream(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('An error occurred while posting data');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }
  Future<http.Response> postData(String url, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
        Uri.parse('$baseUrl/$url'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
          'Bearer $token'
        },
        body: jsonEncode(body),
      )
          .timeout(Duration(seconds: timeoutDuration)); // إضافة timeout

      return response;
    } on http.ClientException catch (e) {
      rethrow;
    } on TimeoutException catch (_) {
      throw Exception("Request timeout");
    }
  }
  Future<http.Response> patchData(String url, Map<String, dynamic> body) async {
    try {
      final response = await http
          .patch(
        Uri.parse('$baseUrl/$url'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
          'Bearer $token'
        },
        body: jsonEncode(body),
      )
          .timeout(Duration(seconds: timeoutDuration)); // إضافة timeout

      return response;
    } on http.ClientException catch (e) {
      rethrow;
    } on TimeoutException catch (_) {
      throw Exception("Request timeout");
    }
  }
  Future<http.Response> putData(String url, Map<String, dynamic> body) async {
    try {
      final response = await http
          .put(
        Uri.parse('$baseUrl/$url'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
          'Bearer $token'
        },
        body: jsonEncode(body),
      )
          .timeout(Duration(seconds: timeoutDuration)); // إضافة timeout

      return response;
    } on http.ClientException catch (e) {
      rethrow;
    } on TimeoutException catch (_) {
      throw Exception("Request timeout");
    }
  }

}

void appErrorMessage(BuildContext context, String message,{String title='خطأ'}) {
  var snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: Directionality(textDirection: TextDirection.rtl,
      child: AwesomeSnackbarContent(
        title: title,
        message:
        message,

        contentType:title=='تم'? ContentType.success :ContentType.failure,
      ),
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
