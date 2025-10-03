import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../data/constant/app_constant.dart';
import '../../data/model/quection_model.dart';

class QuestionController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var questionList = <QuestionModel>[].obs;

  Future<void> fetchQuestionsByLesson(int lessonId) async {
    final token = box.read('token');

    if (token == null) {
      print('❌ Token not found.');
      Get.snackbar("Error", "Authentication token not found.");
      return;
    }

    final url = Uri.parse('${AppConstant.baseUrl}/get/questions/lesson/$lessonId');
    print('📡 GET: $url');

    isLoading.value = true;

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
      );

      print('📥 Status Code: ${response.statusCode}');
      print('📄 Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data is List) {
          questionList.value =
              data.map((e) => QuestionModel.fromJson(e)).toList();
          print('✅ Loaded ${questionList.length} questions.');
        } else {
          print('⚠️ Unexpected response format.');
        }
      } else if (response.statusCode == 404) {
        final error = jsonDecode(response.body);
        print('❌ No questions found: ${error['message']}');
        questionList.clear(); // 🟢 ضروري لمسح القائمة في الواجهة
      } else {
        final error = jsonDecode(response.body);
        print('❌ Server error: ${error['message'] ?? "Unknown error"}');
      }
    } catch (e) {
      print('🔥 Exception: $e');
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
