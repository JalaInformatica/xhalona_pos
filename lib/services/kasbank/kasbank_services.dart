import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class KasBankServices {
  Future<String> getKasBank({
    int? pageNo,
    int? pageRow,
    String? filterValue,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/t_kas_bank';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LIST_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "FILTER_DAY": "",
        "FILTER_MONTH": "",
        "FILTER_YEAR": "",
        "FILTER_FIELD": "",
        "FILTER_VALUE": filterValue ?? '',
        "PAGE_NO": pageNo ?? 1,
        "PAGE_ROW": pageRow ?? 10,
        "SORT_ORDER_BY": "VOUCHER_DATE",
        "SORT_ORDER_TYPE": "DESC",
        "TRANSACTION_ID": "",
        "SITE_ID": "",
        "CURRENCY_ID": "RP",
        "SUBMODULE_ID": "",
        "AC_ID": "",
        "USER_AUTORITY": "1",
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> addEditKasBank({
    String? acId,
    String? refID,
    String? subModulId,
    String? vocherDate,
    String? vocherNo,
    String? ket,
    String? actionId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/t_kas_bank';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": actionId == '1' ? "EDIT_H" : "ADD_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "SITE_ID": "",
        "CURRENCY_ID": "RP",
        "SUBMODULE_ID": subModulId ?? "",
        "VOUCHER_NO": vocherNo ?? "",
        "VOUCHER_DATE": vocherDate ?? "",
        "AC_ID": acId ?? "",
        "REFFERENCE_ID": refID ?? "",
        "INVOICE_NO": "",
        "INVOICE_DATE": "",
        "KETERANGAN": ket ?? ""
      }
    });

    print('dept: $body');

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> deleteKasBank({
    String? voucherNo,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/t_kas_bank';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "DELETE_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {"VOUCHER_NO": voucherNo}
        ]
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> postingKasBank({
    String? voucherNo,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/t_kas_bank';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "POSTING",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "CURRENCY_ID": "RP",
        "VOUCHER_NO": voucherNo ?? ""
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> unpostingKasBank({
    String? voucherNo,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/t_kas_bank';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "UNPOSTING",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "CURRENCY_ID": "RP",
        "VOUCHER_NO": voucherNo ?? ""
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> printKasBank({
    String? voucherNo,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/lap_finance';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "PRINT_KASBANK",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "TEMPLATE": "Print_Kas_Bank",
        "VOUCHER_NO": voucherNo ?? ""
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
