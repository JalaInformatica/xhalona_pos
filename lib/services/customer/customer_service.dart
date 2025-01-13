import 'dart:convert';

import 'package:xhalona_pos/models/dto/requestFilter.dart';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class CustomerService {
  Future<String> getCustomers({
    required RequestGlobalFilters requestFilters,
    int? isSupplier
  }) async {
    api.fetchUserSessionInfo();
    var url = '/SALES/m_kustomer';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LIST_H",
        "IP": api.ip,
        "COMPANY_ID":  api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "FILTER_FIELD": requestFilters.filterField,
        "FILTER_VALUE": requestFilters.filterValue,
        "PAGE_NO": requestFilters.pageNo,
        "PAGE_ROW": requestFilters.pageRow,
        "SORT_ORDER_BY": "SUPPLIER_ID",
        "SORT_ORDER_TYPE": "DESC",
        "IS_SUPPLIER": isSupplier ?? 0
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
