import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/crystal_report/transaction_crystal_report_service.dart';

class TransactionCrystalReportRepository extends AppRepository{
  TransactionCrystalReportService _transactionCrystalReportService = TransactionCrystalReportService();
  Future<String> printNota({
    required String salesId,
  }) async {
    var result = await _transactionCrystalReportService.printNota(salesId: salesId);
    String url = getResponseURLData(result);
    return url;
  }
}