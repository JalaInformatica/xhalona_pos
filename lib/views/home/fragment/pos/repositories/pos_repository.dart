import 'package:xhalona_pos/models/dao/transaction.dart';
import 'package:xhalona_pos/models/dto/transaction.dart';
import 'package:xhalona_pos/repositories/transaction/transaction_repository.dart';

class PosRepository {
  final TransactionRepository _transactionRepository = TransactionRepository();

  Future<List<TransactionHeaderDAO>> getTodayTransactionHeader({
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

  Future<String> createTransactionHeader() async {
    TransactionDTO transaction = TransactionDTO();
    return await _transactionRepository.addTransactionHeader(
      transaction
    );
  }
}