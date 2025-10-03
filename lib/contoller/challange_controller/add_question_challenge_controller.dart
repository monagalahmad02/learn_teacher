import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../data/constant/app_constant.dart';

class Challenge1Controller {
  final box = GetStorage();

  Future<Map<String, dynamic>> addQuestionToChallenge({
    required int challengeId,
    required int questionId,
  }) async {
    // طباعة عند استرجاع التوكن
    final token = box.read('token');
    print("Token from storage: $token");

    if (token == null) {
      print("No token found, throwing exception.");
      throw Exception("No token found in storage");
    }

    final url = Uri.parse('${AppConstant.baseUrl}/add/question/challenge/$challengeId');
    print("Request URL: $url");

    final body = jsonEncode({'question_id': questionId});
    print("Request body: $body");

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print("Request headers: $headers");

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    print("Response status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      print("Decoded response: $decoded");
      return decoded;
    } else {
      print("Request failed with status: ${response.statusCode}");
      throw Exception('Failed to add question: ${response.body}');
    }
  }
}
