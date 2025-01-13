import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:xhalona_pos/core/constant/local_storage.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;
import 'package:xhalona_pos/services/response_handler.dart';

class UserService {
  Future<String> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = '/SYSMAN/profile';
    var body = jsonEncode({
      "rqMemberInfo": {
        "USER_ID": prefs.getString(LocalStorageConst.userId),
        "SESSION_LOGIN_ID": prefs.getString(LocalStorageConst.sessionLoginId),
        }}
    );

    var response = await api.post(
      url,
      headers: await api.requestHeaders(),
      body: body,
    );

    return ResponseHandler.handle(response);
  }
}