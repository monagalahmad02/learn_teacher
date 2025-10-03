class GetChatDetailsModel {
  final int userId;
  final List<Message> messages;
  final List<Message> unreadMessages;

  GetChatDetailsModel({
    required this.userId,
    required this.messages,
    required this.unreadMessages,
  });

  factory GetChatDetailsModel.fromJson(Map<String, dynamic> json) {
    return GetChatDetailsModel(
      userId: json['user_id'] ?? 0,
      messages: (json['messages'] as List)
          .map((e) => Message.fromJson(e))
          .toList(),
      unreadMessages: (json['unread_messages'] as List)
          .map((e) => Message.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'messages': messages.map((e) => e.toJson()).toList(),
      'unread_messages': unreadMessages.map((e) => e.toJson()).toList(),
    };
  }
}

class Message {
  final int id;
  final int conversationId;
  final int senderId;
  final String message;
  final int isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      conversationId: json['conversation_id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      message: json['message'] ?? '',
      isRead: json['is_read'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
