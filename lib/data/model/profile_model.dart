class ProfileModel {
  final int id;
  final int teacherId;
  final String teachingStartDate;
  final String province;
  final String bio;
  final String specialization;
  final String age;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileModel({
    required this.id,
    required this.teacherId,
    required this.teachingStartDate,
    required this.province,
    required this.bio,
    required this.specialization,
    required this.age,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      teacherId: json['teacher_id'],
      teachingStartDate: json['teaching_start_date'],
      province: json['province'],
      bio: json['bio'],
      specialization: json['specialization'],
      age: json['age'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'teaching_start_date': teachingStartDate,
      'province': province,
      'bio': bio,
      'specialization': specialization,
      'age': age,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
