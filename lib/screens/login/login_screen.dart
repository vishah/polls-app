import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:Polls/auth.dart';
import 'package:Polls/data/database_helper.dart';
import 'package:Polls/models/user.dart';
import 'package:Polls/data/rest_ds.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, _password;
  RestDatasource api = new RestDatasource();

  LoginScreenState() {
    this.checkLoggedIn();
  }

  checkLoggedIn() async {
    String currState = await getAuthState();
    if (currState != "logged_out") {
      Navigator.of(_ctx).pushReplacementNamed("/home");
    }
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      this.doLogin(_username, _password);
    }
  }

  doLogin(String username, String password) async {
    try {
      User user = await api.login(username, password);
      this.onLoginSuccess(user);
    } catch (error) {
      this.onLoginError(error.toString());
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("LOGIN"),
      color: Colors.primaries[0],
    );

    var loginForm = new Column(
      children: <Widget>[
        new Text(
          "Login App",
          textScaleFactor: 2.0,
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  validator: (val) {
                    return val.length < 10
                        ? "Username must have atleast 10 chars"
                        : null;
                  },
                  decoration: new InputDecoration(labelText: "Username"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              ),
            ],
          ),
        ),
        _isLoading ? new CircularProgressIndicator() : new TextField(),
        new Row(
          children: <Widget>[
            loginBtn,
            new RaisedButton(
              onPressed: () =>
                  Navigator.of(_ctx).pushReplacementNamed("/register"),
              child: new Text("Register"),
            ),
          ],
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("assets/diamond.png"), fit: BoxFit.cover),
        ),
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                child: loginForm,
                height: 300.0,
                width: 300.0,
                decoration: new BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  void onLoginSuccess(User user) async {
    _showSnackBar("Login Success");
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.saveUser(user);
    this.checkLoggedIn();
  }
}
