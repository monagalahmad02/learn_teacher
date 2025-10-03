import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:project2teacher/data/constant/app_constant.dart';

class AddPdfController extends GetxController {
  final storage = GetStorage();
  var isUploading = false.obs;

  Future<void> uploadPdf({required int lessonId, required File pdfFile}) async {
    final token = storage.read('token');

    if (token == null) {
      Get.snackbar("Error", "Token not found");
      print("❌ No token found in GetStorage");
      return;
    }

    final url = Uri.parse("${AppConstant.baseUrl}/add/summary/lesson/$lessonId");

    try {
      isUploading.value = true;

      print("📤 Starting PDF upload...");
      print("🎯 Endpoint: $url");
      print("📄 File name: ${basename(pdfFile.path)}");
      print("📦 File size: ${pdfFile.lengthSync() / (1024 * 1024)} MB");

      final request = http.MultipartRequest("POST", url);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // 'summary' is the key in the backend for the PDF file
      request.files.add(await http.MultipartFile.fromPath(
        'summary',
        pdfFile.path,
        filename: basename(pdfFile.path),
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        print("✅ PDF upload successful");
        Get.snackbar("Success", "PDF uploaded successfully");
      } else {
        Get.snackbar("Failed", "Upload failed: ${response.statusCode}");
        print("❌ Failed: Status Code = ${response.statusCode}");
        print("🧾 Response Body: ");
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
