class CommitModel {
  final int id;
  final int lessonId;
  final int userId;
  final String content;
  final int? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel user;

  CommitModel({
    required this.id,
    required this.lessonId,
    required this.userId,
    required this.content,
    required this.parentId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory CommitModel.fromJson(Map<String, dynamic> json) {
    return CommitModel(
      id: json['id'],
      lessonId: json['lesson_id'],
      userId: json['user_id'],
      content: json['content'],
      parentId: json['parent_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'user_id': userId,
      'content': content,
      'parent_id': parentId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user.toJson(),
    };
  }
}


class UserModel {
  final int id;
  final String name;
  final String phone;
  final String? userImage;
  final String email;
  final int roleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.userImage,
    required this.email,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      userImage: json['user_image'],
      email: json['email'],
      roleId: json['role_id'],
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
