import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/core/constant/local_storage.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class UserService {
  Future<String> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = '/SYSMAN/profile';
    var body = jsonEncode({
      "rqMemberInfo": {
        "USER_ID": prefs.getString(LocalStorageConst.userId),
        "SESSION_LOGIN_ID": prefs.getString(LocalStorageConst.sessionLoginId),
      }
    });

    var response = await api.post(
      url,
      headers: await api.requestHeaders(),
      body: body,
    );

    return ResponseHandler.handle(response);
  }

  Future<String> uploadProfile(File file) async {
    api.fetchUserSessionInfo();
    Map<String, String> fields = ({
      "ACTION_ID": "UPLOAD_PROFILE",
      "IP": api.ip,
      "USER_ID": api.userId,
      "SESSION_LOGIN_ID": api.sessionId,
      "COMPANY_ID": "",
    });
    var response = await api.postFormData("/ASSET/media",
        headers: await api.requestHeaders(), fields: fields, files: [file]);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['FILE_NAME'];
    } else {
      throw Exception('Gagal Mendapatkan data pengguna');
    }
  }
}
