import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class KaryawanServices {
  Future<String> getKaryawan({
    int? pageNo,
    int? pageRow,
    String? isActive,
    String? filterValue,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_employee_pos';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LIST_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "FILTER_FIELD": "",
        "FILTER_VALUE": filterValue ?? '',
        "PAGE_NO": pageNo ?? 1,
        "PAGE_ROW": pageRow ?? 10,
        "SORT_ORDER_BY": "EMP_ID",
        "SORT_ORDER_TYPE": "DESC",
        "IS_ACTIVE": isActive ?? "",
      }
    });

    print('object: $body');
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
