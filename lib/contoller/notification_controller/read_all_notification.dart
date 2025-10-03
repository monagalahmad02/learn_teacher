import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:project2teacher/data/constant/app_constant.dart';

class ReadAllNotificationsController extends GetxController {
  var isLoading = false.obs;
  final box = GetStorage();
  final String baseUrl = "${AppConstant.baseUrl}/notifications/read-all";

  Future<bool> readAllNotifications() async {
    try {
      isLoading.value = true;

      String? token = box.read("token");
      if (token == null) {
        print("⚠️ No token found in GetStorage");
        return false;
      }

      final response = await http.put(
        Uri.parse(baseUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print("✅ All notifications marked as read");
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
