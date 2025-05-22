import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class ReportServices {
  Future<String> getSummary({
    String? fDay,
    String? fMonth,
    String? filterValue,
    String? fYear,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/order';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LIST_H_STATUS",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "FILTER_DAY": fDay ?? '',
        "FILTER_MONTH": fMonth ?? '',
        "FILTER_YEAR": fYear ?? '',
        "FILTER_FIELD": "",
        "FILTER_VALUE": filterValue ?? '',
        "PAGE_NO": "1",
        "PAGE_ROW": '10',
        "SORT_ORDER_BY": "STATUS_ID",
        "SORT_ORDER_TYPE": "DESC",
        "STATUS_ID": "OFF10",
        "SOURCE_ID": "",
        "STATUS_CATEGORY": "FINISH",
        "STATUS_CLOSED": "",
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> getReport({
    required String actionId,
    String? startDate,
    String? endDate,
    int? bulan,
    int? tahun,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/report';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": actionId,
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "DEF_COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SITE_ID": "",
        "SESSION_LOGIN_ID": api.sessionId,
        "FILTER_DATE_FROM": startDate ?? '',
        "FILTER_DATE_TO": endDate ?? '',
        "FILTER_FIELD": "",
        "FILTER_VALUE": '',
        "TRANSACTION_ID": "",
        "MODULE_ID": "POS",
        "SUBMODULE_ID": "ORDER",
        "SORT_ORDER_BY": "SALES_DATE",
        "SORT_ORDER_TYPE": "ASC",
        "BULAN": bulan ?? "",
        "TAHUN": tahun ?? "",
      }
    });
    var response = await api.post(
      url,
      headers: await api.requestHeaders(),
      body: body,
    );

    return ResponseHandler.handle(response);
  }
}
