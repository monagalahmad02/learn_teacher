import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contoller/notification_controller/get_notification_controller.dart';
import '../../contoller/notification_controller/mark_notification_controller.dart';
import '../../contoller/notification_controller/notification_unread_count_controller.dart';
import '../../contoller/notification_controller/read_all_notification.dart';
import '../../contoller/notification_controller/delete_notification_controller.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationsController controller = Get.put(NotificationsController());
    final ReadAllNotificationsController readAllController =
    Get.put(ReadAllNotificationsController());
    final NotificationUnreadCountController unreadController =
    Get.find<NotificationUnreadCountController>();
    final DeleteNotificationController deleteController =
    Get.put(DeleteNotificationController());
    final MarkNotificationReadController markReadController =
    Get.put(MarkNotificationReadController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Obx(() => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "Unread: ${controller.unreadCount}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          )),
        ],
      ),
      body: Column(
        children: [
          // زر Mark All as Read
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              return ElevatedButton.icon(
                onPressed: readAllController.isLoading.value
                    ? null
                    : () async {
                  bool success =
                  await readAllController.readAllNotifications();
                  if (success) {
                    unreadController.fetchUnreadCount();
                    controller.fetchNotifications();
                    Get.snackbar(
                        "Success", "All notifications marked as read");
                  } else {
                    Get.snackbar(
                        "Error", "Failed to mark notifications as read");
                  }
                },
                icon: const Icon(Icons.done_all, color: Colors.white),
                label: readAllController.isLoading.value
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  "Mark all as read",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade300,
                  minimumSize: const Size(double.infinity, 40),
                ),
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.notifications.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    controller.fetchNotifications();
                  },
                  child: const Center(
                    child: Text(
                      'No notifications available',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  controller.fetchNotifications();
                },
                child: ListView.builder(
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final item = controller.notifications[index];

                    return Dismissible(
                      key: Key(item.id ?? index.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await Get.defaultDialog<bool>(
                          title: "Delete Notification",
                          titleStyle: const TextStyle(color: Colors.black),
                          middleText: "Are you sure you want to delete this notification?",
                          middleTextStyle: const TextStyle(color: Colors.black),
                          backgroundColor: Colors.white,
                          barrierDismissible: false,
                          confirm: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                            ),
                            onPressed: () {
                              Get.back(result: true);
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          cancel: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              Get.back(result: false);
                            },
                            child: const Text(
                              "No",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                      onDismissed: (direction) async {
                        bool success =
                        await deleteController.deleteNotification(item.id!);
                        if (success) {
                          controller.fetchNotifications();
                          unreadController.fetchUnreadCount();
                          Get.snackbar("Success", "Notification deleted");
                        } else {
                          Get.snackbar("Error", "Failed to delete notification");
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.notifications,
                              color: Colors.teal, size: 30),
                          title: Text(
                            item.data?.message ?? "No message",
                            style: TextStyle(
                              color: item.readAt == null
                                  ? Colors.black87
                                  : Colors.grey.shade800,
                              fontWeight: item.readAt == null
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${item.data?.studentName ?? ''} - ${item.data?.subjectName ?? ''}",
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                item.createdAt != null
                                    ? item.createdAt!.split("T").first
                                    : "",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade800),
                              ),
                            ],
                          ),
                          onTap: () async {
                            // عند الضغط على الإشعار، يصبح مقروء
                            if (item.readAt == null) {
                              bool success =
                              await markReadController.markAsRead(item.id!);
                              if (success) {
                                unreadController.fetchUnreadCount();
                                controller.fetchNotifications();
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
