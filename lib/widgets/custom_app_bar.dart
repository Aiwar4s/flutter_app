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
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}