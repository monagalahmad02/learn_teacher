class NotificationUnreadCountModel {
  final int? unreadCount;

  NotificationUnreadCountModel({this.unreadCount});

  factory NotificationUnreadCountModel.fromJson(Map<String, dynamic> json) {
    return NotificationUnreadCountModel(
      unreadCount: json['unread_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unread_count': unreadCount,
    };
  }
}
