import 'package:flutter/material.dart';
import 'package:Polls/screens/home/home_screen.dart';
import 'package:Polls/screens/login/login_screen.dart';
import 'package:Polls/screens/register/register_screen.dart';

final routes = {
  '/login': (BuildContext context) => new LoginScreen(),
  '/register': (BuildContext context) => new RegisterScreen(),
  '/home': (BuildContext context) => new HomeScreen(),
  '/': (BuildContext context) => new LoginScreen(),
};
