import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import '../../data/model/student_model.dart';

class GetStudentsController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var studentsList = <StudentModel>[].obs;

  Future<void> fetchAllStudents() async {
    final token = box.read('token');
    final url = Uri.parse("${AppConstant.baseUrl}/get/students");

    print('📡 [FETCH STUDENTS] Starting fetch...');
    print('🔗 URL: $url');
    print('🔐 Token: $token');

    isLoading.value = true;

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          // إذا API يحتاج توكن، أضف السطر التالي:
          // 'Authorization': 'Bearer $token',
        },
      );

      print('📥 [RESPONSE STATUS]: ${response.statusCode}');
      print('📄 [RESPONSE BODY]: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          studentsList.value = data.map((e) => StudentModel.fromJson(e)).toList();
          print('✅ [SUCCESS] Loaded ${studentsList.length} students.');
        } else {
          print('❗️ [ERROR] Unexpected data format from server.');
          Get.snackbar("Error", "Unexpected data format from server.");
        }
      } else {
        final error = jsonDecode(response.body);
        print('❌ [SERVER ERROR] ${error['message']}');
        Get.snackbar("Error", error['message'] ?? 'Failed to load students');
      }
    } catch (e) {
      print('🔥 [EXCEPTION] $e');
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
      print('🔚 [FETCH COMPLETE]');
    }
  }
}
