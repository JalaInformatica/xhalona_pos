import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/transaction.dart';
import 'package:xhalona_pos/repositories/transaction/transaction_repository.dart';

class TransactionController extends GetxController{
  TransactionRepository _transactionRepository = TransactionRepository();

  var transactionHeader = <TransactionHeaderDAO>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      isLoading.value = true;
      final result = await _transactionRepository.getTransactionHeader(

      );
      transactionHeader.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}