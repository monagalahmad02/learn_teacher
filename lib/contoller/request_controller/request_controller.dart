import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';

import '../../data/model/request_model.dart';

class RequestController extends GetxController {
  RxList<RequestModel> requests = <RequestModel>[].obs;

  Future<void> fetchRequests() async {
    final box = GetStorage();
    final token = box.read('token');

    if (token == null) {
      print('🚫 التوكن غير موجود');
      return;
    }

    final url = Uri.parse("${AppConstant.baseUrl}/get/request/teacher/subject");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> requestsJson = data['requests'];
        requests.value = requestsJson.map((e) => RequestModel.fromJson(e)).toList();
      } else {
        print('');
      }
    } catch (e) {
      print('🚨 Exception: $e');
    }
  }

  String getStatusForSubject(int subjectId) {
    final req = requests.firstWhereOrNull((r) => r.subjectId == subjectId);
    return req?.status ?? 'none';
  }
}
