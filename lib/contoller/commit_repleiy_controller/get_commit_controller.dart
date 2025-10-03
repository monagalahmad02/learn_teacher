import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';

import '../../data/model/commit_model.dart';

class CommentController extends GetxController {
  final comments = <CommitModel>[].obs;
  final isLoading = false.obs;

  final box = GetStorage();

  Future<void> fetchCommentsForLesson(int lessonId) async {
    final token = box.read('token');
    final url = Uri.parse("${AppConstant.baseUrl}/get/comment/lesson/$lessonId");

    print('🔄 Fetching comments for lesson ID: $lessonId');
    print('📦 Token: $token');
    print('🌐 URL: $url');

    isLoading.value = true;

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('✅ Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('🧩 Parsed JSON List: $jsonData');

        comments.value = jsonData.map((e) => CommitModel.fromJson(e)).toList();

        print('📃 Loaded ${comments.length} comments.');
      } else {
        print('❌ Failed to fetch comments. Status: ${response.statusCode}');
        Get.snackbar("Error", "Failed to fetch comments: ${response.statusCode}");
      }
    } catch (e) {
      print('🚨 Exception during comment fetch: $e');
      Get.snackbar("Error", "An error occurred while connecting to the server.");
    } finally {
      isLoading.value = false;
      print('✅ Loading finished.');
    }
  }
}
