import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class LapPenjualanCrystalReportService {
  Future<String> printLapPenjualan({
    String? template,
    String? dateFrom,
    String? dateTo,
    String? format,
    String? detail,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/lap_sales';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LAP_PENJUALAN",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "FILTER_DATE_FROM": dateFrom ?? "",
        "FILTER_DATE_TO": dateTo ?? "",
        "FILTER_FIELD": "",
        "FILTER_VALUE": "",
        "FILTER_CONDITION": "",
        "FORMAT": format ?? "PDF",
        "TEMPLATE": template ?? "",
        "DETAIL": detail ?? "",
        "GROUP_LEVEL_1": "",
        "GROUP_LEVEL_2": "",
        "GROUP_LEVEL_3": "",
        "GROUP_LEVEL_4": "",
        "GROUP_LEVEL_5": ""
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
