import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project2teacher/widght/lesson_page/pdf_viewer_page.dart';
import 'package:project2teacher/widght/lesson_page/video_player_page.dart';
import '../../contoller/lesson_controller/add_lesson_controller.dart';
import '../../contoller/lesson_controller/delete_lesson_controller.dart';
import '../../contoller/lesson_controller/lesson_controller.dart';
import '../../data/constant/app_constant.dart';
import '../quation_page/quation_page.dart';

class LessonPage extends StatefulWidget {
  final int subjectId;

  LessonPage({super.key, required this.subjectId});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final LessonController lessonController = Get.put(LessonController());
  final DeleteLessonController deletelessonController = Get.put(DeleteLessonController());
  final AddLessonController addLessonController = Get.put(AddLessonController());

  final TextEditingController videoPathController = TextEditingController();
  final TextEditingController summaryPathController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      lessonController.fetchLessons(widget.subjectId);
    });
  }

  String convertLocalhostToEmulatorIp(String url) {
    String baseUrl = AppConstant.baseUrl;

    // لو التطبيق شغال على المحاكي أندرويد
    if (defaultTargetPlatform == TargetPlatform.android) {
      baseUrl = baseUrl.replaceFirst("127.0.0.1", "10.0.2.2");
    }
    // لو شغال على iOS Simulator
    else if (defaultTargetPlatform == TargetPlatform.iOS) {
      baseUrl = baseUrl.replaceFirst("127.0.0.1", "localhost");
    }

    // نستبدل الـ IP أو الدومين الموجود بالرابط الحالي بالـ baseUrl من AppConstant
    Uri oldUri = Uri.parse(url);
    Uri newUri = oldUri.replace(
      host: Uri.parse(baseUrl).host,
      port: Uri.parse(baseUrl).port,
      scheme: Uri.parse(baseUrl).scheme,
    );

    return newUri.toString();
  }

  void _showAddLessonBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  'Add New Lesson',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.teal,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: addLessonController.titleController,
                decoration: const InputDecoration(
                  labelText: 'Lesson Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  onPressed: () async {
                    final title = addLessonController.titleController.text.trim();

                    if (title.isEmpty) {
                      Get.snackbar('Error', 'Please fill all fields');
                      return;
                    }

                    bool success = await addLessonController.addLesson(
                      widget.subjectId,
                      title,
                    );

                    if (success) {
                      addLessonController.titleController.clear();
                      videoPathController.clear();
                      summaryPathController.clear();
                      Get.back(); // Close bottom sheet

                      // Reload lessons
                      await lessonController.fetchLessons(widget.subjectId);
                    }
                  },
                  child: const Text('Add Lesson', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lessons',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (lessonController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (lessonController.lessonList.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => lessonController.fetchLessons(widget.subjectId),
            child: ListView(
              children: const [
                SizedBox(height: 200),
                Center(child: Text('No lessons found.')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => lessonController.fetchLessons(widget.subjectId),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lessonController.lessonList.length,
            itemBuilder: (context, index) {
              final lesson = lessonController.lessonList[index];

              // تعديل روابط الفيديو وملف الـ PDF
              final videoUrl = lesson.videoPath != null
                  ? convertLocalhostToEmulatorIp(lesson.videoPath!)
                  : null;
              final pdfUrl = lesson.summaryPath != null
                  ? convertLocalhostToEmulatorIp(lesson.summaryPath!)
                  : null;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade100,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.teal),
                    ),
                  ),
                  title: Text(
                    lesson.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // زر عرض الفيديو
                      IconButton(
                        icon: const Icon(Icons.play_circle_fill, color: Colors.blueAccent),
                        tooltip: 'Watch Video',
                        onPressed: () {
                          if (videoUrl != null && videoUrl.isNotEmpty) {
                            print('videoPath: $videoUrl');
                            Get.to(() => VideoPlayerPage(videoUrl: videoUrl, lessonId: lesson.id));
                          } else {
                            Get.snackbar('No Video', 'This lesson has no video available.');
                          }
                        },
                      ),

                      // زر عرض ملف PDF
                      IconButton(
                        icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                        tooltip: 'View Summary PDF',
                        onPressed: () {
                          if (pdfUrl != null && pdfUrl.isNotEmpty) {
                            print('pdfUrl: $pdfUrl');
                            Get.to(() => PdfViewerPage(pdfUrl: pdfUrl));
                          } else {
                            Get.snackbar('No PDF', 'This lesson has no PDF summary.');
                          }
                        },
                      ),

                      // زر الحذف
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'Confirm Delete',
                            titleStyle: const TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            middleText: 'Are you sure you want to delete this lesson?',
                            middleTextStyle: const TextStyle(fontSize: 16),
                            textCancel: 'Cancel',
                            textConfirm: 'Delete',
                            confirmTextColor: Colors.white,
                            cancelTextColor: Colors.teal,
                            buttonColor: Colors.teal,
                            radius: 10,
                            onConfirm: () async {
                              Get.back();
                              await deletelessonController.deleteLesson(lesson.id);
                              await lessonController.fetchLessons(widget.subjectId);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.to(() => QuestionPage(lessonId: lesson.id));
                  },
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddLessonBottomSheet(context),
      ),
    );
  }
}
