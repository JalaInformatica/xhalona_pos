import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class TransactionCrystalReportService {
  Future<String> printNota({
    required String salesId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/lap_sales';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "PRINT_NOTA",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "FORMAT": "PDF",
        "TEMPLATE": "Print_Nota",
        "SALES_ID": salesId
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    print(response.body);

    return ResponseHandler.handle(response);
  }
}
