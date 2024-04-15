import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/providers/city_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/theme.dart';
import 'package:provider/provider.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) =>{
      runApp(
        MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => UserProvider()..loadUser()),
              Provider(create: (context) => CityProvider()..loadCities())
            ],
            child: const MyApp()
        ),
      )
    });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AngularApp',
      theme: darkTheme,
      home: const HomeScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
