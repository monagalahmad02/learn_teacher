class UserModel2 {
  final int id;
  final String name;
  final String phone;
  final String? userImage; // ✅ هنا التعديل
  final String email;
  final int roleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel2({
    required this.id,
    required this.name,
    required this.phone,
    required this.userImage, // ✅ هنا التعديل
    required this.email,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel2.fromJson(Map<String, dynamic> json) {
    return UserModel2(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      userImage: json['user_image'], // ممكن تكون null
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
