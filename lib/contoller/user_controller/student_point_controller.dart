import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import '../../data/model/student_point_model.dart';

class StudentPointsController extends GetxController {
  var studentPoints = <StudentPoints>[].obs;
  var isLoading = false.obs;
  final storage = GetStorage();

  Future<void> fetchStudentPoints() async {
    isLoading.value = true;
    final token = storage.read('token'); // قراءة التوكن

    final url = Uri.parse('${AppConstant.baseUrl}/get/points/students/teacher');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        studentPoints.value = (data['students_points'] as List<dynamic>)
            .map((e) => StudentPoints.fromJson(e))
            .toList();
        print('تم جلب ${studentPoints.length} نقاط طلاب');
      } else {
        print('خطأ في جلب النقاط: ${response.statusCode}');
        if (!Get.isSnackbarOpen) {
          Get.snackbar('خطأ', 'فشل في جلب النقاط: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('حدث خطأ: $e');
      if (!Get.isSnackbarOpen) {
        Get.snackbar('خطأ', 'حدث خطأ أثناء الاتصال بالخادم');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
