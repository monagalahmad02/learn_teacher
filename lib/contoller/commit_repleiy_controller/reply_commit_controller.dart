import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:project2teacher/data/constant/app_constant.dart';

class ReplyCommentController extends GetxController {
  final isSending = false.obs;
  final box = GetStorage();

  Future<void> sendReply({
    required int lessonId,
    required String content,
    required int parentId,
  }) async {
    final token = box.read('token');

    if (token == null) {
      Get.snackbar("Error", "No token found in storage");
      return;
    }

    final url = Uri.parse("${AppConstant.baseUrl}/add/comment");

    isSending.value = true;

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // ✅ المصادقة الصحيحة
        },
        body: jsonEncode({
          'lesson_id': lessonId,
          'content': content,
          'parent_id': parentId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Reply added successfully");
      } else {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        Get.snackbar("Error", "Failed to add reply: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar("Error", "An error occurred while sending the reply.");
    } finally {
      isSending.value = false;
    }
  }
}
