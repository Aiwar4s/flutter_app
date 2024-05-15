import 'package:flutter/material.dart';
import 'package:flutter_app/screens/trip/created_trips_screen.dart';
import 'package:flutter_app/screens/trip/joined_trips_screen.dart';
import 'package:flutter_app/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';

import '../entities/user.dart';
import '../providers/user_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home_screen.dart';
import '../services/auth/auth_service.dart';

class CustomDrawer extends StatelessWidget {
  final bool loggedIn;
  final bool isAdmin;
  final User? user;

  const CustomDrawer({super.key, required this.loggedIn, this.isAdmin = false, this.user });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          if(loggedIn)
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(user: user!)));
              }
            ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
            },
          ),
          if (!loggedIn)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
            ),
          if (!loggedIn)
            ListTile(
              leading: const Icon(Icons.app_registration),
              title: const Text('Sign up'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
              },
            ),
          if (loggedIn)
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('My Trips'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatedTripsScreen()));
              },
            ),
          if (loggedIn)
            ListTile(
              leading: const Icon(Icons.directions_car_outlined),
              title: const Text('Joined Trips'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const JoinedTripsScreen()));
              },
            ),
          if (loggedIn)
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red.withOpacity(0.7)),
              title: Text('Logout',
                  style: TextStyle(
                      color: Colors.red.withOpacity(0.7),
                      fontWeight: FontWeight.bold
                  ),
              ),
              onTap: () {
                _handleLogout(context);
              },
            ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async{
    final username = Provider.of<UserProvider>(context, listen: false).user!.username;
    await AuthService.logout(username);
    Provider.of<UserProvider>(context, listen: false).clearUser();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
  }
}