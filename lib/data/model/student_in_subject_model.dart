class StudentInStudentModel {
  final int teacherId;
  final List<StudentData> students;

  StudentInStudentModel({
    required this.teacherId,
    required this.students,
  });

  factory StudentInStudentModel.fromJson(Map<String, dynamic> json) {
    return StudentInStudentModel(
      teacherId: json['teacher_id'],
      students: (json['students'] as List<dynamic>)
          .map((e) => StudentData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacher_id': teacherId,
      'students': students.map((e) => e.toJson()).toList(),
    };
  }
}

class StudentData {
  final int studentId;
  final Student student;

  StudentData({
    required this.studentId,
    required this.student,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      studentId: json['student_id'],
      student: Student.fromJson(json['student']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
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
    required this.userImage,
    required this.email,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
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
