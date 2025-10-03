import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';

class AddMultipleFavoriteStudentsController extends GetxController {
  final box = GetStorage();

  Future<void> addStudentsToFavorites(List<int> studentIds) async {
    final token = box.read('token');
    if (token == null) {
      print('❌ Token not found.');
      Get.snackbar("Authentication Error", "Token not found. Please login again.");
      return;
    }

    final url = Uri.parse('${AppConstant.baseUrl}/add/favorite/students');
    print('📡 Sending request to: $url');
    print('🧾 Token: $token');
    print('📦 Student IDs: $studentIds');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'student_ids': studentIds,
        }),
      );

      print('📥 Status code: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      final data = jsonDecode(response.body);
      final message = data['message'] ?? 'No message from server';
      final List<dynamic> added = data['added'] ?? [];
      final List<dynamic> skipped = data['skipped'] ?? [];

      print('✅ Added: $added');
      print('⏭️ Skipped (already in favorites): $skipped');

      if (response.statusCode == 200) {
        // إذا لم يتم إضافة أحد وتم تخطي الكل
        if (added.isEmpty && skipped.isNotEmpty) {
          Get.snackbar(
            'Notice',
            'All selected students are already in favorites.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.shade100,
            colorText: Colors.teal,
            duration: const Duration(seconds: 3),
          );
        }
        // إذا تم إضافة جزئي وتم تخطي جزئي
        else if (added.isNotEmpty && skipped.isNotEmpty) {
          Get.snackbar(
            'Partial Success',
            'Added: ${added.length}, Skipped: ${skipped.length}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.amber.shade100,
            colorText: Colors.teal,
            duration: const Duration(seconds: 3),
          );
        }
        // تم إضافة الكل بنجاح
        else if (added.isNotEmpty && skipped.isEmpty) {
          Get.snackbar(
            'Success',
            'All students added to favorites.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.teal.withOpacity(0.2),
            colorText: Colors.black,
            duration: const Duration(seconds: 3),
          );
        } else {
          // حالة نادرة (لا تمت إضافة أحد ولا تخطي أحد)
          Get.snackbar(
            'Info',
            message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.grey.shade200,
            colorText: Colors.black,
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.2),
          colorText: Colors.black,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('🔥 Exception: $e');
      Get.snackbar(
        'Exception',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.2),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
