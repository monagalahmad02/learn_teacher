class TestModel1 {
  final int id;
  final int user_id;
  final int subjectId;
  final String? testName;
  final String createdAt;
  final String updatedAt;

  TestModel1({
    required this.id,
    required this.user_id,
    required this.subjectId,
    required this.testName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TestModel1.fromJson(Map<String, dynamic> json) {
    return TestModel1(
      id: json['id'],
      user_id: json['user_id'],
      subjectId: json['subject_id'],
      testName: json['test_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'subject_id': subjectId,
      'test_name': testName,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
