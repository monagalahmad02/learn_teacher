import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:project2teacher/data/constant/app_constant.dart';

class DeleteNotificationController extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();

  Future<bool> deleteNotification(String notificationId) async {
    try {
      isLoading.value = true;

      String? token = box.read("token");
      if (token == null) {
        print("⚠️ No token found in GetStorage");
        return false;
      }

      final String url = "${AppConstant.baseUrl}/notifications/$notificationId";

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("✅ Notification $notificationId deleted successfully");
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
