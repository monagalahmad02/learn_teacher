import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import '../../data/model/test_model.dart';

class TestController {

  static Future<TestModel> fetchTestById(int testId) async {
    final url = Uri.parse('${AppConstant.baseUrl}/get/questions/test/$testId');
    print('🔗 إرسال طلب إلى: $url');

    try {
      final response = await http.get(url);
      print('📥 تم استقبال الاستجابة بكود: ${response.statusCode}');

      if (response.statusCode == 200) {
        final String rawBody = response.body;
        print('📦 البيانات الخام المستلمة:');
        print(rawBody);

        final List<dynamic> data = json.decode(rawBody);
        print('✅ تم فك التشفير JSON، عدد الأسئلة: ${data.length}');

        final questions = data.map((q) {
          print('🧩 سؤال قيد المعالجة: ${q['question_text']}');
          return Question.fromJson(q);
        }).toList();

        final test = TestModel(
          testId: testId,
          questions: questions,
        );

        print('🎯 تم إنشاء TestModel بنجاح: testId=${test.testId}');
        return test;
      } else {
        print('❌ فشل في جلب البيانات، كود: ${response.statusCode}');
        throw Exception('فشل في جلب بيانات الاختبار');
      }
    } catch (e) {
      print('⚠️ استثناء أثناء جلب البيانات: $e');
      throw Exception('خطأ في الاتصال أو التحويل: $e');
    }
  }

}
