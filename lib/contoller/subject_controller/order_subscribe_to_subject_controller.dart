import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:project2teacher/data/constant/app_constant.dart';

class OrderSubscribeToSubjectController {
  Future<String> joinSubject({required int subjectId}) async {
    final box = GetStorage();
    final token = box.read('token');

    if (token == null) {
      return '🚫 لم يتم العثور على التوكن. الرجاء تسجيل الدخول.';
    }

    final url = Uri.parse('${AppConstant.baseUrl}/request/teacher/join/subject');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'subject_id': subjectId,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return '✅ تم إرسال طلب الاشتراك بنجاح!';
      } else if (response.statusCode == 400 && data['message'] != null) {
        return '⚠️ ${data['message']}';
      } else {
        return '❌ فشل الطلب: ${response.reasonPhrase}';
      }
    } catch (e) {
      return '🚨 حدث خطأ غير متوقع: $e';
    }
  }
}
