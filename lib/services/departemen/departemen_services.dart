import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class DepartemenServices {
  Future<String> getDepartemen({
    int? pageNo,
    int? pageRow,
    String? filterValue,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_bagian';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LIST_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "FILTER_FIELD": "",
        "FILTER_VALUE": filterValue ?? '',
        "PAGE_NO": '$pageNo' ?? '1',
        "PAGE_ROW": '$pageRow ' ?? '10',
        "SORT_ORDER_BY": "NAMADEPARTMENT",
        "SORT_ORDER_TYPE": "ASC",
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> addEditDept({
    String? kdDept,
    String? nmDept,
    String? actionId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_bagian';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": actionId == '1' ? "EDIT_H" : "ADD_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "NAMADEPARTMENT": nmDept,
        "SORT_ORDER": "1",
        if (actionId == '1') "KD_DEPT": kdDept,
      }
    });

    print('dept: $body');

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> deleteDept({
    String? kdDept,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_bagian';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "DELETE_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {"KD_DEPT": kdDept}
        ]
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
