import 'package:flutter_app/entities/user.dart';
import 'package:flutter_app/entities/user_trip.dart';

class Trip {
  final int id;
  final String departure;
  final String destination;
  final String description;
  final DateTime date;
  final int seats;
  final int seatsTaken;
  final num price;
  User? user;
  List<UserTrip>? userTrips;

  Trip({
    required this.id,
    required this.departure,
    required this.destination,
    required this.description,
    required this.date,
    required this.seats,
    required this.seatsTaken,
    required this.price,
    this.user,
    this.userTrips,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      departure: json['departure'],
      destination: json['destination'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      seats: json['seats'],
      seatsTaken: json['seatsTaken'],
      price: json['price'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      userTrips: json['userTrips'] != null
          ? List<UserTrip>.from(json['userTrips'].map((trip) => UserTrip.fromJson(trip)))
          : null,
    );
  }

  Map<String, dynamic> toCreateTripJson() {
    return {
      'departure': departure,
      'destination': destination,
      'description': description,
      'date': date.toIso8601String(),
      'seats': seats,
      'price': price,
    };
  }

  Map<String, dynamic> toEditTripJson() {
    return {
      'description': description,
      'date': date.toIso8601String(),
      'seats': seats,
      'price': price,
    };
  }
}