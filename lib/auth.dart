import 'package:Polls/data/database_helper.dart';
import 'dart:async';

Future getAuthState() async {
  var db = new DatabaseHelper();
  var isLoggedIn = await db.isLoggedIn();
  if (isLoggedIn)
    return "logged_in";
  else
    return ("logged_out");
}

Future getAccessToken() async {
  var db = new DatabaseHelper();
  Map getUser = await db.getUser();
  if (getUser.containsKey('access_token'))
    return getUser['access_token'];
  else
    return '';
}
