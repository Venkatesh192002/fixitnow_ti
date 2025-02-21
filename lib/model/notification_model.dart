import 'package:uuid/uuid.dart';

class NotificationModel {
  NotificationModel(this.title, this.description, this.dateTime)
      : id = const Uuid().v1();

  String? title;
  String? description;
  String? id;
  String? dateTime;

  NotificationModel.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    description = map['description'];
    id = map['unique_id'].toString();
    dateTime = map['datetime'].toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'unique_id': id,
      'datetime': dateTime
    };
  }
}
