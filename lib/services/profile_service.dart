import 'dart:convert';

import '../api_constants.dart';
import '../entities/user_stats.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  Future<UserStats> getUserStats(String userId) async {
    final response = await http.get(Uri.parse('${ApiConstants.profile}/$userId'));
    if(response.statusCode == 200){
      return UserStats.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception("Failed to load user stats");
    }
  }
}