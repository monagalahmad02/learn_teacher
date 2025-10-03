import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contoller/favorite_controller/add_student_to_favorite_controller.dart';
import '../../contoller/user_controller/student_point_controller.dart';

class StudentPointsPage extends StatelessWidget {
  StudentPointsPage({super.key});

  // إنشاء Controllers
  final StudentPointsController controller = Get.put(StudentPointsController());
  final AddMultipleFavoriteStudentsController favoriteController =
  Get.put(AddMultipleFavoriteStudentsController());

  // قائمة لتخزين الطلاب المحددين
  final RxList<int> selectedStudentIds = <int>[].obs;

  @override
  Widget build(BuildContext context) {
    // جلب البيانات عند فتح الصفحة
    controller.fetchStudentPoints();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Points student",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.studentPoints.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchStudentPoints();
            },
            child: const Center(
              child: Text(
                "لا توجد نقاط مسجلة للطلاب",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          );
        }

        // ترتيب الطلاب حسب النقاط (الأكثر أولًا)
        final sortedStudents = [...controller.studentPoints];
        sortedStudents.sort((a, b) => b.points.compareTo(a.points));

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchStudentPoints();
          },
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: sortedStudents.length,
                  itemBuilder: (context, index) {
                    final sp = sortedStudents[index];

                    return Obx(() {
                      final isSelected = selectedStudentIds.contains(sp.student.id);
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (isSelected) {
                              selectedStudentIds.remove(sp.student.id);
                            } else {
                              selectedStudentIds.add(sp.student.id);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.teal.shade200,
                                  backgroundImage: (sp.student.userImage != null &&
                                      sp.student.userImage!.isNotEmpty)
                                      ? NetworkImage(sp.student.userImage!)
                                      : null,
                                  child: (sp.student.userImage == null ||
                                      sp.student.userImage!.isEmpty)
                                      ? Text(
                                    sp.student.name[0].toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 24, color: Colors.white),
                                  )
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sp.student.name,
                                        style: const TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        sp.student.email,
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "${sp.points} points",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  child: Checkbox(
                                    value: isSelected,
                                    onChanged: (val) {
                                      if (val == true) {
                                        selectedStudentIds.add(sp.student.id);
                                      } else {
                                        selectedStudentIds.remove(sp.student.id);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Obx(() => ElevatedButton(
                  onPressed: selectedStudentIds.isEmpty
                      ? null
                      : () async {
                    // استدعاء إضافة الطلاب
                    await favoriteController
                        .addStudentsToFavorites(selectedStudentIds);

                    // بعد نجاح العملية: تفريغ الاختيارات + تحديث البيانات
                    selectedStudentIds.clear();
                    controller.fetchStudentPoints();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    "Add students to favorite",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                )),
              ),
            ],
          ),
        );
      }),
    );
  }
}
