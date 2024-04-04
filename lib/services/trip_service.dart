import 'dart:convert';
import 'package:flutter_app/api_constants.dart';
import 'package:flutter_app/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/Entities/Trip.dart';

import 'auth/secure_storage_service.dart';

class TripService {
  Future<List<Trip>> getTrips() async{
    final response = await http.get(Uri.parse(ApiConstants.trips));
    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(response.body);
      return body.map((trip) => Trip.fromJson(trip)).toList();
    }
    else{
      throw Exception("Failed to load trips");
    }
  }

  Future<Trip> getTrip(int id) async{
    final response = await http.get(Uri.parse('${ApiConstants.trips}/$id'));
    if(response.statusCode == 200){
      return Trip.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception("Failed to load trip");
    }
  }

  Future<Trip> createTrip(Trip trip) async{
    AuthService().refreshToken();
    final accessToken = await SecureStorageService().readAccessToken();
    final response = await http.post(
      Uri.parse(ApiConstants.trips),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(trip.toCreateTripJson())
    );
    if(response.statusCode == 201){
      return Trip.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception("Failed to create trip");
    }
  }
}