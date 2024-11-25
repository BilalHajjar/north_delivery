
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:delivary/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import 'package:http_parser/http_parser.dart';

class ApiConnect {
  // تحديد المدة القصوى 30 ثانية
  static const int timeoutDuration = 30;

  Future<http.Response> getData(String url) async {
    print('statring get /$url');
    try {
      final response = await http
          .get(
        Uri.parse('http://192.168.1.6:8000/api/$url'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
          'Bearer 2|Lzbji78JbbU9O5EtmhYCOYfDczOpL9gZ0q4Jedc99a3311f3'
        },
      )
          .timeout(Duration(seconds: timeoutDuration)); // إضافة timeout

      return response;
    } on http.ClientException catch (e) {
      print("Client Exception: $e");
      rethrow;
    } on TimeoutException catch (_) {
      print("Request timeout");
      throw Exception("Request timeout");
    }
  }
  Future<http.Response> deleteData(String url) async {
    print('statring get /$url');
    try {
      final response = await http
          .delete(
        Uri.parse('http://192.168.1.6:8000/api/$url'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
          'Bearer 2|Lzbji78JbbU9O5EtmhYCOYfDczOpL9gZ0q4Jedc99a3311f3'
        },
      )
          .timeout(Duration(seconds: timeoutDuration)); // إضافة timeout

      return response;
    } on http.ClientException catch (e) {
      print("Client Exception: $e");
      rethrow;
    } on TimeoutException catch (_) {
      print("Request timeout");
      throw Exception("Request timeout");
    }
  }

  Future<http.Response> postDataFile(String url, Map<String, String> body, {File? file, String? mimeType}) async {
    final uri = Uri.parse('https://api.syriaa-card.com/api/$url');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
      'Bearer 2|Lzbji78JbbU9O5EtmhYCOYfDczOpL9gZ0q4Jedc99a3311f3'
    };

    try {
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..fields.addAll(body);

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
        Uri.parse('http://192.168.1.6:8000/api/$url'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
          'Bearer 2|Lzbji78JbbU9O5EtmhYCOYfDczOpL9gZ0q4Jedc99a3311f3'
        },
        body: jsonEncode(body),
      )
          .timeout(Duration(seconds: timeoutDuration)); // إضافة timeout

      print(response.body);
      return response;
    } on http.ClientException catch (e) {
      print("Client Exception: $e");
      rethrow;
    } on TimeoutException catch (_) {
      print("Request timeout");
      throw Exception("Request timeout");
    }
  }
  Future<http.Response> patchData(String url, Map<String, dynamic> body) async {
    try {
      final response = await http
          .patch(
        Uri.parse('http://192.168.1.6:8000/api/$url'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
          'Bearer 2|Lzbji78JbbU9O5EtmhYCOYfDczOpL9gZ0q4Jedc99a3311f3'
        },
        body: jsonEncode(body),
      )
          .timeout(Duration(seconds: timeoutDuration)); // إضافة timeout

      print(response.body);
      return response;
    } on http.ClientException catch (e) {
      print("Client Exception: $e");
      rethrow;
    } on TimeoutException catch (_) {
      print("Request timeout");
      throw Exception("Request timeout");
    }
  }
  Future<http.Response> putData(String url, Map<String, dynamic> body) async {
    try {
      final response = await http
          .put(
        Uri.parse('http://192.168.1.6:8000/api/$url'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
          'Bearer 2|Lzbji78JbbU9O5EtmhYCOYfDczOpL9gZ0q4Jedc99a3311f3'
        },
        body: jsonEncode(body),
      )
          .timeout(Duration(seconds: timeoutDuration)); // إضافة timeout

      print(jsonDecode(response.body));
      return response;
    } on http.ClientException catch (e) {
      print("Client Exception: $e");
      rethrow;
    } on TimeoutException catch (_) {
      print("Request timeout");
      throw Exception("Request timeout");
    }
  }

}

void showErrorSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: AnimatedContainer(
      height: 70,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 10), // مسافة بين الأيقونة والنص
          // النص
          Expanded(
            child: Text(
              message,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
    duration: const Duration(seconds: 4),
  );

  // عرض الـ SnackBar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
