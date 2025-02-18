import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xhalona_pos/repositories/crystal_report/lap_penjualan_repository.dart';

class LapPenjualanController extends GetxController {
  var startDate = DateFormat("dd-MM-yyyy").format(DateTime.now()).obs;
  var endDate = DateFormat("dd-MM-yyyy").format(DateTime.now()).obs;

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
