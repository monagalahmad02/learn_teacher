import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:project2teacher/data/constant/app_constant.dart';
import '../../data/model/reply_commit_model.dart';

class ReplyListController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var replies = <ReplyCommitModel>[].obs;

  Future<void> fetchReplies(int commentId) async {
    final token = box.read('token');

    if (token == null) {
      Get.snackbar("Error", "No token found in storage");
      return;
    }

    final url = Uri.parse("${AppConstant.baseUrl}/get/replies/comment/$commentId");

    isLoading.value = true;

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',  // أو 'token': token حسب API عندك
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        replies.value = data.map((json) => ReplyCommitModel.fromJson(json)).toList();
      } else {
        Get.snackbar("Error", "Failed to fetch replies: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while fetching replies.");
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
