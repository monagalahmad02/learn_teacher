class UserModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final int roleId;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.roleId,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    roleId: json['role_id'],
    profileImage: json['profile_image'],
  );
}

class SubjectModel {
  final int id;
  final String title;
  final String price;

  SubjectModel({
    required this.id,
    required this.title,
    required this.price,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
    id: json['id'],
    title: json['title'],
    price: json['price'],
  );
}

class RequestStudentModel {
  final int id;
  final int subjectId;
  final int userId;
  final int teacherId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel user;
  final SubjectModel subject;

  RequestStudentModel({
    required this.id,
    required this.subjectId,
    required this.userId,
    required this.teacherId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.subject,
  });

  factory RequestStudentModel.fromJson(Map<String, dynamic> json) => RequestStudentModel(
    id: json['id'],
    subjectId: json['subject_id'],
    userId: json['user_id'],
    teacherId: json['teacher_id'],
    status: json['status'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    user: UserModel.fromJson(json['user']),
    subject: SubjectModel.fromJson(json['subject']),
  );
}
