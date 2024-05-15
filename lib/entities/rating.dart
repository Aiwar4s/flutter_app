import 'package:flutter_app/entities/user.dart';

class Rating{
  final int id;
  int stars;
  String comment;
  final User user;
  final User ratedUser;
  final DateTime createdAt;

  Rating({
    required this.id,
    required this.stars,
    required this.comment,
    required this.user,
    required this.ratedUser,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      stars: json['stars'],
      comment: json['comment'],
      user: User.fromJson(json['user']),
      ratedUser: User.fromJson(json['ratedUser']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stars': stars,
      'comment': comment,
    };
  }
}