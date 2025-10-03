import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../contoller/notification_controller/notification_unread_count_controller.dart';
import '../../contoller/request_controller/request_controller.dart';
import '../../contoller/subject_controller/order_subscribe_to_subject_controller.dart';
import '../../contoller/subject_controller/subject_controller.dart';
import '../lesson_page/lesson_page.dart';

class HomeContent extends StatelessWidget {
  final SubjectController subjectController = Get.find();
  final OrderSubscribeToSubjectController orderSubscribeToSubjectController =
  Get.put(OrderSubscribeToSubjectController());

  final RequestController requestController = Get.put(RequestController());

  final NotificationUnreadCountController notificationController =
  Get.put(NotificationUnreadCountController());

  HomeContent({super.key}) {
    requestController.fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (subjectController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (subjectController.subjectList.isEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            await subjectController.fetchSubjects();
            await requestController.fetchRequests();
          },
          child: ListView(
            children: const [
              SizedBox(height: 200),
              Center(child: Text('No subjects found.')),
            ],
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: () async {
            await subjectController.fetchSubjects();
            await requestController.fetchRequests();
            await notificationController.fetchUnreadCount();
          },
          child: GridView.builder(
            itemCount: subjectController.subjectList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2 / 2.3,
            ),
              itemBuilder: (context, index) {
                final subject = subjectController.subjectList[index];

                return Obx(() {
                  final status = requestController.getStatusForSubject(subject.id);
                  String buttonText;
                  Color buttonColor;
                  bool isClickable = false;

                  if (status == 'accepted') {
                    buttonText = 'Approved';
                    buttonColor = Colors.green;
                  } else if (status == 'pending') {
                    buttonText = 'Pending';
                    buttonColor = Colors.orange;
                  } else {
                    buttonText = 'Subscribe';
                    buttonColor = Colors.teal;
                    isClickable = true;
                  }

                  return SizedBox(
                    height: 150,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                subject.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.price_change,
                                      size: 16, color: Colors.teal),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      "${NumberFormat('#,###', 'en').format(double.parse(subject.price))} SP",
                                      style: const TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                  onPressed: () async {
                                    if (status == 'accepted') {
                                      // انتقال إلى الدروس
                                      Get.to(() => LessonPage(subjectId: subject.id));
                                    } else if (status == 'pending') {
                                      // إظهار رسالة الانتظار
                                      Get.snackbar(
                                        'Notice',
                                        'Please wait for admin approval.',
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: Colors.white,
                                        colorText: Colors.black,
                                        duration: const Duration(milliseconds: 2500),
                                      );
                                    } else {
                                      // إرسال طلب اشتراك جديد
                                      final result = await orderSubscribeToSubjectController.joinSubject(
                                        subjectId: subject.id,
                                      );
                                      await requestController.fetchRequests();

                                    }
                                  },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  minimumSize: const Size(100, 36),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                ),
                                child: Text(
                                  buttonText,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
              }
          ),
        ),

      );

    });
  }

}
