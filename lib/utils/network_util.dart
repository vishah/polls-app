import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url, {Map headers, body, encoding}) {
    return http.get(url, headers: headers).then((http.Response response) {
      final String res = response.body;

      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<Map> post(String url, {Map headers, body, encoding}) async {
    try {
      http.Response response = await http.post(url,
          body: body, headers: headers, encoding: encoding);

      Map res = json.decode(response.body);

      int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return res;
    } catch (e, s) {
      throw new Exception("Error while fetching data" + e.toString());
    }
  }
}
