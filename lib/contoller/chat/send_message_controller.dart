import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import '../../data/model/get_details_chat_model.dart';

class ChatSendMessageController extends GetxController {
  var isLoading = false.obs;
  var chatDetails = Rx<GetChatDetailsModel?>(null);

  final storage = GetStorage();

  // دالة لجلب تفاصيل المحادثة
  Future<void> fetchChatDetails(int conversationId) async {
    try {
      isLoading.value = true;

      // جلب التوكن من التخزين
      String? token = storage.read('token');

      final response = await http.get(
        Uri.parse("${AppConstant.baseUrl}/get/my/massage/$conversationId"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        chatDetails.value = GetChatDetailsModel.fromJson(data);
      } else {
        Get.snackbar("Error", "Failed to fetch chat details: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(int conversationId, String message) async {
    final token = storage.read('token'); // جلب التوكن من GetStorage
    if (token == null) {
      Get.snackbar('خطأ', 'التوكن غير موجود');
      return;
    }

    final url = Uri.parse('${AppConstant.baseUrl}/send/message/$conversationId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // إعادة تحميل الرسائل بعد الإرسال
        fetchChatDetails(conversationId);
      } else {
        Get.snackbar('خطأ', 'فشل إرسال الرسالة');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'هناك مشكلة بالاتصال');
    }
  }
}
