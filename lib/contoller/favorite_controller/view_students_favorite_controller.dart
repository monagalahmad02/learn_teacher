import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../data/constant/app_constant.dart';
import '../../data/model/student_model.dart'; // تأكد من المسار الصحيح

class FavoriteStudentsController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var studentsList = <StudentModel>[].obs;

  Future<void> fetchFavoriteStudents() async {
    final token = box.read('token');

    if (token == null) {
      Get.snackbar("Error", "Token not found. Please log in again.");
      return;
    }

    isLoading.value = true;

    final url = Uri.parse("${AppConstant.baseUrl}/teacher_favorite");

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List studentsJson = data['students'] ?? [];
        studentsList.value = studentsJson.map((e) => StudentModel.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", data['message'] ?? 'Failed to fetch students.');
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong.");
    } finally {
      isLoading.value = false;
    }
  }
}
