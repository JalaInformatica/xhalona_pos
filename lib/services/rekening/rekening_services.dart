import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class RekeningServices {
  Future<String> getRekening({
    int? pageNo,
    int? pageRow,
    String? filterValue,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_akun_bank';
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
        "SORT_ORDER_BY": "AC_ID",
        "SORT_ORDER_TYPE": "ASC",
        "SITE_ID": "",
        "IS_SHOW_POS": "",
        "IS_CASH": "",
        "IS_INSURANCE": "",
        "IS_DEBET": "",
        "IS_OTHER": "1",
        "IS_SHOW_FINANCE": "1",
        "JENIS_AC": "",
        "USER_AUTORITY": "1",
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> addEditRekening({
    String? acId,
    String? jenisAc,
    String? namaAc,
    String? acNoReff,
    String? acGL,
    String? acGroupId,
    String? nCodeIn,
    String? nCodeOut,
    String? bankName,
    String? bankAcName,
    String? acsUserId,
    String? isActive,
    String? actionId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_akun_bank';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": actionId == '1' ? "EDIT_H" : "ADD_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "SITE_ID": "",
        "AC_CURRENCY_ID": "RP",
        "JENIS_AC": jenisAc,
        "AC_ID": acId,
        "NAMA_AC": namaAc,
        "AC_NO_REFF": acNoReff,
        "ACCOUNT_GL": acGL,
        "AC_GROUP_ID": acGroupId,
        "NUMBERING_CODE_IN": nCodeIn,
        "NUMBERING_CODE_OUT": nCodeOut,
        "BANK_NAME": bankName,
        "BANK_ACCOUNT_NAME": bankAcName,
        "ACCESS_TO_USER_ID": acsUserId,
        "ISACTIVE": isActive ?? 1
      }
    });

    print('dept: $body');

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> deleteRekening({
    String? acId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_akun_bank';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "DELETE_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {"AC_ID": acId}
        ]
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
