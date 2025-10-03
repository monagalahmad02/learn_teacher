class TestModel {
  final int testId;
  final List<Question> questions;

  TestModel({
    required this.testId,
    required this.questions,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      testId: json['test_id'] ?? 0,
      questions: (json['questions'] as List<dynamic>)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'test_id': testId,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class Question {
  final int id;
  final int lessonId;
  final String questionText;
  final int pageNumber;
  final String explanation;
  final int? parentQuestionId;
  final int? selectedOptionId;
  final bool isCorrect;
  final List<Option> options;

  Question({
    required this.id,
    required this.lessonId,
    required this.questionText,
    required this.pageNumber,
    required this.explanation,
    this.parentQuestionId,
    this.selectedOptionId,
    required this.isCorrect,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      lessonId: json['lesson_id'],
      questionText: json['question_text'],
      pageNumber: json['page_number'],
      explanation: json['explanation'],
      parentQuestionId: json['parent_question_id'],
      selectedOptionId: json['pivot']?['selected_option_id'],
      isCorrect: (json['pivot']?['is_correct'] ?? 0) == 1,
      options: (json['options'] as List<dynamic>)
          .map((o) => Option.fromJson(o))
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
      'pivot': {
        'selected_option_id': selectedOptionId,
        'is_correct': isCorrect ? 1 : 0,
      },
      'options': options.map((o) => o!.toJson()).toList(),
    };
  }
}

class Option {
  final int id;
  final int questionId;
  final String optionText;
  final bool isCorrect;

  Option({
    required this.id,
    required this.questionId,
    required this.optionText,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      questionId: json['question_id'],
      optionText: json['option_text'],
      isCorrect: json['is_correct'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'option_text': optionText,
      'is_correct': isCorrect ? 1 : 0,
    };
  }
}
