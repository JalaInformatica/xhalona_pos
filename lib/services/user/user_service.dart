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

  Future<String> changePasswordProfile(
      {String? password1, String? password2}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = '/SYSMAN/user';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "RESET_PASSWORD",
        "IP": api.ip,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "MEMBER_ID": prefs.getString(LocalStorageConst.userName),
        "PASSWORD": password1,
        "PASSWORD2": password2
      }
    });

    var response = await api.post(
      url,
      headers: await api.requestHeaders(),
      body: body,
    );

    return ResponseHandler.handle(response);
  }

  Future<String> logoutProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = '/SYSMAN/login';
    var body = jsonEncode({
      "RESET_PASSWORD": {
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

  Future<String> settings({String? nota}) async {
    var url = '/SALES/m_setting';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "EDIT_H",
        "IP": api.ip,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "COMPANY_ID": api.companyId,
        "DEF_COMPANY_ID": api.companyId,
        "SETTING_TYPE": "REPORT",
        "SETTING_ID": "NOTA_PAPER_TEMPLATE",
        "SETTING_VALUE_1": "Print_Nota_$nota",
        "SETTING_VALUE_2": "",
        "SETTING_VALUE_3": "",
        "SETTING_VALUE_4": "",
        "SETTING_VALUE_5": "",
        "SETTING_VALUE_6": "",
        "SETTING_VALUE_7": "",
        "SETTING_VALUE_8": "",
        "GROUP_ANALISA_ID": "",
        "NOTES": "Setting ukuran kertas print nota",
        "IS_ACTIVE": "1"
      }
    });

    var response = await api.post(
      url,
      headers: await api.requestHeaders(),
      body: body,
    );

    return ResponseHandler.handle(response);
  }
}
