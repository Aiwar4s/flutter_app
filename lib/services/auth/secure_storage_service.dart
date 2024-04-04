import 'dart:convert';

import 'package:flutter_app/entities/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService{
  var storage = const FlutterSecureStorage();

  Future<void> writeAccessToken(String token) => storage.write(key: 'accessToken', value: token);
  Future<void> writeRefreshToken(String token) => storage.write(key: 'refreshToken', value: token);
  Future<void> writeUserInfo(User user) async{
    final userData = jsonEncode(user);
    storage.write(key: 'user', value: userData);
  }

  Future<String?> readAccessToken() => storage.read(key: 'accessToken');
  Future<String?> readRefreshToken() => storage.read(key: 'refreshToken');
  Future<User?> readUserInfo() async{
    final userData = await storage.read(key: 'user');
    if(userData != null){
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<void> deleteUserInfo() async{
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
    await storage.delete(key: 'user');
  }
}