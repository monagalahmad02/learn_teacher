import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import 'dart:convert';
import '../../data/model/challenge_model.dart';

class TeacherChallengesController extends GetxController {
  var isLoading = false.obs;
  var challenges = <ChallengeModel>[].obs;

  final storage = GetStorage();

  // استدعاء التحديات للمعلم
  Future<void> fetchTeacherChallenges() async {
    isLoading.value = true;

    try {
      final token = storage.read('token'); // قراءة التوكن من GetStorage
      if (token == null) {
        Get.snackbar('Error', 'Token not found',
            backgroundColor: const Color(0xFFE57373), colorText: Colors.white);
        isLoading.value = false;
        return;
      }

      final url = Uri.parse('${AppConstant.baseUrl}/get/challenges/teacher');

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        challenges.value = data.map((e) => ChallengeModel.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch challenges',
             colorText: Colors.black);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
