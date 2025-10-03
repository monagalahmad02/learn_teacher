class StudentPointModel {
  final int teacherId;
  final List<StudentPoints> studentsPoints;

  StudentPointModel({
    required this.teacherId,
    required this.studentsPoints,
  });

  factory StudentPointModel.fromJson(Map<String, dynamic> json) {
    return StudentPointModel(
      teacherId: json['teacher_id'] ?? 0,
      studentsPoints: (json['students_points'] as List<dynamic>? ?? [])
          .map((e) => StudentPoints.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacher_id': teacherId,
      'students_points': studentsPoints.map((e) => e.toJson()).toList(),
    };
  }
}

class StudentPoints {
  final int id;
  final int studentId;
  final int teacherId;
  final int points;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Student student;

  StudentPoints({
    required this.id,
    required this.studentId,
    required this.teacherId,
    required this.points,
    required this.createdAt,
    required this.updatedAt,
    required this.student,
  });

  factory StudentPoints.fromJson(Map<String, dynamic> json) {
    return StudentPoints(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      teacherId: json['teacher_id'] ?? 0,
      points: json['points'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      student: Student.fromJson(json['student'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'teacher_id': teacherId,
      'points': points,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'student': student.toJson(),
    };
  }
}

class Student {
  final int id;
  final String name;
  final String phone;
  final String? userImage;
  final String email;
  final int roleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Student({
    required this.id,
    required this.name,
    required this.phone,
    this.userImage,
    required this.email,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      userImage: json['user_image'],
      email: json['email'] ?? '',
      roleId: json['role_id'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
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
