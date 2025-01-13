import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';

class ResponseHandler {
  static String handleError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return "Bad Request";
      case 401:
        return "Unauthorized";
      case 403:
        return "Invalid credentials";
      case 404:
        return "Not Found";
      case 408:
        return "Connection Timeout";
      case 500:
        return "Internal Server Error";
      default:
        return "Error occurred while communicating with server";
    }
  }

  static Future<String> handle(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Logger logger = Logger();
      logger.i(response.body);
      return response.body;
    } else {
      SmartDialog.show(
        animationType: SmartAnimationType.scale,
        builder: (context) {
          return AlertDialog(
            title: Icon(Icons.report_problem_outlined),
            content: Text(handleError(response)),
            actions: [
              TextButton(
                onPressed: () => SmartDialog.dismiss(),
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      throw Exception(handleError(response));
    }
  }
}
