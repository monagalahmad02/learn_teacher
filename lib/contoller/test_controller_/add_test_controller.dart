import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import '../../data/constant/app_constant.dart';

class CreateTestController extends GetxController {
  final storage = GetStorage();
  var isLoading = false.obs;

  Future<void> createTest({required List<int> lessonIds}) async {
    isLoading.value = true;

    final token = storage.read('token');
    if (token == null) {
      Get.snackbar("Auth Error", "No token found. Please login.");
      isLoading.value = false;
      return;
    }

    final url = Uri.parse('${AppConstant.baseUrl}/create/test/by/teacher');

    try {
      print('🚀 Sending POST to: $url');
      print('🧾 Body: ${jsonEncode({"lesson_ids": lessonIds})}');
      print('🔑 Token: $token');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
          body: jsonEncode({
            'lesson_ids': jsonEncode(lessonIds),
          }),
      );

      print("📩 Response status: ${response.statusCode}");
      print("📩 Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        Get.snackbar("Success", "Test created successfully");
        print("✅ Success: $data");
      } else {
        final error = json.decode(response.body);
        print("❌ Error: $error");
      }
    } catch (e) {
      print("❗ Exception: $e");
      Get.snackbar("Error", "An unexpected error occurred");
    } finally {
      isLoading.value = false;
    }
  }
}
