import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:project2teacher/data/constant/app_constant.dart';
import '../../data/model/notification_unread_count_model.dart';

class NotificationUnreadCountController extends GetxController {
  var unreadCount = 0.obs;
  var isLoading = false.obs;

  final String baseUrl = "${AppConstant.baseUrl}/notifications/unread-count";
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchUnreadCount();
  }

  Future<void> fetchUnreadCount() async {
    try {
      isLoading.value = true;

      String? token = box.read("token");

      if (token == null) {
        print("⚠️ No token found in GetStorage");
        return;
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final model = NotificationUnreadCountModel.fromJson(data);

        unreadCount.value = model.unreadCount ?? 0;
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("⚠️ Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
