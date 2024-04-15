import 'dart:convert';
import 'dart:core';
import 'package:flutter_app/services/auth/jwt_service.dart';
import 'package:flutter_app/services/auth/secure_storage_service.dart';
import 'package:flutter_app/services/auth/auth_api_client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    final response = await AuthApiClient().login(email, password);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      await _saveTokens(responseBody);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> register(String email, String username, String password) async {
    final response = await AuthApiClient().register(email, username, password);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      await _saveTokens(responseBody);
      return true;
    }
    return false;
  }

  static Future<void> logout(String username) async {
    final response = await AuthApiClient().logout(username);
    if (response.statusCode == 200) {
      await SecureStorageService().deleteUserInfo();
    } else {
      throw Exception('Failed to logout');
    }
  }

  Future<void> refreshToken() async {
    final accessToken = await SecureStorageService().readAccessToken();
    if(accessToken == null) {
      throw Exception('No access token found');
    }
    if(JwtDecoder.isExpired(accessToken)) {
      final refreshToken = await SecureStorageService().readRefreshToken();
      if(refreshToken == null) {
        throw Exception('No refresh token found');
      }
      final response = await AuthApiClient().refreshToken(refreshToken);
      if(response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        await _saveTokens(responseBody);
      } else {
        throw Exception('Failed to refresh token');
      }
    }
  }

  static Future<void> _saveTokens(Map<String, dynamic> responseBody) async {
    final accessToken = responseBody['accessToken'];
    final refreshToken = responseBody['refreshToken'];
    final user = JwtService.getUserFromToken(accessToken);
    await SecureStorageService().writeAccessToken(accessToken);
    await SecureStorageService().writeRefreshToken(refreshToken);
    await SecureStorageService().writeUserInfo(user);
  }

  static Future<bool> isLoggedIn() async {
    return await SecureStorageService().readAccessToken() != null;
  }
}
