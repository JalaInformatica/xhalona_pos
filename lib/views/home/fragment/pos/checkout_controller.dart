import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/metodebayar.dart';
import 'package:xhalona_pos/models/dto/paymentTransaction.dart';
import 'package:xhalona_pos/repositories/crystal_report/transaction_crystal_report_repository.dart';
import 'package:xhalona_pos/repositories/metodebayar/metodebayar_repository.dart';
import 'package:xhalona_pos/repositories/transaction/transaction_repository.dart';

class CheckoutController extends GetxController{
  
  final TransactionRepository _transactionRepository = TransactionRepository();
  final MetodeBayarRepository _metodeBayarRepository = MetodeBayarRepository();
  var totalPaid = 0.obs;
  var tunai = 0.obs;
  var nonTunai1 = 0.obs;
  var nonTunai2 = 0.obs;
  var nonTunai3 = 0.obs;
  var komplimen = 0.obs;
  var hutang = 0.obs;
  var kembalian = 0.obs;
  var titipan = 0.obs;

  var metodeNonTunai1 = "".obs;
  var metodeNonTunai2 = "".obs;

  var paymentCardNonTunai1 = "".obs;
  var paymentCardNonTunai2 = "".obs;

  var metodeBayar = <MetodeBayarDAO>[].obs;

  Future<void> payment(PaymentTransactionDTO payment) async {
    _transactionRepository.paymentTransaction(payment);
  }

  Future<void> getMetodeBayar () async {
    metodeBayar.value = await _metodeBayarRepository.getMetodeBayar(payMethodeGroup: "NON TUNAI");
  }

  Future<String> printNota(String salesId) async {
    return await TransactionCrystalReportRepository()
        .printNota(salesId: salesId);
  }

  @override
  void onInit() {
    getMetodeBayar();
    super.onInit();
  }
}