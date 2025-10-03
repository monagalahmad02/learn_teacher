import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../data/constant/app_constant.dart';

class ChangePasswordController extends GetxController {
  final box = GetStorage();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  RxBool showOldPassword = false.obs;
  RxBool showNewPassword = false.obs;

  Future<String> changePassword() async {
    final token = box.read('token');
    if (token == null) {
      return 'Token not found. Please login again.';
    }

    final url = Uri.parse('${AppConstant.baseUrl}/change-password');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'old_password': oldPasswordController.text,
          'new_password': newPasswordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['message'] ?? 'Password changed successfully.';
      } else {
        return data['message'] ?? 'Failed to change password.';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
