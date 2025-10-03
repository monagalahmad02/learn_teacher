class QuestionChallengeModel {
  final int id;
  final int lessonId;
  final String questionText;
  final int pageNumber;
  final String explanation;
  final int? parentQuestionId;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Pivot pivot;
  final List<Option> options;

  QuestionChallengeModel({
    required this.id,
    required this.lessonId,
    required this.questionText,
    required this.pageNumber,
    required this.explanation,
    this.parentQuestionId,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
    required this.options,
  });

  factory QuestionChallengeModel.fromJson(Map<String, dynamic> json) {
    return QuestionChallengeModel(
      id: json['id'] ?? 0,
      lessonId: json['lesson_id'] ?? 0,
      questionText: json['question_text'] ?? '',
      pageNumber: json['page_number'] ?? 0,
      explanation: json['explanation'] ?? '',
      parentQuestionId: json['parent_question_id'],
      isFavorite: json['is_favorite'] == 1,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      pivot: Pivot.fromJson(json['pivot']),
      options: (json['options'] as List<dynamic>? ?? [])
          .map((e) => Option.fromJson(e))
          .toList(),
    );
  }
}

class Pivot {
  final int challengeId;
  final int questionId;

  Pivot({
    required this.challengeId,
    required this.questionId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      challengeId: json['challenge_id'] ?? 0,
      questionId: json['question_id'] ?? 0,
    );
  }
}

class Option {
  final int id;
  final int questionId;
  final String optionText;
  final bool isCorrect;
  final DateTime createdAt;
  final DateTime updatedAt;

  Option({
    required this.id,
    required this.questionId,
    required this.optionText,
    required this.isCorrect,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] ?? 0,
      questionId: json['question_id'] ?? 0,
      optionText: json['option_text'] ?? '',
      isCorrect: json['is_correct'] == 1,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
