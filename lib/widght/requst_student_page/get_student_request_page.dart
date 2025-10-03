import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../contoller/student_controller/accpte_student_controller.dart';
import '../../contoller/student_controller/get_student_requst_controller.dart';
import '../../data/model/requst_student_model.dart';

class RequestsPage extends StatelessWidget {
  final RequestsStudentController controller = Get.put(RequestsStudentController());
  final AcceptStudentController requestsStudentController = Get.put(AcceptStudentController());
  RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchRequests();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Requests', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.requestsList.isEmpty) {
          return const Center(child: Text("No requests found."));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchRequests(),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.requestsList.length,
            itemBuilder: (context, index) {
              final request = controller.requestsList[index];
              final user = request.user;
              final subject = request.subject;

              final price = double.tryParse(subject.price) ?? 0;
              final formattedPrice = NumberFormat('#,##0', 'en_US').format(price).replaceAll(',', '.');
              String formattedDate;
              try {
                formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(request.createdAt);
              } catch (e) {
                print('Date formatting error: $e');
                formattedDate = request.createdAt.toString().split('.')[0];
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم الطالب
                      Text(
                        user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),

                      const SizedBox(height: 8),
                      // الهاتف
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(user.phone.isNotEmpty ? user.phone : 'No phone'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // البريد الإلكتروني
                      Row(
                        children: [
                          const Icon(Icons.email, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(user.email.isNotEmpty ? user.email : 'No email'),
                        ],
                      ),

                      const Divider(height: 20, thickness: 1),
                      // المادة والسعر
                      Text(
                        'Subject: ${subject.title}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),

                      Text('Price: $formattedPrice'),

                      const Divider(height: 20, thickness: 1),
                      // الحالة
                      Row(
                        children: [
                          const Text(
                            'Status: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            request.status,
                            style: TextStyle(
                              color: request.status == 'pending' ? Colors.orange : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // التاريخ
                      Text(
                        'Requested at: $formattedDate',
                        style: const TextStyle(color: Colors.grey),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Status: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                request.status,
                                style: TextStyle(
                                  color: request.status == 'pending' ? Colors.orange : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (request.status == 'pending') // تعرض الزر فقط إذا الطلب معلق
                            ElevatedButton(
                              onPressed: () async{
                                await requestsStudentController.acceptRequest(request.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Accept', style: TextStyle(color: Colors.white),),
                            ),
                        ],
                      ),

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
