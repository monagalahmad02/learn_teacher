import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project2teacher/data/constant/app_constant.dart';
import 'dart:convert';
import '../../data/model/fav_test_model.dart';

class FavTestController extends GetxController {
  var isLoading = false.obs;
  var tests = <FavTestModel>[].obs;

  Future<void> fetchFavTests() async {
    isLoading.value = true;
    const String url = '${AppConstant.baseUrl}/get/all/tests';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> data = body['tests'];

        tests.value = data.map((e) => FavTestModel.fromJson(e)).toList();

        print("✅ Loaded ${tests.length} tests");
      } else {
        print("❌ Failed to load tests. Status: ${response.statusCode}");
        Get.snackbar('Error', 'Failed to fetch tests');
      }
    } catch (e) {
      print("❗ Exception: $e");
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }

  int getNextTestId() {
    if (tests.isEmpty) return 1;
    final maxId = tests.map((e) => e.id).reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }
}


