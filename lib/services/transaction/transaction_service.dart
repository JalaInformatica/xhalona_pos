import 'dart:convert';
import 'package:xhalona_pos/models/dto/transaction.dart';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;
import 'package:xhalona_pos/models/dto/paymentTransaction.dart';

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
      "rq": {
        "IP": api.ip,
        "DEF_COMPANY_ID": api.companyId,
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
        "SORT_ORDER_TYPE": "DESC",
        "TRANSACTION_ID": transactionId ?? "",
        "STATUS_ID": statusId ?? "",
        "SOURCE_ID": sourceId ?? "",
        "STATUS_CATEGORY": statusCategory ?? ""
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> addTransaction(TransactionDTO transaction) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/order';
    var body = jsonEncode({
      "rq": {
        "IP": "103.78.114.49",
        "DEF_COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "ACTION_ID": "ADD_H",
        "COMPANY_ID": api.companyId,
        ...transaction.toJson()
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> editTransaction(TransactionDTO transaction) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/order';
    var body = jsonEncode({
      "rq": {
        "IP": "103.78.114.49",
        "DEF_COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "ACTION_ID": "EDIT_H",
        "COMPANY_ID": api.companyId,
        ...transaction.toJson()
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
  
  Future<String> editTransactionDetail(TransactionDetailDTO transactionDetail) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/order_detail';
    var body = jsonEncode({
      "rq": {
        "IP": "103.78.114.49",
        "DEF_COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "ACTION_ID": "EDIT_D",
        "COMPANY_ID": api.companyId,
        "DATA": [
          transactionDetail.toJson()
        ]
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  // Future<String> editDeductionValTransactionDetail({
  //     required String salesId,
  //     required String rowId,
  //     required int deductionVal
  //   }) async {
  //   await api.fetchUserSessionInfo();
  //   var url = '/SALES/order';
  //   var body = jsonEncode({
  //     "rq": {
  //       "IP": "103.78.114.49",
  //       "DEF_COMPANY_ID": api.companyId,
  //       "USER_ID": api.userId,
  //       "SESSION_LOGIN_ID": api.sessionId,
  //       "ACTION_ID": "EDIT_H",
  //       "COMPANY_ID": api.companyId,
  //     }
  //   });
  //   var response =
  //       await api.post(url, headers: await api.requestHeaders(), body: body);

  //   return ResponseHandler.handle(response);
  // }

  Future<String> deleteTransaction(String salesId) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/order';
    var body = jsonEncode({
      "rq": {
        "IP": "103.78.114.49",
        "DEF_COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "ACTION_ID": "DELETE_H",
        "COMPANY_ID": api.companyId,
        "DATA": [
          {
            "SALES_ID": salesId
          }
        ]
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> statusTransactions({
    int? pageNo,
    int? pageRow,
    String? filterField,
    String? filterValue,
    int? filterDay,
    int? filterMonth,
    int? filterYear,
    String? statusId,
    String? statusCategory,
    String? sourceId,
    String? statusClosed
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/order';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LIST_H_STATUS",
        "IP": api.ip,
        "DEF_COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "COMPANY_ID": api.companyId,
        "FILTER_DAY": filterDay ?? "",
        "FILTER_MONTH": filterMonth ?? "",
        "FILTER_YEAR": filterYear ?? "",
        "FILTER_FIELD": filterField ?? "",
        "FILTER_VALUE": filterValue ?? "",
        "PAGE_NO": pageNo ?? "1",
        "PAGE_ROW": pageRow ?? "10",
        "SORT_ORDER_BY": "STATUS_ID",
        "SORT_ORDER_TYPE": "DESC",
        "STATUS_ID": statusId ?? "",
        "SOURCE_ID": sourceId ?? "",
        "STATUS_CATEGORY": statusCategory ?? "",
        "STATUS_CLOSED": statusClosed ?? ""
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> paymentTransaction(PaymentTransactionDTO payment) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/order';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "PAYMENT",
        "IP": api.ip,
        "DEF_COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "COMPANY_ID": api.companyId,
        ...payment.toJson()
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> getTransactionDetail({required String transactionId}) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/order_detail';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LIST_D",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "SALES_ID": transactionId
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> addDetailTransaction(
      List<TransactionDetailDTO> transactionDetails) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/order_detail';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "ADD_D",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": transactionDetails
            .map((transactionDetail) => transactionDetail.toJson())
            .toList()
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);
    return ResponseHandler.handle(response);
  }

  Future<String> deleteTransactionDetail(String salesId, String rowId) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/order_detail';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "DELETE_D",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {
            "SALES_ID": salesId,
            "ROW_ID": rowId
          }
        ]
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);
    return ResponseHandler.handle(response);
  }

  Future<String> editEmployeeTransactionDetail(String salesId, String rowId, String employeeId) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/order_detail';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "EDIT_D_EMPLOYEE",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {
            "SALES_ID": salesId,
            "ROW_ID": rowId,
            "EMPLOYEE_ID": employeeId,
          }
        ]
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);
    return ResponseHandler.handle(response);
  }

  Future<String> onTransaction({String? actionId,String? salesId, String? statusDesc}) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/order';
    var body = jsonEncode({
      "rq": {
        "IP": "103.78.114.49",
        "DEF_COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "ACTION_ID": actionId,
        "COMPANY_ID": api.companyId,
        "SALES_ID": salesId,
       if(actionId != 'ONCONFIRM' || actionId != 'ONWORKING' || actionId != 'ONFINISH_STORE') "STATUS_DESC": statusDesc
      }
    });
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

}
