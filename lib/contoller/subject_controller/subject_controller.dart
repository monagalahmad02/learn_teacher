import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/constant/app_constant.dart';
import '../../data/model/subject_model.dart';

class SubjectController extends GetxController {
  var isLoading = false.obs;
  var subjectList = <SubjectModel>[].obs;

  final box = GetStorage();

  Future<void> fetchSubjects() async {
    print('🔁 Starting fetchSubjects()...');
    isLoading.value = true;

    final token = box.read('token');
    print('🔐 Token from storage: $token');

    if (token == null) {
      Get.snackbar('Error', 'No token found. Please login again.');
      print('❌ No token found. Aborting request.');
      isLoading.value = false;
      return;
    }

    final url = Uri.parse('${AppConstant.baseUrl}/get/subjects');
    print('🌐 Request URL: $url');

    try {
      print('📤 Sending GET request...');
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('✅ Response received!');
      print('🔵 Status Code: ${response.statusCode}');
      print('📦 Raw Response Body: ${response.body}');

      final data = jsonDecode(response.body);
      print('📄 Decoded JSON: $data');

      if (response.statusCode == 200) {
        final List subjectsJson = data['subjects'];
        print('📚 Subjects JSON List: $subjectsJson');
        print('📦 Mapping JSON to SubjectModel list...');

        subjectList.value = subjectsJson
            .map((json) => SubjectModel.fromJson(json))
            .toList();

        print('✅ Subjects Loaded Successfully!');
        print('📊 Total Subjects: ${subjectList.length}');
        for (var subject in subjectList) {
          print('🔹 Subject: ${subject.title}');
        }
      } else {
        final error = data['message'] ?? 'Failed to load subjects';
        print('❌ Server Error Message: $error');
        Get.snackbar('Error', error);
      }
    } catch (e) {
      print('❌ Exception occurred: $e');
      Get.snackbar('Error', 'Something went wrong while fetching subjects.');
    } finally {
      isLoading.value = false;
      print('🔚 Finished fetchSubjects()');
    }
  }
}
