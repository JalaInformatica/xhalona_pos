import 'dart:convert';

import 'package:xhalona_pos/models/dto/employee.dart';
import 'package:xhalona_pos/models/dto/requestFilter.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;
import 'package:xhalona_pos/services/response_handler.dart';

class EmployeeService {
  Future<String> getEmployees({
    // RequestGlobalFilters requestFilters = const RequestGlobalFilters(),
    int? pageNo,
    int? pageRow,
    String? filterField,
    String? filterValue,
    EmployeeSortBy? sortBy,
    String? requestSortType,
    String? siteId,
    int? isActive,
  }) async {
    api.fetchUserSessionInfo();
    var url = '/SALES/m_employee_pos';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LIST_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": siteId ?? "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "FILTER_FIELD": filterField ?? "",
        "FILTER_VALUE": filterValue ?? "",
        "PAGE_NO": pageNo ?? 1,
        "PAGE_ROW": pageRow ?? 10,
        "SORT_ORDER_BY": EmployeeDTO.sortBy[sortBy ?? EmployeeSortBy.empId],
        "SORT_ORDER_TYPE": requestSortType ?? RequestGlobalSortType.descending,
        "IS_ACTIVE": isActive ?? 1
      }
    });
    var response = await api.post(
      url,
      headers: await api.requestHeaders(),
      body: body
    );

    return ResponseHandler.handle(response);
  }
}
