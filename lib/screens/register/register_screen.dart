import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:Polls/auth.dart';
import 'package:Polls/data/database_helper.dart';
import 'package:Polls/models/user.dart';
import 'package:Polls/data/rest_ds.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  BuildContext _ctx;

  bool _sendOTPSuccess = false;
  bool _verifyOTPSuccess = false;
  bool _registerSuccess = false;
  bool _isLoading = false;
  final mobileNoFormKey = new GlobalKey<FormState>();
  final otpFormKey = new GlobalKey<FormState>();
  final registerFormKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _mobileNo, _otp, _name, _email, _password, _retypePassword;
  RestDatasource api = new RestDatasource();

  void _mobileNoSubmit() {
    final form = mobileNoFormKey.currentState;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
      });
      form.save();
      this.sendOTP(_mobileNo);
    }
  }

  void _otpSubmit() {
    final form = otpFormKey.currentState;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
      });
      form.save();
      this.verifyOTP(_mobileNo, _otp);
    }
  }

  void _registerSubmit() {
    final form = registerFormKey.currentState;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
      });
      form.save();
      print("Dfdfdf");
      this.register(_mobileNo, _email, _password, _retypePassword);
    }
  }

  register(String mobileNo, String email, String password,
      String retypePassword) async {
    try {
      String result =
          await api.register(mobileNo, email, password, retypePassword);
      this.onRegisterSuccess();
    } catch (error) {
      this.onRegisterError(error.toString());
    }
  }

  sendOTP(String mobileNo) async {
    try {
      String result = await api.sendOTP(mobileNo);
      this.onSendOTPSuccess();
    } catch (error) {
      this.onSendOTPError(error.toString());
    }
  }

  verifyOTP(String mobileNo, String otp) async {
    try {
      String result = await api.verifyOTP(mobileNo, otp);
      this.onVerifyOTPSuccess();
    } catch (error) {
      this.onVerifyOTPError(error.toString());
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    var registrationForms = new Column(
      children: <Widget>[
        new Text(
          "Login App",
          textScaleFactor: 2.0,
        ),
        new Column(
          children: buildForms(),
        ),
        _isLoading ? new CircularProgressIndicator() : new TextField(),
        new Row(children: buildButtons())
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
                child: registrationForms,
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

  List<Widget> buildForms() {
    List<Widget> builder = [];
    if (_sendOTPSuccess == false) {
      builder.add(
        new Form(
          key: mobileNoFormKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _mobileNo = val,
                  validator: (val) {
                    return val.length < 7
                        ? "Mobile No. must have atleast 10 chars"
                        : null;
                  },
                  decoration: new InputDecoration(labelText: "Mobile No."),
                ),
              )
            ],
          ),
        ),
      );
    } else if (_sendOTPSuccess == true && _verifyOTPSuccess == false) {
      builder.add(
        new Form(
          key: otpFormKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _otp = val,
                  decoration: new InputDecoration(labelText: "OTP"),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      builder.add(
        new Form(
          key: registerFormKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _name = val,
                  decoration: new InputDecoration(labelText: "Name"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _email = val,
                  decoration: new InputDecoration(labelText: "Email"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _retypePassword = val,
                  decoration: new InputDecoration(labelText: "Retype password"),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return builder;
  }

  List<Widget> buildButtons() {
    List<Widget> builder = [];
    if (_sendOTPSuccess == false) {
      builder.add(new RaisedButton(
        onPressed: () => this._mobileNoSubmit(),
        child: new Text("Next"),
      ));
    } else if (_sendOTPSuccess == true && _verifyOTPSuccess == false) {
      builder.add(new RaisedButton(
        onPressed: () => this._otpSubmit(),
        child: new Text("Verify OTP"),
      ));
    } else {
      builder.add(new RaisedButton(
        onPressed: () => this._registerSubmit(),
        child: new Text("Register"),
      ));
    }
    return builder;
  }

  void onSendOTPError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() {
      _sendOTPSuccess = false;
      _isLoading = false;
    });
  }

  void onSendOTPSuccess() async {
    _showSnackBar("Please Enter the OTP received");
    setState(() {
      _sendOTPSuccess = true;
      _isLoading = false;
    });
  }

  void onVerifyOTPError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() {
      _verifyOTPSuccess = false;
      _isLoading = false;
    });
  }

  void onVerifyOTPSuccess() async {
    _showSnackBar("OTP Verified");
    setState(() {
      _verifyOTPSuccess = true;
      _isLoading = false;
    });
  }

  void onRegisterError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() {
      _registerSuccess = false;
      _isLoading = false;
    });
  }

  void onRegisterSuccess() async {
    _showSnackBar("Registration Successful");
    setState(() {
      _registerSuccess = true;
      _isLoading = false;
      Navigator.of(_ctx).pushReplacementNamed("/login");
    });
  }
}
