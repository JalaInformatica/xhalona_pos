import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/crystal_report/lap_penjualan_services.dart';

class LapPenjualanCrystalReportRepository extends AppRepository {
  LapPenjualanCrystalReportService _transactionCrystalReportService =
      LapPenjualanCrystalReportService();
  Future<String> printLapPenjualan({
    String? template,
    String? dateFrom,
    String? dateTo,
    String? format,
    String? detail,
  }) async {
    var result = await _transactionCrystalReportService.printLapPenjualan(
      template: template,
      dateFrom: dateFrom,
      dateTo: dateTo,
      format: format,
      detail: detail,
    );
    String url = getResponseURLData(result);
    return url;
  }
}
