import 'package:xhalona_pos/models/dao/transaction.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/transaction/transaction_service.dart';

class TransactionRepository extends AppRepository {
  final TransactionService _transactionService = TransactionService();

  Future<List<TransactionHeaderDAO>> getTransactionHeader({
    int? pageNo,
    int? pageRow,
    String? filterField,
    String? filterValue,
  }) async {
    var result = await _transactionService.getTransactions(
      pageNo: pageNo,
      pageRow: pageRow,
      filterField: filterField,
      filterValue: filterValue   
    );

    List data = getResponseListData(result);
    return data.map((transactionHeader)=>TransactionHeaderDAO.fromJson(transactionHeader)).toList();
  }
}