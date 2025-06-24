import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xhalona_pos/core/constant/local_storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

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
    Logger().i(response.body);
    return response;
  } on SocketException {
    return await showRetryDialog(url, headers: headers, body: body);
  }
}

Future<http.Response> showRetryDialog(String url,
    {Map<String, String>? headers, Object? body}) async {
  // Completer to control when the retry finishes
  final completer = Completer<http.Response>();

  await SmartDialog.show(
    builder: (context) {
      return AppDialog(
        title: Text("Masalah Jaringan"),
        content: const Text("Please check your connection and try again."),
        actions: [
          TextButton(
            onPressed: () async {
              SmartDialog.dismiss(); // Close the dialog
              try {
                var retryResponse =
                    await post(url, headers: headers, body: body);
                completer
                    .complete(retryResponse); // Complete with retry response
              } catch (e) {
                completer
                    .completeError(e); // Complete with error if retry fails
              }
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );

  return completer.future; // Wait for the retry result
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
  if(ip == null || userId == null || sessionId == null || companyId == null){
    throw Exception("login");
  }
}

Future<http.Response> postFormData(String url,
    {Map<String, String>? headers,
    Map<String, String>? fields,
    List<File>? files}) async {
  Logger logger = Logger();
  var baseUrl = await getBaseUrl();
  var request = http.MultipartRequest('POST', Uri.parse(baseUrl! + url));

  if (headers != null) {
    request.headers.addAll(headers);
  }

  if (fields != null) {
    request.fields.addAll(fields);
  }

  if (files != null) {
    for (var file in files) {
      request.files
          .add(await http.MultipartFile.fromPath('FILE_UPLOAD[]', file.path));
    }
  }

  var streamedResponse = await request.send();

  var response = await http.Response.fromStream(streamedResponse);

  logger.i(response.body);

  return response;
}
