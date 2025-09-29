import 'dart:convert';

import 'package:xhalona_pos/services/app_service.dart';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class DashboardService {
  Future<dynamic> getTransactionSummary({
    int? day, int? month, int? year
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_report';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "R_TRANSACTION",
        "IP": api.ip,
        "DEF_COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "BULAN": month ?? '',
        "TAHUN": year ?? '',
        "HARI": day ?? ''
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
