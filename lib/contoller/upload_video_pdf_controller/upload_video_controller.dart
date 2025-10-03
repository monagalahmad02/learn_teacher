import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:project2teacher/data/constant/app_constant.dart';

class AddVideoController extends GetxController {
  final storage = GetStorage();
  var isUploading = false.obs;

  Future<void> uploadVideo({required int lessonId, required File videoFile}) async {
    final token = storage.read('token');

    if (token == null) {
      Get.snackbar("Error", "Token not found");
      print("❌ No token found in GetStorage");
      return;
    }

    final url = Uri.parse("${AppConstant.baseUrl}/add/video/lesson/$lessonId");

    try {
      isUploading.value = true;

      print("📤 Starting video upload...");
      print("🎯 Endpoint: $url");
      print("📦 File size: ${videoFile.lengthSync() / (1024 * 1024)} MB");
      print("🧾 File name: ${basename(videoFile.path)}");

      final request = http.MultipartRequest("POST", url);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.files.add(await http.MultipartFile.fromPath(
        'video',
        videoFile.path,
        filename: basename(videoFile.path),
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Video uploaded successfully");
        print("✅ Upload successful");
      } else {
        Get.snackbar("Failed", "Upload failed: ${response.statusCode}");
        print("❌ Failed: Status Code = ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred during upload: $e");
      print("❌ Exception: $e");
    } finally {
      isUploading.value = false;
    }
  }
}
