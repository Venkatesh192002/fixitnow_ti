class SqliteNotificationModel {
  const SqliteNotificationModel({
    required this.userId,
    required this.uniqueId,
    required this.notificationTitle,
    required this.notificationDescription,
  });

  final String userId;
  final String uniqueId;
  final String notificationTitle;
  final String notificationDescription;

  factory SqliteNotificationModel.fromJson(Map<String, dynamic> json) {
    return SqliteNotificationModel(
      userId: json['user_id'],
      uniqueId: json['unique_id'],
      notificationTitle: json['title'],
      notificationDescription: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'unique_id': uniqueId,
      'title': notificationTitle,
      'description': notificationDescription
    };
  }
}
