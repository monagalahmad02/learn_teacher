class SubjectModel {
  final int id;
  final String title;
  final String price;
  final int? teacherId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic teacher;

  SubjectModel({
    required this.id,
    required this.title,
    required this.price,
    required this.teacherId,
    required this.createdAt,
    required this.updatedAt,
    this.teacher,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      teacherId: json['teacher_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      teacher: json['teacher'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'teacher_id': teacherId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'teacher': teacher,
    };
  }
}
