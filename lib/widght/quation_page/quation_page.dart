import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import '../../contoller/quation_controller/delete_quation_controller.dart';
import '../../contoller/quation_controller/view_quation_controller.dart';
import '../../contoller/upload_video_pdf_controller/upload_pdf_controller.dart';
import '../../contoller/upload_video_pdf_controller/upload_video_controller.dart';
import '../../contoller/lesson_controller/lesson_controller.dart';
import 'add_question_page.dart';

class QuestionPage extends StatelessWidget {
  final int lessonId;

  final QuestionController controller = Get.put(QuestionController());
  final DeleteQuestionController deleteController = Get.put(DeleteQuestionController());
  final AddVideoController addVideoController = Get.put(AddVideoController());
  final AddPdfController addPdfController = Get.put(AddPdfController());
  final LessonController lessonController = Get.find<LessonController>();

  QuestionPage({super.key, required this.lessonId}) {
    controller.fetchQuestionsByLesson(lessonId);
  }

  @override
  Widget build(BuildContext context) {
    // العثور على الدرس الحالي لنعرف إذا عنده فيديو أو PDF
    final currentLesson = lessonController.lessonList.firstWhereOrNull(
          (lesson) => lesson.id == lessonId,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final questions = controller.questionList;

        return RefreshIndicator(
          onRefresh: () async => await controller.fetchQuestionsByLesson(lessonId),
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.video,
                      );

                      if (result != null && result.files.single.path != null) {
                        File videoFile = File(result.files.single.path!);

                        await addVideoController.uploadVideo(
                          lessonId: lessonId,
                          videoFile: videoFile,
                        );

                        // إعادة تحميل الدروس لتحديث حالة الزر
                        await lessonController.fetchLessons(currentLesson?.subjectId ?? 0);
                      } else {
                        Get.snackbar("إلغاء", "لم يتم اختيار أي ملف فيديو");
                      }
                    },
                    icon: const Icon(Icons.video_call),
                    label: Text(
                      (currentLesson?.videoPath != null && currentLesson!.videoPath!.isNotEmpty)
                          ? "Update Video"
                          : "Add Video",
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );

                      if (result != null && result.files.single.path != null) {
                        File pdfFile = File(result.files.single.path!);

                        await addPdfController.uploadPdf(
                          lessonId: lessonId,
                          pdfFile: pdfFile,
                        );

                        // إعادة تحميل الدروس لتحديث حالة الزر
                        await lessonController.fetchLessons(currentLesson?.subjectId ?? 0);
                      } else {
                        Get.snackbar("Cancelled", "No PDF file selected.");
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: Text(
                      (currentLesson?.summaryPath != null && currentLesson!.summaryPath!.isNotEmpty)
                          ? "Update PDF"
                          : "Add PDF",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (questions.isEmpty)
                const Center(child: Text("No questions found."))
              else
                ...questions.map((question) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  question.questionText,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await deleteController.deleteQuestion(question.id);
                                  await controller.fetchQuestionsByLesson(lessonId);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("Page: ${question.pageNumber}"),
                          if ((question.explanation ?? '').isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text("Explanation: ${question.explanation}"),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Get.to(() => AddQuestionPage(lessonId: lessonId));
        },
      ),
    );
  }
}
