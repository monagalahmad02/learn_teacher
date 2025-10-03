import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import '../../data/model/student_model.dart';

class StudentInSubjectController extends GetxController {
  var isLoading = false.obs;
  final RxList<StudentModel> studentModel = <StudentModel>[].obs;
  final storage = GetStorage();

  Future<void> fetchStudentsForTeacher() async {
    final token = storage.read('token');
    final url = Uri.parse('${AppConstant.baseUrl}/get/students/teacher');

    if (token == null) {
      Get.snackbar("خطأ", "التوكن غير موجود");
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        /// الريسبونس فيه student_id + student{}
        final List list = data['students'];

        studentModel.value =
            list.map((e) => StudentModel.fromJson(e['student'])).toList();

        print("✅ Students fetched: ${studentModel.length}");
      } else {
        Get.snackbar("فشل", "فشل في جلب البيانات: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ: $e");
      print("❌ Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
