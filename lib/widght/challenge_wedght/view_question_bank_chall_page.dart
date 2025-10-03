import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contoller/challange_controller/add_question_challenge_controller.dart';
import '../../contoller/quation_controller/view_bank_quastion_controller.dart';

class ViewQuestionBankChallPage extends StatefulWidget {
  final int challengeId;

  const ViewQuestionBankChallPage({super.key, required this.challengeId});

  @override
  State<ViewQuestionBankChallPage> createState() => _ViewBankQuastionPageState();
}

class _ViewBankQuastionPageState extends State<ViewQuestionBankChallPage> {
  final QuestionController controller = Get.put(QuestionController());
  final Challenge1Controller challengeController = Challenge1Controller();

  final RxnInt selectedQuestionId = RxnInt();
  final RxBool isSending = false.obs;

  @override
  void initState() {
    super.initState();
    controller.fetchQuestionsByTeacher();
  }

  Future<void> _sendSelectedQuestion() async {
    if (selectedQuestionId.value == null) {
      Get.snackbar("Warning", "Please select one question",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isSending.value = true;
    try {
      final response = await challengeController.addQuestionToChallenge(
        challengeId: widget.challengeId,
        questionId: selectedQuestionId.value!,
      );

      Get.snackbar("Success", "Question added successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);

      print(response);
      selectedQuestionId.value = null;
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSending.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Question Bank", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return RefreshIndicator(
              onRefresh: () async {
                controller.fetchQuestionsByTeacher();
              },
              child: const Center(child: CircularProgressIndicator()));
        }

        if (controller.questions.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              controller.fetchQuestionsByTeacher();
            },
            child: const Center(
              child: Text("No questions available", style: TextStyle(fontSize: 18)),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.fetchQuestionsByTeacher();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.questions.length,
            itemBuilder: (context, index) {
              final question = controller.questions[index];
              final isSelected = selectedQuestionId.value == question.id;

              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    selectedQuestionId.value = null;
                  } else {
                    selectedQuestionId.value = question.id;
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Checkbox(
                          activeColor: Colors.teal,
                          value: selectedQuestionId.value == question.id,
                          onChanged: (val) {
                            if (val == true) {
                              selectedQuestionId.value = question.id;
                            } else {
                              selectedQuestionId.value = null;
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
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text("Page number: ${question.pageNumber}",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey)),
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
                                        ? const Icon(Icons.check_circle,
                                        color: Colors.green)
                                        : const Icon(Icons.circle_outlined),
                                  ),
                                );
                              }).toList(),
                              const Divider(height: 20, thickness: 1),
                              const Text("Explanation:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(question.explanation,
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: isSending.value ? null : _sendSelectedQuestion,
          child: isSending.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("SEND",
              style: TextStyle(fontSize: 18, color: Colors.white)),
        )),
      ),
    );
  }
}
