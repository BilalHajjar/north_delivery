import 'package:shared_preferences/shared_preferences.dart';

//name project_id type_ user_id
class CacheHelper {
  ///هي دالة واحدة للتخزين في كاش و تتعرف على القيمة المراد تخزينها
  static saveData({required String key, required dynamic value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value is String) {
      return await prefs.setString(key, value);
    } else if (value is bool) {
      return await prefs.setBool(key, value);
    } else if (value is int) {
      return await prefs.setInt(key, value);
    } else if (value is double) {
      return await prefs.setDouble(key, value);
    } else {
      throw Exception('Unsupported value type');
    }
  }
static removeData({required String key})async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
 await prefs.remove(key);
}
///هذه الدوال لجلب القيم من الذاكرة كاش و يجب ادخال البارامتر الذي يمثل المفتاح
   getDataString({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
  getDataInt({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }
  getDataBool({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
  getDataDouble({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

}
