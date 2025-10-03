class NotificationModel {
  final NotificationData? data;
  final int? unreadCount;

  NotificationModel({this.data, this.unreadCount});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      data: json['data'] != null ? NotificationData.fromJson(json['data']) : null,
      unreadCount: json['unread_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'unread_count': unreadCount,
    };
  }
}

class NotificationData {
  final int? currentPage;
  final List<NotificationItem>? notifications;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<PageLink>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  NotificationData({
    this.currentPage,
    this.notifications,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      currentPage: json['current_page'],
      notifications: json['data'] != null
          ? List<NotificationItem>.from(
          json['data'].map((x) => NotificationItem.fromJson(x)))
          : [],
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: json['links'] != null
          ? List<PageLink>.from(json['links'].map((x) => PageLink.fromJson(x)))
          : [],
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'] is int
          ? json['per_page']
          : int.tryParse(json['per_page'].toString()),
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': notifications?.map((e) => e.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links?.map((e) => e.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class NotificationItem {
  final String? id;
  final String? type;
  final String? notifiableType;
  final int? notifiableId;
  final NotificationMessageData? data;
  final String? readAt;
  final String? createdAt;
  final String? updatedAt;

  NotificationItem({
    this.id,
    this.type,
    this.notifiableType,
    this.notifiableId,
    this.data,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      type: json['type'],
      notifiableType: json['notifiable_type'],
      notifiableId: json['notifiable_id'],
      data: json['data'] != null
          ? NotificationMessageData.fromJson(json['data'])
          : null,
      readAt: json['read_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'notifiable_type': notifiableType,
      'notifiable_id': notifiableId,
      'data': data?.toJson(),
      'read_at': readAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class NotificationMessageData {
  final String? studentName;
  final String? subjectName;
  final String? message;

  NotificationMessageData({this.studentName, this.subjectName, this.message});

  factory NotificationMessageData.fromJson(Map<String, dynamic> json) {
    return NotificationMessageData(
      studentName: json['student_name'],
      subjectName: json['subject_name'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_name': studentName,
      'subject_name': subjectName,
      'message': message,
    };
  }
}

class PageLink {
  final String? url;
  final String? label;
  final bool? active;

  PageLink({this.url, this.label, this.active});

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
