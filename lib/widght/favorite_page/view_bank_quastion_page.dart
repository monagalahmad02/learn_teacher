import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contoller/quation_controller/view_bank_quastion_controller.dart';
import '../../contoller/favorite_controller/add_test_fav_controller.dart';

class ViewBankQuastionPage extends StatefulWidget {
  const ViewBankQuastionPage({super.key});

  @override
  State<ViewBankQuastionPage> createState() => _ViewBankQuastionPageState();
}

class _ViewBankQuastionPageState extends State<ViewBankQuastionPage> {
  final QuestionController controller = Get.put(QuestionController());
  final AddTestToFavoriteController addTestController = Get.put(AddTestToFavoriteController());

  final RxList<int> selectedQuestionIds = <int>[].obs;

  @override
  void initState() {
    super.initState();
    controller.fetchQuestionsByTeacher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Question Bank',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.questions.isEmpty) {
          return RefreshIndicator(
            onRefresh: ()async{
              controller.fetchQuestionsByTeacher();
            },
            child: const Center(
              child: Text("No questions available", style: TextStyle(fontSize: 18)),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: ()async{
            controller.fetchQuestionsByTeacher();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.questions.length,
            itemBuilder: (context, index) {
              final question = controller.questions[index];
              final isSelected = selectedQuestionIds.contains(question.id);

              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    selectedQuestionIds.remove(question.id);
                  } else {
                    selectedQuestionIds.add(question.id!);
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.white, // الكرت يبقى أبيض دائمًا
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Checkbox(
                          activeColor: Colors.teal,
                          value: selectedQuestionIds.contains(question.id),
                          onChanged: (val) {
                            if (val == true) {
                              selectedQuestionIds.add(question.id!);
                            } else {
                              selectedQuestionIds.remove(question.id);
                            }
                          },
                        )),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Question ${index + 1}: ${question.questionText}",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Page number: ${question.pageNumber}",
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(height: 12),
                              ...question.options.map((option) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                    color: option.isCorrect
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text(option.optionText),
                                    trailing: option.isCorrect
                                        ? const Icon(Icons.check_circle, color: Colors.green)
                                        : const Icon(Icons.circle_outlined),
                                  ),
                                );
                              }).toList(),
                              const Divider(height: 20, thickness: 1),
                              const Text(
                                "Explanation:",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(question.explanation, style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              );
            },
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () {
            if (selectedQuestionIds.isEmpty) {
              Get.snackbar("Alter", "Please choose at least one question");
              return;
            }
            addTestController.createTest(
              lessonIds: [],
              questionIds: selectedQuestionIds.toList(),
            );
          },
          child: const Text("SEND", style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}
