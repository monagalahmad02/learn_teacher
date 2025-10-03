import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import '../../data/model/question_challenge_model.dart';

class QuestionChallengeController extends GetxController {
  var questions = <QuestionChallengeModel>[].obs;
  var isLoading = false.obs;
  final storage = GetStorage();

  Future<void> fetchChallengeQuestions(int challengeId) async {
    isLoading.value = true;
    final token = storage.read('token');

    final url = Uri.parse('${AppConstant.baseUrl}/get/challenge/$challengeId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        questions.value = data.map((e) => QuestionChallengeModel.fromJson(e)).toList();
        print('تم جلب ${questions.length} سؤال');
      } else {
        print('خطأ في جلب الأسئلة: ${response.statusCode}');
        if (!Get.isSnackbarOpen) {
          Get.snackbar('خطأ', 'فشل في جلب الأسئلة: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('حدث خطأ: $e');
      if (!Get.isSnackbarOpen) {
        Get.snackbar('خطأ', 'حدث خطأ أثناء الاتصال بالخادم');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
