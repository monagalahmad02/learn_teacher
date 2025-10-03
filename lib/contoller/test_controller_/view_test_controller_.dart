import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import 'dart:convert';
import '../../data/model/test_model1.dart';

class AllTestsController extends GetxController {
  var isLoading = false.obs;
  var tests = <TestModel1>[].obs;

  Future<void> fetchAllTests() async {
    isLoading.value = true;
    print('🔄 Starting fetchAllTests...');

    try {
      final response = await http.get(Uri.parse("${AppConstant.baseUrl}/get/all/tests"));
      print('📡 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> data = body['tests'];
        print('✅ Parsed data length: ${data.length}');

        tests.value = data.map((json) => TestModel1.fromJson(json)).toList();

        for (var test in tests) {
          print('🧪 Test loaded: ${test.testName}');
        }
      } else {
        print('❌ Failed with status: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to load tests: ${response.statusCode}');
      }
    } catch (e) {
      print('❗ Exception occurred: $e');
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
      print('✅ fetchAllTests finished');
    }
  }
}
