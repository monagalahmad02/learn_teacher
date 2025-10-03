import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project2teacher/widght/challenge_wedght/create_challenge_page.dart';
import 'package:project2teacher/widght/challenge_wedght/quastion_challenge_page.dart';
import 'package:project2teacher/widght/challenge_wedght/student_point_page.dart';
import '../../contoller/challange_controller/view_challenge_controller.dart';
import '../../data/model/challenge_model.dart';
import 'package:intl/intl.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

  /// تحويل التاريخ ليشمل الوقت بالساعة والدقيقة
  String formatDateTime(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('yyyy-MM-dd – HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final TeacherChallengesController controller =
    Get.put(TeacherChallengesController());
    controller.fetchTeacherChallenges();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Challenges",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () {
              Get.to(() => StudentPointsPage());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return RefreshIndicator(
              onRefresh: () async {
                await controller.fetchTeacherChallenges();
              },
              child: const Center(child: CircularProgressIndicator()));
        } else if (controller.challenges.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchTeacherChallenges();
            },
            child: const Center(
                child: Text('No challenges found',
                    style: TextStyle(fontSize: 18))),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchTeacherChallenges();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.challenges.length,
              itemBuilder: (context, index) {
                final ChallengeModel challenge =
                controller.challenges[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    // الانتقال لواجهة الأسئلة مع تمرير id
                    Get.to(() => ChallengeQuestionsPage(
                      challengeId: challenge.id,
                      challengeTitle: challenge.title,
                    ));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.teal.shade300),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge.title,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  color: Colors.white70, size: 18),
                              const SizedBox(width: 5),
                              Text(
                                "${challenge.durationMinutes} min",
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 16),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.white70, size: 18),
                              const SizedBox(width: 5),
                              Text(
                                formatDateTime(challenge.startTime),
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.yellowAccent, size: 18),
                              const SizedBox(width: 5),
                              Text(
                                "Points: ${challenge.pointsTransferred}",
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Get.to(() => const CreateChallengePage());
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
