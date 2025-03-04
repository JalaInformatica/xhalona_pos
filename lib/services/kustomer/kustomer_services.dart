import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class KustomerServices {
  Future<String> getKustomer({
    int? pageNo,
    int? pageRow,
    String? filterValue,
    String? isSuplier,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_kustomer';
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
        "SORT_ORDER_BY": "SUPPLIER_ID",
        "SORT_ORDER_TYPE": "ASC",
        "IS_SUPPLIER": isSuplier ?? ""
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> addEditKustomer({
    String? suplierId,
    String? suplierName,
    String? adress1,
    String? adress2,
    String? telp,
    String? emailAdress,
    String? isPayable,
    String? isCompliment,
    String? isSuplier,
    String? actionId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_kustomer';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": actionId == '1' ? "EDIT_H" : "ADD_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "SUPPLIER_ID": suplierId,
        "SUPPLIER_NAME": suplierName,
        "ADDRESS1": adress1,
        "ADDRESS2": adress2,
        "TELP": telp,
        "EMAIL_ADDRESS": emailAdress,
        "IS_PAYABLE": isPayable,
        "IS_COMPLIMENT": isCompliment,
        "IS_SUPPLIER": isSuplier
      }
    });

    print('dept: $body');

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> deleteKustomer({
    String? suplierId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_kustomer';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "DELETE_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {"SUPPLIER_ID": suplierId}
        ]
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
