import 'package:get/get.dart';
import 'package:xhalona_pos/models/dto/paymentTransaction.dart';
import 'package:xhalona_pos/repositories/transaction/transaction_repository.dart';

class CheckoutController extends GetxController{
  
  final TransactionRepository _transactionRepository = TransactionRepository();

  var totalPaid = 0.obs;
  var tunai = 0.obs;
  var nonTunai1 = 0.obs;
  var nonTunai2 = 0.obs;
  var nonTunai3 = 0.obs;
  var komplimen = 0.obs;
  var hutang = 0.obs;
  var kembalian = 0.obs;
  var titipan = 0.obs;

  Future<void> payment(PaymentTransactionDTO payment) async {
    _transactionRepository.paymentTransaction(payment);
  }
}