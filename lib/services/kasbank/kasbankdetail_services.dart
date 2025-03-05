import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class KasBankDetailServices {
  Future<String> getKasBankDetail({
    String? vocherNo,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/t_kas_bank_detail';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LIST_D",
        "IP": api.ip,
        "DEF_COMPANY_ID": api.companyId,
        "DET_COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DET_SITE_ID": "",
        "DET_CURRENCY_ID": "RP",
        "DET_VOUCHER_NO": vocherNo ?? ""
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> addEditKasBankDetail({
    String? acId,
    String? voucerNo,
    String? qty,
    String? priceUnit,
    String? flagDk,
    String? uraianDet,
    String? rowId,
    String? actionId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/t_kas_bank_detail';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": actionId == '1' ? "EDIT_D" : "ADD_D",
        "IP": api.ip,
        "DET_COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DET_SITE_ID": "",
        "DET_CURRENCY_ID": "RP",
        "DATA": [
          {
            "ROW_ID": rowId,
            "DET_VOUCHER_NO": voucerNo,
            "ACCOUNT_ID": acId,
            "QTY": qty,
            "PRICE_UNIT": priceUnit,
            "URAIAN_DET": uraianDet,
            "FLAG_DK": flagDk
          }
        ]
      }
    });

    print('dept: $body');

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> deleteKasBankDetail({
    String? voucerNo,
    int? rowId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/t_kas_bank_detail';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "DELETE_D",
        "IP": api.ip,
        "DET_COMPANY_ID": api.companyId,
        "DET_SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {"DET_VOUCHER_NO": voucerNo, "ROW_ID": rowId}
        ]
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
