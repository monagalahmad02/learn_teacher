class QuestionModel {
  final int id;
  final int lessonId;
  final String questionText;
  final int pageNumber;
  final String? explanation;
  final int? parentQuestionId;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuestionModel({
    required this.id,
    required this.lessonId,
    required this.questionText,
    required this.pageNumber,
    this.explanation,
    this.parentQuestionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      lessonId: json['lesson_id'],
      questionText: json['question_text'],
      pageNumber: json['page_number'],
      explanation: json['explanation'],
      parentQuestionId: json['parent_question_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'question_text': questionText,
      'page_number': pageNumber,
      'explanation': explanation,
      'parent_question_id': parentQuestionId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
