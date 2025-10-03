import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';

import '../../data/model/requst_student_model.dart';

class RequestsStudentController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var requestsList = <RequestStudentModel>[].obs;

  Future<void> fetchRequests() async {
    final token = box.read('token');

    if (token == null) {
      print('❌ Token not found in storage');
      Get.snackbar("Authentication Error", "Token not found. Please login again.");
      return;
    }

    final url = Uri.parse('${AppConstant.baseUrl}/admin/subject-requests');
    print('📡 Sending GET request to: $url');
    print('🔐 Using token: $token');

    isLoading.value = true;

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Status Code: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          requestsList.value = data.map((e) => RequestStudentModel.fromJson(e)).toList();
          print('✅ Loaded ${requestsList.length} requests.');
        } else {
          print('⚠️ Unexpected data format: ${data.runtimeType}');
          Get.snackbar("Error", "Unexpected data format from server.");
        }
      } else {
        final error = jsonDecode(response.body);
        print('❗ Server returned error: ${error['message']}');
        Get.snackbar("Error", error['message'] ?? 'Failed to load requests.');
      }
    } catch (e) {
      print('🔥 Exception occurred: $e');
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
      print('🔚 Done loading requests.');
    }
  }
}
