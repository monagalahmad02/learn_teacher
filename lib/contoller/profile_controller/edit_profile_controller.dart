import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';

class EditProfileController extends GetxController {
  final box = GetStorage();

  final TextEditingController teachingDateController = TextEditingController();

  final teachingStartDate = ''.obs;
  final province = ''.obs;
  final specialization = ''.obs;
  final bio = ''.obs;
  final age = ''.obs;

  final isLoading = false.obs;

  late String token;

  @override
  void onInit() {
    super.onInit();
    token = box.read('token') ?? '';
  }

  @override
  void onClose() {
    teachingDateController.dispose();
    super.onClose();
  }


  Future<void> submitProfile() async {
    if (token.isEmpty) {
      Get.snackbar('خطأ', 'التوكن غير موجود');
      return;
    }

    isLoading.value = true;

    final url = Uri.parse('${AppConstant.baseUrl}/add/details/teacher');
    final body = {
      "teaching_start_date": teachingStartDate.value,
      "province": province.value,
      "specialization": specialization.value,
      "bio": bio.value,
      "age": age.value,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'success edit profile');
      } else {
        Get.snackbar('Error', 'error edit: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'an error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
