import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contoller/chat/get_chat_details_controller.dart';
import '../../contoller/chat/send_message_controller.dart';
import '../../data/model/get_details_chat_model.dart';

class DetailsChatPage extends StatelessWidget {
  final int conversationId;
  final String userName;
  final String? userImage;

  DetailsChatPage({
    super.key,
    required this.conversationId,
    required this.userName,
    this.userImage,
  });

  final TextEditingController messageController = TextEditingController();
  final ChatSendMessageController sendController =
  Get.put(ChatSendMessageController());

  @override
  Widget build(BuildContext context) {
    final ChatDetailsController controller = Get.put(ChatDetailsController());

    // تحميل البيانات أول مرة
    controller.fetchChatDetails(conversationId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: userImage != null ? NetworkImage(userImage!) : null,
              child: userImage == null ? Text(userName[0]) : null,
            ),
            const SizedBox(width: 10),
            Text(userName, style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              controller.fetchChatDetails(conversationId);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.chatDetails.value == null ||
                  controller.chatDetails.value!.messages.isEmpty) {
                return const Center(child: Text("لا يوجد رسائل"));
              }

              final chat = controller.chatDetails.value!;
              // استخدم فقط قائمة الرسائل المحدثة لتجنب التكرار
              final allMessages = List<Message>.from(chat.messages);
              allMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

              return RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchChatDetails(conversationId);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: allMessages.length,
                  itemBuilder: (context, index) {
                    final Message msg = allMessages[index];
                    // تحديد إذا كانت الرسالة مني أم من الآخر
                    final bool isMe = msg.senderId == chat.userId;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Card(
                        color: isMe ? Colors.teal[100] : Colors.orange[100],
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            msg.message,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          // حقل إدخال الرسالة
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Write message...",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: () async {
                    String message = messageController.text.trim();
                    if (message.isNotEmpty) {
                      await sendController.sendMessage(conversationId, message);
                      messageController.clear();

                      // بعد الإرسال، عمل Refresh للحصول على الرسائل المحدثة
                      await controller.fetchChatDetails(conversationId);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
