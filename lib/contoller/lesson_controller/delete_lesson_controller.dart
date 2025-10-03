import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import '../../data/model/lesson_model.dart';

class DeleteLessonController extends GetxController {
  var lessonList = <LessonModel>[].obs;
  var isLoading = false.obs;

  final box = GetStorage();

  Future<void> fetchLessons(int subjectId) async {
    isLoading.value = true;
    final token = box.read('token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('${AppConstant.baseUrl}/viewlesson/$subjectId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final lessons = (data['questions'] as List)
            .map((json) => LessonModel.fromJson(json))
            .toList();

        lessonList.assignAll(lessons);
      } else {
        Get.snackbar('Error', 'Failed to fetch lessons');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteLesson(int lessonId) async {
    isLoading.value = true;
    final token = box.read('token') ?? '';

    try {
      final response = await http.delete(
        Uri.parse('${AppConstant.baseUrl}/delete/lesson/$lessonId'), //http://192.168.1.7:8000/api/delete/lesson/5
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // حذف الدرس من القائمة المحلية
        lessonList.removeWhere((lesson) => lesson.id == lessonId);
        Get.snackbar('Success', 'Lesson deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete lesson');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }
}
