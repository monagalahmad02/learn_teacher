import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:project2teacher/data/constant/app_constant.dart';

class UploadProfileImageController extends GetxController {
  final storage = GetStorage();
  var isUploading = false.obs;

  Future<void> uploadProfileImage(File imageFile) async {
    final token = storage.read('token');

    if (token == null) {
      Get.snackbar("Error", "Token not found");
      print("❌ No token found in GetStorage");
      return;
    }

    final url = Uri.parse("${AppConstant.baseUrl}/add/image/profile");

    try {
      isUploading.value = true;

      print("📤 Uploading profile image...");
      print("📄 File name: ${basename(imageFile.path)}");
      print("📦 File size: ${imageFile.lengthSync() / (1024 * 1024)} MB");

      final request = http.MultipartRequest("POST", url);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.files.add(await http.MultipartFile.fromPath(
        'user_image',
        imageFile.path,
        filename: basename(imageFile.path),
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Profile image uploaded successfully");
        print("✅ Upload successful");
      } else {
        Get.snackbar("Failed", "Upload failed: ${response.statusCode}");
        print("❌ Upload failed: Status Code = ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Error during upload: $e");
      print("❌ Exception: $e");
    } finally {
      isUploading.value = false;
    }
  }
}
