import 'dart:convert';
import 'package:flutter_app/api_constants.dart';
import 'package:flutter_app/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/Entities/Trip.dart';

import 'auth/secure_storage_service.dart';

class TripService {
  Map<String, String> headers = {'Content-Type': 'application/json; charset=UTF-8'};

  Future<List<Trip>> getTrips() async{
    if(await AuthService.isLoggedIn()){
      AuthService().refreshToken();
      final accessToken = await SecureStorageService().readAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final response = await http.get(Uri.parse(ApiConstants.trips), headers: headers);
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

  Future<Trip> joinTrip(int id, int seats) async{
    AuthService().refreshToken();
    final accessToken = await SecureStorageService().readAccessToken();
    final response = await http.post(
      Uri.parse('${ApiConstants.trips}/$id/join'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode({'seats': seats})
    );
    if(response.statusCode == 200){
      return Trip.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception("Failed to join trip");
    }
  }

  Future<Trip> leaveTrip(int id) async{
    AuthService().refreshToken();
    final accessToken = await SecureStorageService().readAccessToken();
    final response = await http.delete(
      Uri.parse('${ApiConstants.trips}/$id/leave'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );
    if(response.statusCode == 200){
      return Trip.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception("Failed to leave trip");
    }
  }

  Future<void> deleteTrip(int id) async{
    AuthService().refreshToken();
    final accessToken = await SecureStorageService().readAccessToken();
    final response = await http.delete(
      Uri.parse('${ApiConstants.trips}/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );
    if(response.statusCode != 204){
      throw Exception("Failed to delete trip");
    }
  }
}