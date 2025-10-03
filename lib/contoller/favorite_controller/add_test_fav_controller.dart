import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import '../../data/constant/app_constant.dart';

class AddTestToFavoriteController extends GetxController {
  final storage = GetStorage();
  var isLoading = false.obs;

  Future<void> createTest({
    required List<int> lessonIds,
    required List<int> questionIds,
  }) async {
    final url = Uri.parse('${AppConstant.baseUrl}/create/test/by/teacher');

    // Get token from storage
    final token = storage.read('token');

    if (token == null || token.isEmpty) {
      Get.snackbar("Warning", "No token found in storage");
      return;
    }

    final body = {
      "question_ids": jsonEncode(questionIds),
    };


    try {
      isLoading(true);

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        Get.snackbar("Success", "Test created successfully");
        Get.back(); // Go back one step
      } else {
        Get.snackbar(
          "Error",
          "Failed to create test: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
}
