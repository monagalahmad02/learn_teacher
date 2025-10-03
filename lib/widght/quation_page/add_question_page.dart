import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contoller/quation_controller/add_quation_controller.dart';

class AddQuestionPage extends StatelessWidget {
  final int lessonId;
  final AddQuestionController controller = Get.put(AddQuestionController());

  AddQuestionPage({super.key, required this.lessonId});

  final List<TextEditingController> optionControllers =
      List.generate(4, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title:
            const Text('Add Question', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    Card(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: controller.questionTextController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter question text',
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: controller.explanationController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter explanation',
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: controller.pageNumberController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter page number',
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...List.generate(4, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: TextField(
                                  controller: optionControllers[index],
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: 'Option ${index + 1}',
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 12),
                            TextField(
                              controller: controller.correctOptionController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter correct option number (1-4)',
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  // جمع الخيارات
                                  final options = List.generate(4, (index) {
                                    return {
                                      "option_text":
                                      optionControllers[index].text.trim(),
                                    };
                                  });

                                  // التحقق أن الحقول ليست فارغة
                                  if (controller.questionTextController.text
                                      .trim()
                                      .isEmpty ||
                                      controller.correctOptionController.text
                                          .trim()
                                          .isEmpty) {
                                    Get.snackbar(
                                        'Validation', 'Please fill in required fields');
                                    return;
                                  }

                                  final success = await controller.addQuestion(
                                    lessonId: lessonId,
                                    options: options,
                                  );

                                  if (success) {
                                    Get.back(); // الرجوع بعد النجاح
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal),
                                child: const Text("Submit",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
