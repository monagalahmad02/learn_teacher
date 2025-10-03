class ChallengeModel {
  final int id;
  final int teacherId;
  final String title;
  final int pointsTransferred;
  final DateTime startTime;
  final int durationMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChallengeModel({
    required this.id,
    required this.teacherId,
    required this.title,
    required this.pointsTransferred,
    required this.startTime,
    required this.durationMinutes,
    required this.createdAt,
    required this.updatedAt,
  });

  // تحويل من JSON إلى موديل
  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['id'] ?? 0,
      teacherId: json['teacher_id'] ?? 0,
      title: json['title'] ?? '',
      pointsTransferred: json['points_transferred'] ?? 0,
      startTime: DateTime.parse(json['start_time']),
      durationMinutes: json['duration_minutes'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // تحويل من موديل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'title': title,
      'points_transferred': pointsTransferred,
      'start_time': startTime.toIso8601String(),
      'duration_minutes': durationMinutes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
