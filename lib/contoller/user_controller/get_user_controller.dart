import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import '../../data/model/user_model.dart';

class UserController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;

  final Rxn<UserModel2> user = Rxn<UserModel2>();

  String get token => box.read('token') ?? '';

  Future<void> fetchUser() async {
    try {
      isLoading(true);

      print("📤 Sending request to get user data...");
      print("🔑 Token: $token");

      final response = await http.get(
        Uri.parse('${AppConstant.baseUrl}/get/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("📥 Response Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        /// ✅ هنا نأخذ أول عنصر من القائمة
        user.value = UserModel2.fromJson(data['user'][0]);

        print("✅ User fetched successfully:");
        print("👤 Name: ${user.value?.name}");
        print("📧 Email: ${user.value?.email}");
        print("📱 Phone: ${user.value?.phone}");
      } else {
        print("❌ Failed to fetch user data.");
        Get.snackbar('خطأ', 'فشل في جلب بيانات المستخدم');
      }
    } catch (e) {
      print("⚠️ Exception occurred while fetching user: $e");
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
