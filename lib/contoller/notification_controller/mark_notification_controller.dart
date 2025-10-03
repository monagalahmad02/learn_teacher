import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:project2teacher/data/constant/app_constant.dart';

class MarkNotificationReadController extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();

  Future<bool> markAsRead(String notificationId) async {
    try {
      isLoading.value = true;

      String? token = box.read("token");
      if (token == null) {
        print("⚠️ No token found in GetStorage");
        return false;
      }

      final String url = "${AppConstant.baseUrl}/notifications/$notificationId/read";

      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print("✅ Notification $notificationId marked as read");
        return true;
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Exception: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
