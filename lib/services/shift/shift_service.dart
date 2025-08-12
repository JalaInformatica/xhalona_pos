import 'dart:convert';
import 'package:xhalona_pos/services/api_service.dart' as api;
import 'package:xhalona_pos/services/response_handler.dart';

class ShiftService {
  Future<String> getShifts({
    int? pageNo,
    int? pageRow,
    String? filterValue
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_shift';
    var body = jsonEncode({
      "rq":{ 
        "IP": api.ip,
        "DEF_COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "ACTION_ID": "LIST_H",
        "COMPANY_ID":api.companyId,
        "SITE_ID":"",
        "FILTER_FIELD":"",
        "FILTER_VALUE": filterValue ?? "",
        "PAGE_NO": pageNo ?? "1",
        "PAGE_ROW": pageRow ?? "10",
        "SORT_ORDER_BY":"SHIFT_ID_ACTIVE",
        "SORT_ORDER_TYPE":"DESC",
        "PART_ID":"",
        "IS_ACTIVE":"1"
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