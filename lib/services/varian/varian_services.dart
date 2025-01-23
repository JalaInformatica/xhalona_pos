import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class VarianServices {
  Future<String> getVarian({
    int? pageNo,
    int? pageRow,
    String? filterValue,
    String? varGroupId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_varian';
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
        "SORT_ORDER_BY": "VARIAN_ID",
        "SORT_ORDER_TYPE": "DESC",
        "VARIAN_NAME": "",
        "VARIAN_GROUP_ID": varGroupId,
        "IS_ACTIVE": "1",
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> addEditVarian({
    String? varId,
    String? varName,
    String? varGroupId,
    String? actionId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_varian';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": actionId == '1' ? "EDIT_H" : "ADD_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "VARIAN_ID": varId ?? '',
        "VARIAN_NAME": varName,
        "VARIAN_GROUP_ID": varGroupId,
        "IS_ACTIVE": "1",
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> deleteVarian({
    String? varGroupId,
    String? varId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_varian';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "DELETE_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {"VARIAN_GROUP_ID": varGroupId, "VARIAN_ID": varId}
        ]
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
