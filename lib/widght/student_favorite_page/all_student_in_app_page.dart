import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contoller/favorite_controller/add_student_to_favorite_controller.dart';
import '../../contoller/student_controller/get_student_in_subject_controller.dart';
import '../../data/model/student_model.dart';

class AllStudentPage extends StatelessWidget {
  AllStudentPage({super.key});

  final StudentInSubjectController controller = Get.put(StudentInSubjectController());
  final AddMultipleFavoriteStudentsController favoriteController =
  Get.put(AddMultipleFavoriteStudentsController());

  // قائمة الطلاب المحددين
  final RxSet<int> selectedStudentIds = <int>{}.obs;

  @override
  Widget build(BuildContext context) {
    controller.fetchStudentsForTeacher();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Students",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.studentModel.isEmpty) {
          return const Center(child: Text("No students found."));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchStudentsForTeacher(); // ⬅️ تحديث البيانات
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.studentModel.length,
            itemBuilder: (context, index) {
              final StudentModel student = controller.studentModel[index];

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Obx(
                      () => ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const Icon(Icons.person, color: Colors.teal),
                    title: Text(
                      student.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Phone: ${student.phone}"),
                        Text("Email: ${student.email}"),
                      ],
                    ),
                    trailing: Checkbox(
                      value: selectedStudentIds.contains(student.id),
                      onChanged: (bool? value) {
                        if (value == true) {
                          selectedStudentIds.add(student.id);
                        } else {
                          selectedStudentIds.remove(student.id);
                        }
                      },
                      activeColor: Colors.teal,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),

      // زر أسفل الشاشة لإرسال المحددين إلى المفضلة
      bottomNavigationBar: Obx(
            () => Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton.icon(
            onPressed: selectedStudentIds.isEmpty
                ? null
                : () async {
              await favoriteController.addStudentsToFavorites(selectedStudentIds.toList());
              selectedStudentIds.clear(); // إعادة التحديد
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.check, color: Colors.white),
            label: Text(
              "Select (${selectedStudentIds.length})",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
