import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';  // استيراد مكتبة GetStorage
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import 'package:project2teacher/data/model/lesson_model.dart';

class AddLessonController extends GetxController {
  var isLoading = false.obs;
  var lessonList = <LessonModel>[].obs;

  final TextEditingController titleController = TextEditingController();
  final box = GetStorage();  // إنشاء كائن التخزين

  String get token => box.read('token') ?? '';

  Future<void> fetchLessons(int subjectId) async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('${AppConstant.baseUrl}/lessons?subject_id=$subjectId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        lessonList.value = (data['lessons'] as List)
            .map((e) => LessonModel.fromJson(e))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch lessons');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<bool> addLesson(int subjectId, String title,) async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('${AppConstant.baseUrl}/add/lesson'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'subject_id': subjectId,
          'title': title,
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Token: ${token}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchLessons(subjectId);
        Get.snackbar('Success', 'Lesson added successfully');
        return true;
      } else {
        final errorData = json.decode(response.body);
        Get.snackbar('Error', errorData['message'] ?? 'Failed to add lesson');
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
