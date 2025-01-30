import 'package:get/get.dart';
import 'package:xhalona_pos/repositories/crystal_report/lap_penjualan_repository.dart';

class LapPenjualanController extends GetxController {
  LapPenjualanCrystalReportRepository _lappenjualanRepository =
      LapPenjualanCrystalReportRepository();

  Future<String> printLapPenjualan(
    String? template,
    String? dateFrom,
    String? dateTo,
    String? format,
    String? detail,
  ) async {
    return await LapPenjualanCrystalReportRepository().printLapPenjualan(
        template: template,
        dateFrom: dateFrom,
        dateTo: dateTo,
        format: format,
        detail: detail);
  }
}
