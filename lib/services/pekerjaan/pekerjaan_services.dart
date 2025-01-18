import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class PekerjaanServices {
  Future<String> getPekerjaan({
    int? pageNo,
    int? pageRow,
    String? filterValue,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_job_desc';
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
        "SORT_ORDER_BY": "JOB_DESC",
        "SORT_ORDER_TYPE": "ASC",
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> addEditPekerjaan({
    String? jobId,
    String? jobDesc,
    String? actionId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_job_desc';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": actionId == '1' ? "EDIT_H" : "ADD_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "JOB_DESC": jobDesc,
        "SORT_ORDER": "1",
        "IS_ACTIVE": "1",
        if (actionId == '1') "JOB_ID": jobId,
      }
    });

    print('dept: $body');

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> deletePekerjaan({
    String? jobId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_job_desc';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "DELETE_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {"JOB_ID": jobId}
        ]
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
