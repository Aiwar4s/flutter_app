import 'dart:convert';

import 'package:flutter/services.dart';

class CityProvider{
  List<String> _cities = [];
  List<String> get cities => _cities;

  Future<void> loadCities() async {
    String json = await rootBundle.loadString('assets/cities.json');
    _cities = List<String>.from(jsonDecode(json));
  }
}