import 'package:flutter_app/entities/rating.dart';

class UserStats{
  final String id;
  final String username;
  final num averageRating;
  final List<Rating> ratings;
  final int tripsCount;
  final int userTripsCount;

  UserStats(this.id, this.username, this.averageRating, this.ratings, this.tripsCount, this.userTripsCount);

  factory UserStats.fromJson(Map<String, dynamic> json){
    return UserStats(
      json['id'],
      json['username'],
      json['averageRating'],
      List<Rating>.from(json['ratings'].map((rating) => Rating.fromJson(rating))),
      json['tripsCount'],
      json['userTripsCount']
    );
  }
}