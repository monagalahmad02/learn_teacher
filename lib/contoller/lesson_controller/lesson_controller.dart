import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import 'package:project2teacher/data/model/lesson_model.dart';

class LessonController extends GetxController {
  var isLoading = false.obs;
  var lessonList = <LessonModel>[].obs;

  final box = GetStorage();

  Future<void> fetchLessons(int subjectId) async {
    isLoading.value = true;

    final teacherId = box.read('teacherId');
    final token = box.read('token');

    print('📦 Fetching Lessons...');
    print('📌 subject_id: $subjectId');
    print('👨‍🏫 teacher_id: $teacherId');
    print('🔐 token: $token');

    if (teacherId == null || token == null) {
      print('❌ teacher_id or token is null!');
      Get.snackbar('Error', 'Missing teacher ID or token. Please login again.');
      isLoading.value = false;
      return;
    }

    final url = Uri.parse('${AppConstant.baseUrl}/get/lessons/teacher/$teacherId');
    print('🌍 URL: $url');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'subject_id': subjectId}),
      );

      print('📬 Response Status Code: ${response.statusCode}');
      print('📨 Response Body:\n${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final List lessonJsonList = data['lessons'];
        lessonList.value = lessonJsonList.map((e) => LessonModel.fromJson(e)).toList();
        print('✅ Parsed Lessons: ${lessonList.length}');
      } else {
        try {
          final decodedError = jsonDecode(response.body);
          final errorMsg = decodedError['message'] ?? '❗ Unknown error occurred.';
          print('⚠️ API Error Message: $errorMsg');
          Get.snackbar('Error', errorMsg);
        } catch (jsonErr) {
          print('❌ Failed to parse error response: $jsonErr');
          print('📄 Raw error body: ${response.body}');
          Get.snackbar('Error', 'Something went wrong with the request.');
        }
      }
    } catch (e, stacktrace) {
      print('❌ Exception caught: $e');
      print('📛 Stacktrace:\n$stacktrace');
      Get.snackbar('Error', 'An unexpected error occurred. Please check your connection.');
    } finally {
      isLoading.value = false;
      print('🔚 Done fetching lessons.');
    }
  }
}
