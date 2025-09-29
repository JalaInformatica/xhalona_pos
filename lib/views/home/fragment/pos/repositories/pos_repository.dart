import 'package:flutter_widgets/core/models/response/response_model.dart';
import 'package:xhalona_pos/globals/transaction/models/transaction_response.dart';
import 'package:xhalona_pos/models/dto/transaction.dart';
import 'package:xhalona_pos/globals/transaction/repositories/transaction_repository.dart';

class PosRepository {
  final TransactionRepository _transactionRepository = TransactionRepository();

  Future<ResponseModelPaginated<TransactionResponse>> getTodayTransactionHeader({
    int? pageNo,
    int? pageRow,
    String? filterValue,
    String? statusCategory
  }){
    DateTime now = DateTime.now();
    return _transactionRepository.getTransactionHeader(
      pageNo: pageNo,
      pageRow: pageRow,
      filterValue: filterValue,
      filterDay: now.day,
      filterMonth: now.month,
      filterYear: now.year,
      statusCategory: statusCategory
    );
  }

  Future<ResponseModel<String>> createTransactionHeader() async {
    TransactionDTO transaction = TransactionDTO();
    return await _transactionRepository.addTransactionHeader(
      transaction
    );
  }
}