import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class PaketServices {
  Future<String> getPaket({
    int? pageNo,
    int? pageRow,
    String? filterValue,
    String? filterPartId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_produk_paket';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LIST_C",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "FILTER_FIELD": "",
        "FILTER_VALUE": filterValue ?? '',
        "PAGE_NO": pageNo ?? 1,
        "PAGE_ROW": pageRow ?? 10,
        "SORT_ORDER_BY": "PART_ID",
        "SORT_ORDER_TYPE": "DESC",
        "PART_ID": filterPartId,
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> addEditPaket({
    String? rowId,
    String? partId,
    String? comPartId,
    String? comValue,
    String? comUnitPrice,
    String? actionId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_produk_paket';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": actionId == '1' ? "EDIT_H" : "ADD_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "ROW_ID": rowId,
        "PART_ID": partId,
        "COMPONENT_PART_ID": comPartId,
        "COMPONENT_VALUE": comValue,
        "COMPONENT_UNIT_PRICE": comUnitPrice
      }
    });

    print('dept: $body');

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> deletePaket({
    String? rowId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_produk_paket';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "DELETE_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {"ROW_ID": rowId}
        ]
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
