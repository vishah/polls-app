import 'package:flutter/material.dart';
import 'package:Polls/routes.dart';
import 'package:Polls/auth.dart';

void main() => runApp(new PollsApp());

class PollsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Polls',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: routes,
    );
  }
}
