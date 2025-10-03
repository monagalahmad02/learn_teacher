import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import '../../data/model/get_all_chat_model.dart';

class ChatController extends GetxController {
  var isLoading = false.obs;
  var chats = <GetChatModel>[].obs;

  final box = GetStorage();

  Future<void> fetchChats() async {
    try {
      isLoading.value = true;

      // قراءة التوكن المخزن
      String? token = box.read('token');

      final response = await http.get(
        Uri.parse("${AppConstant.baseUrl}/get/my/coversation"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        chats.value =
            data.map((e) => GetChatModel.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", "Failed to fetch chats: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
