import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import '../../data/model/notification_model.dart';

class NotificationsController extends GetxController {
  var isLoading = false.obs;
  var notifications = <NotificationItem>[].obs;
  var unreadCount = 0.obs;

  final String baseUrl = "${AppConstant.baseUrl}/notifications";

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
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
        final model = NotificationModel.fromJson(data);

        notifications.value = model.data?.notifications ?? [];
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
