class FavTestModel {
  final int id;
  final int userId;
  final int subjectId;
  final String? testName;
  final String createdAt;
  final String updatedAt;

  FavTestModel({
    required this.id,
    required this.userId,
    required this.subjectId,
    this.testName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FavTestModel.fromJson(Map<String, dynamic> json) {
    return FavTestModel(
      id: json['id'],
      userId: json['user_id'],
      subjectId: json['subject_id'],
      testName: json['test_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'subject_id': subjectId,
      'test_name': testName,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
