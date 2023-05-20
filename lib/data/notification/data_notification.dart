import 'package:enum_to_string/enum_to_string.dart';

class DataNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType? notificationType;
  final String imageUrl;
  final dynamic data;
  final DateTime? readAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String userId;

  DataNotification(
      {required this.id,
      required this.title,
      required this.body,
      this.notificationType,
      required this.imageUrl,
      this.data,
      this.readAt,
      this.createdAt,
      this.updatedAt,
      required this.userId});

  factory DataNotification.fromPushMessage(dynamic data) {
    return DataNotification(
      id: data['id'],
      title: data['title'],
      body: data['body'],
      userId: data['user_id'],
      notificationType: EnumToString.fromString(
          NotificationType.values, data['notification_type']),
      imageUrl: data['image_url'],
      data: data,
      readAt: null,
      createdAt: null,
      updatedAt: null,
    );
  }
}

enum NotificationType {
  NONE,
  NEW_INVITATION,
  NEW_MEMBERSHIP,
  NEW_ADMIN_ROLE,
  MEMBERSHIP_BLOCKED,
  MEMBERSHIP_REMOVED,
  NEW_MEMBERSHIP_REQUEST
}
