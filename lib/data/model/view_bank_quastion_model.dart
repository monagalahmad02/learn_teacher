class ViewBankQuestionModel {
  final int id;
  final int lessonId;
  final String questionText;
  final int pageNumber;
  final String explanation;
  final int? parentQuestionId;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<QuestionOption> options;

  ViewBankQuestionModel({
    required this.id,
    required this.lessonId,
    required this.questionText,
    required this.pageNumber,
    required this.explanation,
    this.parentQuestionId,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    required this.options,
  });

  factory ViewBankQuestionModel.fromJson(Map<String, dynamic> json) {
    return ViewBankQuestionModel(
      id: json['id'],
      lessonId: json['lesson_id'],
      questionText: json['question_text'],
      pageNumber: json['page_number'],
      explanation: json['explanation'],
      parentQuestionId: json['parent_question_id'],
      isFavorite: json['is_favorite'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      options: (json['options'] as List)
          .map((option) => QuestionOption.fromJson(option))
          .toList(),
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
      'is_favorite': isFavorite ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'options': options.map((o) => o.toJson()).toList(),
    };
  }
}

class QuestionOption {
  final int id;
  final int questionId;
  final String optionText;
  final bool isCorrect;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuestionOption({
    required this.id,
    required this.questionId,
    required this.optionText,
    required this.isCorrect,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'],
      questionId: json['question_id'],
      optionText: json['option_text'],
      isCorrect: json['is_correct'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'option_text': optionText,
      'is_correct': isCorrect ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
