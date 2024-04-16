import 'package:flutter_app/entities/user.dart';

class UserTrip{
  final int id;
  final int seats;
  final int tripId;
  final User user;

  UserTrip({
    required this.id,
    required this.seats,
    required this.tripId,
    required this.user,
  });

  factory UserTrip.fromJson(Map<String, dynamic> json){
    return UserTrip(
      id: json['id'],
      seats: json['seats'],
      tripId: json['tripId'],
      user: User.fromJson(json['user']),
    );
  }
}