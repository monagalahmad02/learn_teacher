import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../contoller/student_controller/get_student_in_subject_controller.dart';

class StudentInSubjectPage extends StatelessWidget {
  const StudentInSubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentInSubjectController controller =
    Get.put(StudentInSubjectController());

    // تحميل البيانات أول مرة
    controller.fetchStudentsForTeacher();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Student in subject',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final students = controller.studentModel;

        if (students.isEmpty) {
          return const Center(child: Text('لا يوجد طلاب حالياً.'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchStudentsForTeacher(); // إعادة تحميل البيانات
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: student.userImage != null
                        ? NetworkImage(student.userImage!)
                        : null,
                    child: student.userImage == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(student.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.email , style:const TextStyle(color: Colors.grey),),
                      Text(student.phone , style:const TextStyle(color: Colors.grey),),
                    ],
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
