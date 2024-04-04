import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final bool loggedIn;

  const CustomAppBar({super.key, required this.title, required this.loggedIn});

  @override
  Widget build(BuildContext context){
    return AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (value){
              if(value == 'Login'){
                handleLogin(context);
              }else if(value == 'Sign up'){
                handleRegister(context);
              }else if(value == 'Logout'){
                handleLogout(context);
              }
            },
            itemBuilder: (BuildContext context) => loggedIn
                ? <PopupMenuEntry<String>>[
                  const PopupMenuItem(
                    value: 'Logout',
                    child: Text('Logout')
                  )
                ]
                : <PopupMenuEntry<String>>[
                  const PopupMenuItem(
                    value: 'Login',
                    child: Text('Login')),
                  const PopupMenuItem(
                    value: 'Sign up',
                    child: Text('Sign up'),
                  )
                ]
          )
        ]
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void handleLogin(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void handleRegister(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  Future<void> handleLogout(BuildContext context) async{
    final username = Provider.of<UserProvider>(context, listen: false).user!.username;
    await AuthService.logout(username);
    Provider.of<UserProvider>(context, listen: false).clearUser();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
  }
}