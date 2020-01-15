import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseURL = "";
  static final loginURL = baseURL + "/oauth/token";
  static final sendOTPURL = baseURL + "/api/send_otp";
  static final verifyOTPURL = baseURL + "/api/otp_verify";
  static final registerURL = baseURL + "/api/register";
  static final getPollsURL = baseURL + "/api/polls";
  static final voteURL = baseURL + "/api/vote";

  Future<List> getPolls() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    String url = getPollsURL;
    Map res = await _netUtil.get(url);
    if (res.containsKey("error")) throw new Exception(res["error"]);
    return res['results'];
  }

  Future<String> vote(String accessToken, int pollId, int answerId) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + accessToken,
    };
    String url = voteURL + '/' + pollId.toString() + '/' + answerId.toString();
    print(url);
    Map res = await _netUtil.get(url, headers: headers);

    if (res.containsKey("error")) throw new Exception(res["error"]);

    return res["transactionStatus"];
  }

  Future<User> login(String username, String password) async {
    Map res = await _netUtil.post(loginURL, body: {
      'grant_type': 'password',
      'client_id': '',
      'client_secret': '',
      "username": Uri.encodeFull(username),
      "password": Uri.encodeFull(password)
    });

    if (res.containsKey("error")) throw new Exception(res["error_msg"]);

    return new User.map({
      "expires_in": res["expires_in"],
      "access_token": res["access_token"],
      "refresh_token": res["refresh_token"]
    });
  }

  Future<String> sendOTP(String mobileNo) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    Map res = await _netUtil.post(sendOTPURL,
        headers: headers,
        body: json.encode({
          "mobile_no": mobileNo.toString(),
        }));

    if (res.containsKey("error")) throw new Exception(res["error"]);

    return res["transactionStatus"];
  }

  Future<String> verifyOTP(String mobileNo, String otp) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    Map res = await _netUtil.post(verifyOTPURL,
        headers: headers,
        body: json.encode({
          "mobile_no": Uri.encodeFull(mobileNo),
          "otp": Uri.encodeFull(otp),
        }));

    if (res.containsKey("error")) throw new Exception(res["error"]);

    return res["transactionStatus"];
  }

  Future<String> register(String mobileNo, String email, String password,
      String retypePassword) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    Map res = await _netUtil.post(registerURL,
        headers: headers,
        body: json.encode({
          "mobile_no": Uri.encodeFull(mobileNo),
          "email": Uri.encodeFull(email),
          "password": Uri.encodeFull(password),
          "retype_password": Uri.encodeFull(retypePassword),
        }));

    if (res.containsKey("error")) throw new Exception(res["Message"]);
    print("does not contain error");
    return res["transactionStatus"];
  }
}
