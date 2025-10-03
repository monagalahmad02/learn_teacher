import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';

class LogOutController extends GetxController {
  final box = GetStorage();

  Future<void> logout() async {
    final token = box.read('token');

    if (token == null) {
      print("لا يوجد توكن مخزن");
      return;
    }

    final url = Uri.parse('${AppConstant.baseUrl}/logout');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        box.remove('token');
        print('تم تسجيل الخروج بنجاح');
        Get.offAllNamed('/login');
      } else {
        print('فشل تسجيل الخروج: ${response.body}');
      }
    } catch (e) {
      print('خطأ في الاتصال بالسيرفر: $e');
    }
  }
}
