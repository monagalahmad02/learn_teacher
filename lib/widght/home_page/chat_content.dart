import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project2teacher/data/constant/app_constant.dart';
import '../../contoller/chat/get_chat_controller.dart';
import '../../data/model/get_all_chat_model.dart';
import 'details_chat_page.dart';

class ChatContent extends StatelessWidget {
  const ChatContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());

    chatController.fetchChats();

    return Scaffold(
      body: Obx(() {
        if (chatController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (chatController.chats.isEmpty) {
          return RefreshIndicator(
              onRefresh: ()async{
                chatController.fetchChats();
              },
              child: const Center(child: Text("No found chatting")));
        }

        return RefreshIndicator(
          onRefresh: ()async{
            chatController.fetchChats();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: chatController.chats.length,
            itemBuilder: (context, index) {
              final GetChatModel chat = chatController.chats[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: chat.user.userImage != null
                        ? NetworkImage(
                        '${AppConstant.baseUrl}/${chat.user.userImage!}')
                        : null,
                    child: chat.user.userImage == null
                        ? Text(chat.user.name[0])
                        : null,
                  ),
                  title: Text(
                    chat.user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(chat.user.email),
                  trailing: chat.unreadCount > 0
                      ? CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.red,
                    child: Text(
                      chat.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  )
                      : null,
                  onTap: () {
                    Get.to(() => DetailsChatPage(
                      conversationId: chat.conversationId,
                      userName: chat.user.name,
                      userImage: chat.user.userImage != null
                          ? '${AppConstant.baseUrl}/${chat.user.userImage!}'
                          : null,
                    ));
                  },

                ),
              );
            },
          ),
        );
      }),
    );
  }
}
