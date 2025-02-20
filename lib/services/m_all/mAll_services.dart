import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class MasAllServices {
  Future<String> getMasAll({
    int? pageNo,
    int? pageRow,
    String? filterValue,
    String? group,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_all';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LIST_H",
        "IP": api.ip,
        "COMPANY_ID": "All",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "FILTER_FIELD": "",
        "FILTER_VALUE": filterValue ?? '',
        "GROUP_MASTER_ID": group ?? 'UNIT_ID',
        "PAGE_NO": pageNo ?? 1,
        "PAGE_ROW": pageRow ?? 10,
        "SORT_ORDER_BY": "ROW_ID",
        "SORT_ORDER_TYPE": "DESC",
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> addEditMasAll({
    int? rowId,
    String? masId,
    String? masCategory,
    String? isActive,
    String? actionId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_all';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": actionId == '1' ? "EDIT_H" : "ADD_H",
        "IP": api.ip,
        "COMPANY_ID": "All",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "MASTER_ID": masId,
        "MASTER_DESC": masId,
        "GROUP_MASTER_ID": "UNIT_ID",
        "MASTER_CATEGORY": masCategory,
        "IS_ACTIVE": isActive,
        if (actionId == '1') "ROW_ID": rowId,
      }
    });

    print('dept: $body');

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> deleteMasAll({
    int? rowId,
    String? masId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_all';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "DELETE_H",
        "IP": api.ip,
        "COMPANY_ID": "All",
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {
            "ROW_ID": rowId,
            "MASTER_ID": masId,
          }
        ]
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
