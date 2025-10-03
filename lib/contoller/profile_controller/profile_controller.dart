import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:project2teacher/data/constant/app_constant.dart';

import '../../data/model/profile_model.dart';

class ProfileController extends GetxController {
  final storage = GetStorage();
  var isLoading = false.obs;
  var profile = Rxn<ProfileModel>();

  Future<void> fetchProfile(int teacherId) async {
    final token = storage.read('token');
    if (token == null) {
      Get.snackbar("Error", "Token not found");
      print("❌ No token found in GetStorage");
      return;
    }

    final url = Uri.parse("${AppConstant.baseUrl}/get/profile/teacher/$teacherId");

    try {
      isLoading.value = true;
      print("📡 Fetching profile from $url");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        profile.value = ProfileModel.fromJson(data);
        print("✅ Profile loaded successfully");
      } else {
        print("❌ Failed to load profile: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception while fetching profile: $e");
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
