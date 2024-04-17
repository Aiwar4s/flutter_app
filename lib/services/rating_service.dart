import 'dart:convert';

import 'package:flutter_app/api_constants.dart';
import 'package:flutter_app/services/auth/auth_service.dart';
import 'package:flutter_app/services/auth/secure_storage_service.dart';
import 'package:http/http.dart' as http;

import '../entities/rating.dart';

class RatingService {
  Future<Rating> createRating(String userId, Rating rating) async {
    AuthService().refreshToken();
    final accessToken = await SecureStorageService().readAccessToken();
    final response = await http.post(
      Uri.parse('${ApiConstants.ratings}/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(rating.toJson()),
    );

    if (response.statusCode == 201) {
      return Rating.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create rating');
    }
  }

  Future<Rating?> getMyRating(String userId) async {
    AuthService().refreshToken();
    final accessToken = await SecureStorageService().readAccessToken();
    final response = await http.get(
      Uri.parse('${ApiConstants.ratings}/$userId/my-rating'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      return Rating.fromJson(jsonDecode(response.body));
    } else if(response.statusCode == 404){
      return null;
    } else {
      throw Exception('Failed to get rating');
    }
  }

  Future<Rating> updateRating(String userId, Rating rating) async {
    AuthService().refreshToken();
    final accessToken = await SecureStorageService().readAccessToken();
    final response = await http.put(
      Uri.parse('${ApiConstants.ratings}/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(rating.toJson()),
    );

    if (response.statusCode == 200) {
      return Rating.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update rating');
    }
  }

  Future<void> deleteRating(String userId, int ratingId) async {
    AuthService().refreshToken();
    final accessToken = await SecureStorageService().readAccessToken();
    final response = await http.delete(
      Uri.parse('${ApiConstants.ratings}/$userId/$ratingId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete rating');
    }
  }
}