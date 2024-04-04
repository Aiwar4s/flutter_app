import 'dart:convert';
import 'package:flutter_app/api_constants.dart';
import 'package:http/http.dart' as http;

class AuthApiClient {
  static const String baseUrl = ApiConstants.auth;

  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    Map data = {
      'email': email,
      'password': password
    };
    var body=json.encode(data);
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
  }

  Future<http.Response> register(String email, String username, String password) async {
    final url = Uri.parse('$baseUrl/register');
    Map data = {
      'email': email,
      'username': username,
      'password': password
    };
    var body=json.encode(data);
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body
    );
  }

  Future<http.Response> refreshToken(String refreshToken) async {
    final url = Uri.parse('$baseUrl/refresh-token');
    Map data = {
      'refreshToken': refreshToken
    };
    var body=json.encode(data);
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body
    );
  }

  Future<http.Response> logout(String username) async{
    final url = Uri.parse('$baseUrl/logout');
    Map data = {
      'username': username
    };
    var body=json.encode(data);
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body
    );
  }
}