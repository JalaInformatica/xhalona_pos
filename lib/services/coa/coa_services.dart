import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class CoaServices {
  Future<String> getCoa({
    int? pageNo,
    int? pageRow,
    String? filterValue,
    String? acId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_coa';
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
        "SORT_ORDER_BY": "ACCOUNT_ID",
        "SORT_ORDER_TYPE": "ASC",
        "ACCOUNT_ID": acId
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> addEditCoa({
    String? pAccId,
    String? accId,
    String? namaRek,
    String? jenisRek,
    String? flagDk,
    String? flagTm,
    String? isActive,
    String? actionId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_coa';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": actionId == '1' ? "EDIT_H" : "ADD_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "SITE_ID": "",
        "PARENT_ACCOUNT_ID": pAccId,
        "ACCOUNT_ID": accId,
        "NAMA_REKENING": namaRek,
        "JENIS_REKENING": jenisRek,
        "FLAG_DK": flagDk,
        "FLAG_TM": flagTm,
        "ISACTIVE": isActive
      }
    });

    print('dept: $body');

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> deleteCoa({
    String? accId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_coa';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "DELETE_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {"ACCOUNT_ID": accId}
        ]
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
