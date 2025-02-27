import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class PenggunaServices {
  Future<String> getPengguna({
    int? pageNo,
    int? pageRow,
    String? filterValue,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SYSMAN/user';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LIST_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "FILTER_FIELD": "",
        "FILTER_VALUE": filterValue ?? '',
        "PAGE_NO": pageNo ?? 1,
        "PAGE_ROW": pageRow ?? 10,
        "SORT_ORDER_BY": "USER_ID",
        "SORT_ORDER_TYPE": "DESC",
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> addEditPengguna({
    String? password,
    String? memberId,
    String? roleId,
    String? deptId,
    String? levelId,
    String? email,
    String? isActive,
    String? actionId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SYSMAN/user';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": actionId == '1' ? "EDIT_H" : "ADD_H",
        "IP": api.ip,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "R_ID": "USER",
        "MEMBER_ID": memberId,
        "USERNAME": memberId,
        "PASSWORD": password,
        "DEF_COMPANY_ID": '${api.companyId}',
        "EMAILADDRESS": email,
        "LEVELID": 20,
        "DEPARTMENTID": deptId,
        "EMP_ID": "",
        "ROLE_ID": roleId,
        "IS_ACTIVE": isActive,
        if (actionId == '0') "APP_ID": "SALON",
      }
    });

    print('dept: $body');

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> deletePengguna({
    String? memberId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SYSMAN/user';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "DELETE_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {"MEMBER_ID": memberId}
        ]
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
