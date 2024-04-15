import 'package:flutter_app/entities/user.dart';

class Message{
  final int tripId;
  final String content;
  final DateTime sentAt;
  final User user;

  Message({
    required this.tripId,
    required this.content,
    required this.sentAt,
    required this.user,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      tripId: json['tripId'],
      content: json['content'],
      sentAt: DateTime.parse(json['sentAt']),
      user: User.fromJson(json['user']),
    );
  }
}