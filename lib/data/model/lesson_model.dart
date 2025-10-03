class LessonModel {
  final int id;
  final int subjectId;
  final int teacherId;
  final String title;
  final String? videoPath;
  final String? summaryPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  LessonModel({
    required this.id,
    required this.subjectId,
    required this.teacherId,
    required this.title,
    this.videoPath,
    this.summaryPath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'],
      subjectId: json['subject_id'],
      teacherId: json['teacher_id'],
      title: json['title'],
      videoPath: json['video_path'],
      summaryPath: json['summary_path'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_id': subjectId,
      'teacher_id': teacherId,
      'title': title,
      'video_path': videoPath,
      'summary_path': summaryPath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
