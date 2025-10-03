import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';

class AddQuestionController extends GetxController {
  final isLoading = false.obs;
  final box = GetStorage();

  String get token => box.read('token') ?? '';

  final TextEditingController questionTextController = TextEditingController();
  final TextEditingController explanationController = TextEditingController();
  final TextEditingController pageNumberController = TextEditingController();
  final TextEditingController correctOptionController = TextEditingController();

  /// تستخدم هذا الميثود لإرسال الطلب
  Future<bool> addQuestion({
    required int lessonId,
    required List<Map<String, dynamic>> options,
  }) async {
    try {
      isLoading(true);

      final response = await http.post(
        Uri.parse('${AppConstant.baseUrl}/add-question'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "lesson_id": lessonId,
          "question_text": questionTextController.text.trim(),
          "page_number": int.tryParse(pageNumberController.text.trim()) ?? 1,
          "explanation": explanationController.text.trim(),
          "correct_option": int.tryParse(correctOptionController.text.trim()) ?? 0,
          "options": options,
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Question added successfully');
        print('✅ Snackbar for success shown');
        return true;

    } else {
        final errorData = json.decode(response.body);
        Get.snackbar('Error', errorData['message'] ?? 'Failed to add question');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading(false);
    }
  }
}
