class GetChatModel {
  final int conversationId;
  final int unreadCount;
  final User user;

  GetChatModel({
    required this.conversationId,
    required this.unreadCount,
    required this.user,
  });

  factory GetChatModel.fromJson(Map<String, dynamic> json) {
    return GetChatModel(
      conversationId: json['conversation_id'] ?? 0,
      unreadCount: json['unread_count'] ?? 0,
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'unread_count': unreadCount,
      'user': user.toJson(),
    };
  }
}

class User {
  final int id;
  final String name;
  final String phone;
  final String? userImage;
  final String email;
  final int roleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.phone,
    this.userImage,
    required this.email,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      userImage: json['user_image'],
      email: json['email'] ?? '',
      roleId: json['role_id'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'user_image': userImage,
      'email': email,
      'role_id': roleId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
