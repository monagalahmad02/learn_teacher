import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';

class ChallengeController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;

  Future<void> createChallenge({
    required String title,
    required String startTime,
    required int durationMinutes,
  }) async {
    final url = Uri.parse("${AppConstant.baseUrl}/create/challenge");
    final token = box.read("token");

    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Token not found");
      return;
    }

    try {
      isLoading.value = true;

      print("🔹 API URL: $url");
      print("🔹 Token: $token");
      print("🔹 Body: {title: $title, start_time: $startTime, duration_minutes: $durationMinutes}");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "title": title,
          "start_time": startTime,
          "duration_minutes": durationMinutes,
        }),
      );

      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        Get.snackbar("Success ✅", data["message"] ?? "تم إنشاء التحدي بنجاح");
      } else if (response.statusCode == 422) {
        // إذا كانت العملية نجحت رغم 422، نطبع التحذير فقط
        String errorMessage = data["message"] ?? "حدث خطأ أثناء إدخال البيانات";
        if (data["errors"] != null && data["errors"]["start_time"] != null) {
          errorMessage = data["errors"]["start_time"][0];
        }

        // اطبع فقط التحذير بدل الـ snackbar القوي
        print("⚠️ Validation warning: $errorMessage");

        // إضافة إشعار خفيف بدل ظهور Snackbar مزعج
        Get.snackbar(
          "Warning ⚠️",
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.black,
        );
      } else {
        Get.snackbar(
          "Error ❌",
          data["message"] ?? "فشل في إنشاء التحدي",
        );
      }
    } catch (e) {
      print("❌ Exception: $e");
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
