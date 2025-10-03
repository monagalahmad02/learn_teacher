import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contoller/favorite_controller/favorite_delete_controller.dart';
import '../../contoller/favorite_controller/view_students_favorite_controller.dart';
import '../../data/model/student_model.dart';

class FavoriteStudentsPage extends StatelessWidget {
  final FavoriteStudentsController controller =
  Get.put(FavoriteStudentsController());
  final FavoriteDeleteController deleteController =
  Get.put(FavoriteDeleteController());

  FavoriteStudentsPage({super.key}) {
    controller.fetchFavoriteStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Students',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.studentsList.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchFavoriteStudents();
            },
            child: ListView(
              children: const [
                SizedBox(height: 200),
                Center(child: Text('No favorite students found.')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchFavoriteStudents();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.studentsList.length,
            itemBuilder: (context, index) {
              final StudentModel student = controller.studentsList[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.teal.shade100,
                    backgroundImage: student.userImage != null
                        ? NetworkImage(student.userImage!)
                        : null,
                    child: student.userImage == null
                        ? const Icon(Icons.person, color: Colors.teal, size: 28)
                        : null,
                  ),
                  title: Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("Phone: ${student.phone}"),
                      Text("Email: ${student.email}"),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: "Confirm Delete",
                        titleStyle: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        middleText:
                        "Are you sure you want to remove ${student.name}?",
                        middleTextStyle: const TextStyle(fontSize: 16),
                        radius: 10,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        confirm: TextButton(
                          onPressed: () async {
                            Get.back();
                            final result = await deleteController
                                .deleteFavoriteStudent(student.id);

                            Get.snackbar(
                              "Delete",
                              result,
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.white,
                              colorText: Colors.black,
                            );

                            if (result.contains("removed") ||
                                result.contains("تم")) {
                              controller.fetchFavoriteStudents();
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Yes",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        cancel: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.teal,
                          ),
                          child: const Text("Cancel"),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red.shade500,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
