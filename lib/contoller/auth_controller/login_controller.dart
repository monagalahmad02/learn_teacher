import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../data/constant/app_constant.dart';
import '../../widght/home_page/home_page.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var obscurePassword = true.obs;

  final box = GetStorage();

  Future<void> login(String phone, String password) async {
    isLoading.value = true;

    final url = Uri.parse('${AppConstant.baseUrl}/login');

    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          'phone': phone,
          'password': password,
        },
      );

      print('🔵 Status Code: ${response.statusCode}');
      print('🔵 Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['access_token'] ?? data['token'];
        final teacherData = data['user'] ?? data['teacher']; // يعتمد على استجابة API
        final teacherId = teacherData != null ? teacherData['id'] : null;

        if (token != null && token.toString().isNotEmpty && teacherId != null) {
          box.write('token', token);
          box.write('teacherId', teacherId); // 👍 هذا هو التصحيح

          print('✅ Token saved: $token');
          print('✅ Teacher ID saved: $teacherId');

          Get.snackbar('Success', 'Logged in successfully');
          final tid = teacherData['id'];
          Get.offAll(() => HomePage(teacherId: tid));
        } else {
          Get.snackbar('Error', 'Token or Teacher ID not found in response.');
        }
      } else {
        final message = data['message'] ?? 'Login failed. Please try again.';
        Get.snackbar('Login Failed', message);
      }
    } catch (e) {
      print('❌ Exception: $e');
      Get.snackbar('Error', 'Unable to connect. Check your internet or server.');
    } finally {
      isLoading.value = false;
    }
  }

  String? getToken() => box.read('token');
  int? getTeacherId() => box.read('teacherId');

  void logout() {
    box.remove('token');
    box.remove('teacherId');
    Get.offAllNamed('/login');
  }
}
