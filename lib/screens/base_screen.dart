import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final String title;
  final bool loggedIn;

  const BaseScreen({super.key, required this.title, required this.loggedIn, required this.child,});

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = loggedIn ? Provider.of<UserProvider>(context).user!.isAdmin : false;

    return Scaffold(
      appBar: CustomAppBar(title: title, loggedIn: loggedIn),
      drawer: CustomDrawer(loggedIn: loggedIn, isAdmin: isAdmin), // replace with actual values
      body: child,
    );
  }
}