class StudentModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final int roleId;
  final String createdAt;
  final String updatedAt;
  final String? userImage;

  StudentModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
    this.userImage,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      roleId: json['role_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userImage: json['user_image'], // ✅ متطابق مع الريسبونس
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'role_id': roleId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_image': userImage,
    };
  }
}
