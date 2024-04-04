import 'package:flutter/material.dart';

import 'package:flutter_app/entities/user.dart';
import 'package:flutter_app/services/auth/secure_storage_service.dart';

class UserProvider with ChangeNotifier{
  User? _user;

  User? get user => _user;

  Future<void> loadUser() async{
    _user = await SecureStorageService().readUserInfo();
    notifyListeners();
  }

  void setUser(User user){
    _user = user;
    SecureStorageService().writeUserInfo(user);
    notifyListeners();
  }

  void clearUser(){
    _user = null;
    notifyListeners();
  }
}