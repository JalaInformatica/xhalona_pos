import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xhalona_pos/core/constant/local_storage.dart';


Future<String?> getBaseUrl() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var baseUrl = prefs.getString('base');
  return baseUrl;
}

Future<Map<String, String>> requestHeaders() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  var datads = prefs.getString('datads');

  var username = prefs.getString('clientkey');

  await dotenv.load(fileName: 'assets/env/.env_dev');
  String password = dotenv.env['BASIC_AUTH'].toString();

  String basicAuth =
      'Basic ${base64.encode(utf8.encode('$username:$password'))}';

  var key = prefs.getString('key');

  Map<String, String> header = {
    'Authorization': basicAuth,
    'Content-Type': 'application/json;charset=UTF-8',
    'Charset': 'utf-8',
    "Accept": "application/json",
    'SERVER_KEY': '$key',
    'DATA_DS': '$datads',
  };

  return header;
}

Future<http.Response> post(String url,
    {Map<String, String>? headers, Object? body}) async {
  Logger logger = Logger();
  logger.i(body);

  var baseUrl = await getBaseUrl();
  try {
    var response = await http.Client()
        .post(Uri.parse(baseUrl! + url), headers: headers, body: body);
    return response;
  } on SocketException {
    SmartDialog.show(
        builder: (context) {
          return AlertDialog(
            title: Text("Masalah Jaringan"),
            content: Text("Please check your connection and try again."),
            actions: [
              TextButton(
                onPressed: () => SmartDialog.dismiss(),
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      throw Exception("Network Error");
  }
}

var ip;
var userId;
var sessionId;
var companyId;

Future<void> fetchUserSessionInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  ip = prefs.getString(LocalStorageConst.ip);
  userId = prefs.getString(LocalStorageConst.userId);
  sessionId = prefs.getString(LocalStorageConst.sessionLoginId);
  companyId = prefs.getString(LocalStorageConst.companyId);
}