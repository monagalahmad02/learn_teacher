import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project2teacher/widght/challenge_wedght/view_question_bank_chall_page.dart';
import '../../contoller/challange_controller/get_question_challenge_controller.dart';
import '../../data/model/question_challenge_model.dart';

class ChallengeQuestionsPage extends StatelessWidget {
  final int challengeId;
  final String challengeTitle;

  ChallengeQuestionsPage({
    super.key,
    required this.challengeId,
    required this.challengeTitle,
  });

  // إنشاء Controller
  final QuestionChallengeController controller = Get.put(QuestionChallengeController());

  @override
  Widget build(BuildContext context) {
    // جلب الأسئلة عند فتح الصفحة
    controller.fetchChallengeQuestions(challengeId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Questions $challengeTitle', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.questions.isEmpty) {
          return RefreshIndicator(
            onRefresh: ()async{
              await controller.fetchChallengeQuestions(challengeId);
            },
              child: const Center(child: Text("لا توجد أسئلة لهذا التحدي")));
        }

        return RefreshIndicator(
          onRefresh: ()async{
            await controller.fetchChallengeQuestions(challengeId);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.questions.length,
            itemBuilder: (context, index) {
              final QuestionChallengeModel question = controller.questions[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question: ${question.questionText}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...question.options.map(
                            (opt) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '• ${opt.optionText}',
                            style: TextStyle(
                              color: opt.isCorrect ? Colors.green : Colors.black,
                              fontWeight: opt.isCorrect ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ).toList(),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Get.to(() => ViewQuestionBankChallPage(challengeId: challengeId));
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
