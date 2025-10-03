import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../data/constant/app_constant.dart';

class AcceptStudentController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;

  Future<void> acceptRequest(int requestId) async {
    final token = box.read('token');
    if (token == null) {
      print('❌ Token not found for acceptRequest');
      Get.snackbar("Error", "Token not found. Please login.");
      return;
    }

    final url = Uri.parse('${AppConstant.baseUrl}/admin/subject-requests/$requestId');
    print('📤 Sending POST request to accept request ID: $requestId');
    print('📍 Endpoint: $url');
    print('📨 Body: { "status": "accepted" }');
    print('🔐 Token: $token');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // ✅ مهم جدًا
        },
        body: jsonEncode({'status': 'accept'}),
      );

      print('📥 Status Code: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Request accepted successfully.');
        Get.snackbar("Success", "Request accepted.");
      } else {
        final error = jsonDecode(response.body);
        print('❌ Failed to accept request: ${error['message']}');
        Get.snackbar("Error", error['message'] ?? "Failed to accept request.");
      }
    } catch (e) {
      print('🔥 Exception during acceptRequest: $e');
      Get.snackbar("Error", "Error: $e");
    }
  }
}
