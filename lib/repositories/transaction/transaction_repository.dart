import 'package:xhalona_pos/models/dao/transaction.dart';
import 'package:xhalona_pos/models/dto/transaction.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/transaction/transaction_service.dart';

class TransactionRepository extends AppRepository {
  final TransactionService _transactionService = TransactionService();

  Future<List<TransactionHeaderDAO>> getTransactionHeader({
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
      transactionId: transactionId
    );

    List data = getResponseListData(result);
    return data.map((transactionHeader)=>TransactionHeaderDAO.fromJson(transactionHeader)).toList();
  }

  Future<String> addTransactionHeader(TransactionDTO transaction) async {
    var result = await _transactionService.addTransaction(transaction);
    return getResponseTrxData(result)[0]["NO_TRX"];
  }

  Future<List<TransactionDetailDAO>> getTransactionDetail({required String transactionId}) async {
    var result = await _transactionService.getTransactionDetail(transactionId: transactionId);
    List data = getResponseListData(result);
    return data.map((transactionDetail)=>TransactionDetailDAO.fromJson(transactionDetail)).toList();
  }

  Future<void> addTransactionDetail(List<TransactionDetailDTO> transaction) async {
    var result = await _transactionService.addDetailTransaction(transaction);
    getResponseTrxData(result);
  }

  Future<void> deleteTransactionDetail({required String salesId, required String rowId}) async {
    var result = await _transactionService.deleteTransactionDetail(salesId, rowId);
    getResponseTrxData(result);
  }
  
  Future<void> editEmployeeTransactionDetail({required String salesId, required String rowId, required String employeeId}) async {
    var result = await _transactionService.editEmployeeTransactionDetail(salesId, rowId, employeeId);
    getResponseTrxData(result);
  }

}