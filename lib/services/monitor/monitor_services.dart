import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class MonitorServices {
  Future<String> getMonitor({
    String? fDateFrom,
    String? fDateTo,
    String? filterValue,
    String? format,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/report';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "R_01",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "FILTER_DATE_FROM": fDateFrom,
        "FILTER_DATE_TO": fDateTo,
        "FILTER_FIELD": "",
        "FILTER_VALUE": filterValue ?? '',
        "TRANSACTION_ID": "",
        "MODULE_ID": "POS",
        "SUBMODULE_ID": "ORDER",
        "SORT_ORDER_BY": "$format, SALES_DATE",
        "SORT_ORDER_TYPE": "DESC",
        "BULAN": "",
        "TAHUN": "",
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
