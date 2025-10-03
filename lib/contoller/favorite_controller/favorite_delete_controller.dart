import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../data/constant/app_constant.dart';

class FavoriteDeleteController extends GetxController {
  final box = GetStorage();

  Future<String> deleteFavoriteStudent(int studentId) async {
    final token = box.read('token');
    if (token == null) {
      print('❌ Token not found.');
      return 'Token not found. Please log in again.';
    }

    final url = Uri.parse('${AppConstant.baseUrl}/delete/favorite/student/$studentId');
    print('📡 DELETE Request to: $url');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('🔵 Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('✅ Student deleted successfully.');
        return data['message'] ?? 'Student removed from favorites.';
      } else {
        print('⚠️ Failed to delete student: ${data['message']}');
        return data['message'] ?? 'Failed to remove student.';
      }
    } catch (e) {
      print('❌ Exception occurred: $e');
      return 'Error: ${e.toString()}';
    }
  }
}
