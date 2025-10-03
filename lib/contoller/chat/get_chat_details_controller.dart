import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';

import '../../data/model/get_details_chat_model.dart';

class ChatDetailsController extends GetxController {
  var isLoading = false.obs;
  var chatDetails = Rxn<GetChatDetailsModel>();

  final box = GetStorage();

  Future<void> fetchChatDetails(int conversationId) async {
    try {
      isLoading.value = true;

      String? token = box.read('token');

      final response = await http.get(
        Uri.parse("${AppConstant.baseUrl}/get/my/massage/$conversationId"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // مسح البيانات القديمة قبل إضافة الجديد
        chatDetails.value = GetChatDetailsModel.fromJson(data);
      } else {
        Get.snackbar(
            "Error", "Failed to fetch chat details: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
