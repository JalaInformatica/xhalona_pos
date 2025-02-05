import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class MetodeBayarServices {
  Future<String> getMetodeBayar({
    int? pageNo,
    int? pageRow,
    String? filterValue,
    String? payMethodeGroup,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_metode_bayar';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LIST_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "FILTER_COLOUMN": "",
        "FILTER_FIELD": "",
        "FILTER_VALUE": filterValue ?? '',
        "PAGE_NO": pageNo ?? 1,
        "PAGE_ROW": pageRow ?? 10,
        "SORT_ORDER_BY": "PAYMENT_METHOD_NAME",
        "SORT_ORDER_TYPE": "ASC",
        "PAYMENT_METHOD_GROUP": payMethodeGroup ?? "",
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> addEditMetodeBayar({
    String? payMethodeId,
    String? payMethodeGroup,
    String? payMethodeName,
    String? isCash,
    String? isCard,
    String? isDefault,
    String? isfixAmt,
    String? isbellowAmt,
    String? isActive,
    String? isPiutang,
    String? isnumberCard,
    String? actionId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_metode_bayar';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": actionId == '1' ? "EDIT_H" : "ADD_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        if (actionId == '1') "PAYMENT_METHOD_ID": payMethodeId,
        "PAYMENT_METHOD_NAME": payMethodeName,
        "PAYMENT_METHOD_GROUP": payMethodeGroup,
        "IS_CASH": isCash,
        "IS_CARD": isCard,
        "IS_DEFAULT": isDefault,
        "IS_FIX_AMT": isfixAmt,
        "IS_BELLOW_AMT": isbellowAmt,
        "IS_ACTIVE": isActive,
        "IS_PIUTANG": isPiutang ?? "",
        "IS_NUMBER_CARD": isnumberCard ?? ""
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> deleteMetodeBayar({
    String? payMethodeId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_metode_bayar';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "DELETE_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {"PAYMENT_METHOD_ID": payMethodeId}
        ]
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
