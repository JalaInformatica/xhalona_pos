import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xhalona_pos/repositories/crystal_report/lap_penjualan_repository.dart';

class LapFinanceController extends GetxController {
  var startDate = DateFormat("dd-MM-yyyy").format(DateTime.now()).obs;
  var endDate = DateFormat("dd-MM-yyyy").format(DateTime.now()).obs;
  var selectedReportType = 'Lap_Penjualan'.obs;
  var detailOption = '1'.obs;
  var formatOption = 'PDF'.obs;

  Future<String> printLapPenjualan(
  ) async {
    return await LapPenjualanCrystalReportRepository().printLapPenjualan(
      template: selectedReportType.value,
      dateFrom: DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(startDate.value)),
      dateTo: DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(endDate.value)),
      format: formatOption.value,
      detail: detailOption.value
    );
  }
}
