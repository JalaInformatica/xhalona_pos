import 'dart:convert';
import 'package:xhalona_pos/services/api_service.dart' as api;
import 'package:xhalona_pos/services/response_handler.dart';

class TransactionService {
  Future<String> getTransactions({
    int? pageNo,
    int? pageRow,
    String? filterField,
    String? filterValue,
    int? filterDay,
    int? filterMonth,
    int? filterYear,
    String? transactionId,
    String? statusId,
    String? statusCategory,
    String? sourceId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/order';
    var body = jsonEncode({
      "rq":{
        "IP":api.ip,
        "DEF_COMPANY_ID":api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "ACTION_ID": "LIST_H",
        "COMPANY_ID": api.companyId,
        "FILTER_DAY": filterDay ?? "",
        "FILTER_MONTH": filterMonth ?? "",
        "FILTER_YEAR": filterYear ?? "",
        "FILTER_FIELD": filterField ?? "",
        "FILTER_VALUE": filterValue ?? "",
        "PAGE_NO": pageNo ?? "1",
        "PAGE_ROW": pageRow ?? "10",
        "SORT_ORDER_BY": "SALES_ID",
        "SORT_ORDER_TYPE":"DESC",
        "TRANSACTION_ID": transactionId ?? "",
        "STATUS_ID": statusId ?? "",
        "SOURCE_ID": sourceId ?? "",
        "STATUS_CATEGORY": statusCategory ?? ""
        }});
    var response = await api.post(
      url,
      headers: await api.requestHeaders(),
      body: body
    );

    return ResponseHandler.handle(response);
  }
}