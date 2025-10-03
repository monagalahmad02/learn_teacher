import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../data/constant/app_constant.dart';

class DeleteQuestionController extends GetxController {
  final box = GetStorage();

  Future<void> deleteQuestion(int questionId) async {
    print('🚨 بدء عملية حذف السؤال ID = $questionId');

    // قراءة التوكن من التخزين
    final token = box.read('token');
    print('🔑 التوكن الموجود: ${token != null ? "تم العثور عليه" : "غير موجود"}');

    if (token == null || token.isEmpty) {
      print('❌ لم يتم العثور على توكن في GetStorage.');
      Get.snackbar("Error", "Authentication token not found.");
      return;
    }

    final url = Uri.parse('${AppConstant.baseUrl}/delet-question/$questionId');
    print('🗑️ سيتم إرسال طلب حذف إلى: $url');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 تم استلام الرد من السيرفر');
      print('📊 كود الاستجابة: ${response.statusCode}');
      print('📄 جسم الاستجابة: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ تم حذف السؤال بنجاح من السيرفر.');
        Get.snackbar("Success", "Question deleted successfully.");
      } else {
        try {
          final data = jsonDecode(response.body);
          print('❌ خطأ من السيرفر: ${data['message'] ?? "رسالة غير معروفة"}');
          Get.snackbar("Error", data['message'] ?? "Failed to delete question.");
        } catch (e) {
          print('❌ لم يتمكن من قراءة رسالة الخطأ من الرد.');
          Get.snackbar("Error", "Failed to delete question.");
        }
      }
    } catch (e) {
      print('🔥 حصل استثناء أثناء محاولة الحذف: $e');
      Get.snackbar("Error", "Something went wrong: $e");
    }

    print('📍 نهاية عملية الحذف\n');
  }
}
