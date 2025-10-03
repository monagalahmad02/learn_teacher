import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../contoller/favorite_controller/add_test_fav_controller.dart';
import '../../contoller/quation_controller/delete_quation_controller.dart';
import '../../contoller/test_controller/view_test_controller.dart';
import '../../data/model/test_model.dart';

class TestScreen extends StatefulWidget {
  final int testId;

  const TestScreen({super.key, required this.testId});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late Future<TestModel> _testFuture;

  final RxList<int> selectedQuestionIds = <int>[].obs;
  // final AddTestToFavoriteController addTestController = Get.put(AddTestToFavoriteController());
  final DeleteQuestionController deleteQuestionController = Get.put(DeleteQuestionController());

  @override
  void initState() {
    super.initState();
    _testFuture = TestController.fetchTestById(widget.testId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details test ${widget.testId}', style:const TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<TestModel>(
        future: _testFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.questions.isEmpty) {
            return const Center(child: Text('لا توجد أسئلة في هذا الاختبار'));
          }

          final test = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: test.questions.length,
            itemBuilder: (context, index) {
              final question = test.questions[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
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
                              "Q${index + 1}: ${question.questionText}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Delete Question"),
                                  content: const Text("Are you sure you want to delete this question?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(true),
                                      child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await deleteQuestionController.deleteQuestion(question.id);
                                setState(() {
                                  _testFuture = TestController.fetchTestById(widget.testId);
                                });
                              }
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...question.options.map((option) {
                        return ListTile(
                          title: Text(option.optionText),
                          leading: const Icon(Icons.circle_outlined),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(12),
      //   child: ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Colors.teal,
      //       padding: const EdgeInsets.symmetric(vertical: 14),
      //     ),
      //     onPressed: () {
      //       if (selectedQuestionIds.isEmpty) {
      //         Get.snackbar("تنبيه", "الرجاء اختيار سؤال واحد على الأقل");
      //         return;
      //       }
      //
      //       addTestController.createTest(
      //         lessonIds: [],
      //         questionIds: selectedQuestionIds.toList(),
      //       );
      //     },
      //     child: const Text("SEND", style: TextStyle(fontSize: 18, color: Colors.white)),
      //   ),
      // ),

    );
  }
}
