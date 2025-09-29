import 'dart:convert';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_widgets/core/models/response/response_model.dart';
import 'package:xhalona_pos/models/response/response.dart';
import 'package:xhalona_pos/globals/transaction/models/transaction_response.dart';
import 'package:xhalona_pos/models/dto/transaction.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/models/dto/paymentTransaction.dart';
import 'package:xhalona_pos/repositories/xhalona_repository.dart';
import 'package:xhalona_pos/globals/transaction/services/transaction_service.dart';

class TransactionRepository extends XhalonaRepository {
  final TransactionService _transactionService = TransactionService();
    
  Future<ResponseModelPaginated<TransactionResponse>> getTransactionHeader({
    int? pageNo,
    int? pageRow,
    String? filterField,
    String? filterValue,
    int? filterDay,
    int? filterMonth,
    int? filterYear,
    String? statusCategory,
    String? sourceId,
    String? transactionId,
  }) async {
    var result = await _transactionService.getTransactions(
        pageNo: pageNo,
        pageRow: pageRow,
        filterField: filterField,
        filterValue: filterValue,
        filterDay: filterDay,
        filterMonth: filterMonth,
        filterYear: filterYear,
        statusCategory: statusCategory,
        sourceId: sourceId,
        transactionId: transactionId);

    return getResponsePaginatedData<TransactionResponse>(
      result,
      formatter: (data)=>data.map((orderHeader)=>TransactionResponse.fromJson(orderHeader)).toList()
    );
  }

  Future<ResponseModel<String>> addTransactionHeader(TransactionDTO transaction) async {
    var result = await _transactionService.addTransaction(transaction);
    return getResponseSingleData<String>(
      result, 
      formatter: (val)=>(val['NO_TRX'] ?? '')
    );
  }

  Future<ResponseModel<String>> editTransactionHeader(TransactionDTO transaction) async {
    var result = await _transactionService.editTransaction(transaction);
    return getResponseSingleData<String>(
      result, 
      formatter: (val)=>(val['NO_TRX'] ?? '')
    );
  }

  Future<ResponseModel<String>> deleteTransactionHeader(String salesId) async {
    var result = await _transactionService.deleteTransaction(salesId);
    return getResponseSingleData<String>(
      result, 
      formatter: (val)=>(val['NO_TRX'] ?? '')
    );
  }

  Future<ResponseModelPaginated<TransactionStatusResponse>> statusTransaction(
      {int? pageNo,
      int? pageRow,
      String? filterField,
      String? filterValue,
      int? filterDay,
      int? filterMonth,
      int? filterYear,
      String? statusId,
      String? statusCategory,
      String? sourceId,
      String? statusClosed}) async {
    var result = await _transactionService.statusTransactions(
        pageNo: pageNo,
        pageRow: pageRow,
        filterField: filterField,
        filterValue: filterValue,
        filterDay: filterDay,
        filterMonth: filterMonth,
        filterYear: filterYear,
        statusId: statusId,
        statusCategory: statusCategory,
        sourceId: sourceId,
        statusClosed: statusClosed);
    return getResponsePaginatedData<TransactionStatusResponse>(
      result,
      formatter: (data)=>data.map((store)=>TransactionStatusResponse.fromJson(store)).toList()
    );
  }

  Future<ResponseModel<String>> paymentTransaction(PaymentTransactionDTO payment) async {
    var result = await _transactionService.paymentTransaction(payment);
    return getResponseSingleData<String>(
      result, 
      formatter: (val)=>(val['NO_TRX'] ?? '')
    );
  }

  Future<ResponseModelPaginated<TransactionDetailResponse>> getTransactionDetail({
    required String transactionId}) async {
    var result = await _transactionService.getTransactionDetail(
        transactionId: transactionId);
    return getResponsePaginatedData<TransactionDetailResponse>(
      result,
      formatter: (data)=>data.map((orderHeader)=>TransactionDetailResponse.fromJson(orderHeader)).toList()
    );
  }

  Future<ResponseModel<String>> addTransactionDetail(List<TransactionDetailDTO> transaction) async {
    var result = await _transactionService.addDetailTransaction(transaction);
    return getResponseSingleData<String>(
      result, 
      formatter: (val)=>(val['NO_TRX'] ?? '')
    );
  }

  Future<ResponseModel<String>> editTransactionDetail(TransactionDetailDTO transaction) async {
    var result = await _transactionService.editTransactionDetail(transaction);
    return getResponseSingleData<String>(
      result, 
      formatter: (val)=>(val['NO_TRX'] ?? '')
    );
  }

  Future<ResponseModel<String>> deleteTransactionDetail({
    required String salesId, required String rowId}) async {
    var result =
        await _transactionService.deleteTransactionDetail(salesId, rowId);
    return getResponseSingleData<String>(
      result, 
      formatter: (val)=>(val['NO_TRX'] ?? '')
    );
  }

  Future<ResponseModel<String>> editEmployeeTransactionDetail(
      {required String salesId,
      required String rowId,
      required String employeeId}) async {
    var result = await _transactionService.editEmployeeTransactionDetail(
        salesId, rowId, employeeId);
    return getResponseSingleData<String>(
      result, 
      formatter: (val)=>(val['NO_TRX'] ?? '')
    );
  }

  // Future<String> ubahEmployeeTerapis(
  //     {required String salesId,
  //     required String rowId,
  //     required List<Map<String, dynamic>> trxDetailControllers}) async {
  //   var result = await _transactionService.ubahEmployeeTerapis(
  //       salesId, rowId, trxDetailControllers);
  //   return getResponseTrxData(result).first['NO_TRX'];
  // }

  // Future<String> ubahBomTerapis(
  //     {required List<Map<String, dynamic>> trxDetailControllers}) async {
  //   var result = await _transactionService.ubahBomTerapis(trxDetailControllers);
  //   return getResponseTrxData(result).first['NO_TRX'];
  // }

  // Future<String> onTransactionHeader(
  //     {String? actionId, String? salesId, String? statusDesc}) async {
  //   var result = await _transactionService.onTransaction(
  //     actionId: actionId,
  //     salesId: salesId,
  //     statusDesc: statusDesc,
  //   );
  //   return getResponseTrxData(result).first["NO_TRX"];
  // }
}
