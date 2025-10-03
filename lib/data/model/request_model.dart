class RequestModel {
  final int id;
  final int teacherId;
  final int subjectId;
  final String status;
  final SubjectModel subject;

  RequestModel({
    required this.id,
    required this.teacherId,
    required this.subjectId,
    required this.status,
    required this.subject,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      teacherId: json['teacher_id'],
      subjectId: json['subject_id'],
      status: json['status'],
      subject: SubjectModel.fromJson(json['subject']),
    );
  }
}

class SubjectModel {
  final int id;
  final String title;
  final String price;

  SubjectModel({
    required this.id,
    required this.title,
    required this.price,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      title: json['title'],
      price: json['price'],
    );
  }
}
