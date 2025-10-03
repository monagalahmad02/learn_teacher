import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import 'dart:convert';
import '../../data/model/view_bank_quastion_model.dart';

class QuestionController extends GetxController {
  final questions = <ViewBankQuestionModel>[].obs;
  final isLoading = false.obs;

  final storage = GetStorage();

  Future<void> fetchQuestionsByTeacher() async {
    try {
      isLoading.value = true;

      // قراءة التوكن من GetStorage
      String? token = storage.read("token");

      if (token == null) {
        Get.snackbar("خطأ", "لم يتم العثور على التوكن");
        isLoading.value = false;
        return;
      }

      var response = await http.get(
        Uri.parse("${AppConstant.baseUrl}/get/all/questions/by/teacher"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data is List) {
          questions.value = data
              .map((item) => ViewBankQuestionModel.fromJson(item))
              .toList();
        } else {
          Get.snackbar("خطأ", "صيغة البيانات غير صحيحة");
        }
      } else {
        Get.snackbar("خطأ", "فشل في جلب البيانات: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
