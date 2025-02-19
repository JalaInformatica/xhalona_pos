import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xhalona_pos/models/dao/monitor.dart';
import 'package:xhalona_pos/repositories/monitor/monitor_repository.dart';
import 'package:xhalona_pos/repositories/crystal_report/lap_penjualan_repository.dart';

class MonitorController extends GetxController {
  MonitorRepository _monitorRepository = MonitorRepository();
  var startDate = DateFormat("dd-MM-yyyy").format(DateTime.now()).obs;
  var endDate = DateFormat("dd-MM-yyyy").format(DateTime.now()).obs;
  
  var isFilterByTerapis = false.obs;
  var isFilterByCustomer = false.obs;
  var isFilterByProduct = false.obs;
  var isFilterByKategori = false.obs;

  var filterTerapisValue = "".obs;
  var filterCustomerValue = "".obs;
  var filterProductValue = "".obs;
  var filterKategoriValue = "".obs;

  var monitorHeader = <MonitorDAO>[].obs;
  var isLoading = true.obs;
  var isActive = false.obs;
  var filterValue = "".obs;

  var type = "Detail".obs;
  var shift = "".obs;

  var format = "SALES_DATE".obs;

  var total = "".obs;

  RxDouble sumTotal = 0.0.obs;
  RxDouble sumTagihan = 0.0.obs;
  RxDouble sumDisc = 0.0.obs;
  RxDouble sumVch = 0.0.obs;
  RxDouble sumAcc = 0.0.obs;
  RxDouble sumQris = 0.0.obs;
  RxDouble sumCash = 0.0.obs;
  RxDouble sumHutang = 0.0.obs;
  RxDouble sumTitipan = 0.0.obs;

  var pageNo = 1.obs;
  var pageRow = 10.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void updateFilterActive() async {
    isActive.value = !isActive.value;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchData();
  }

  void updateFilterValue(String newFilterValue) {
    filterValue.value = newFilterValue;
    fetchData();
  }

  void updateFormat(String newFormat) {
    format.value = newFormat;
    fetchData();
  }

  Future<String> printLapPenjualan(
    String? template,
    String? format,
    String? detail,
  ) async {
    return await LapPenjualanCrystalReportRepository().printLapPenjualan(
      template: template,
      dateFrom: DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(startDate.value)),
      dateTo: DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(endDate.value)),
      format: format,
      detail: detail
    );
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final result = await _monitorRepository.getMonitor(
        fDateFrom: DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(startDate.value)),
        filterValue: filterValue.value,
        fDateTo: DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(endDate.value)),
        format: format.value,
      );

      monitorHeader.value = result.where((monitor) =>
        (filterKategoriValue.value.isEmpty || monitor.ketAnalisa == filterKategoriValue.value) &&
        (shift.value=="SEMUA" || monitor.shiftId == shift.value) &&
        (filterTerapisValue.value.isEmpty || monitor.empId == filterTerapisValue.value) &&
        (filterCustomerValue.value.isEmpty || monitor.supplierName == filterCustomerValue.value) &&
        (filterProductValue.value.isEmpty || monitor.partId == filterProductValue.value)
      ).toList();

      sumTotal.value =
          result.fold(0.0, (sum, item) => sum + (item.nettoVal ?? 0.0));
      sumTagihan.value =
          result.fold(0.0, (sum, item) => sum + (item.totalCompliment ?? 0.0));
      sumAcc.value =
          result.fold(0.0, (sum, item) => sum + (item.nettoValD ?? 0.0));
      sumCash.value =
          result.fold(0.0, (sum, item) => sum + (item.totalCash ?? 0.0));
      sumDisc.value =
          result.fold(0.0, (sum, item) => sum + (item.discVal ?? 0.0));
      sumHutang.value =
          result.fold(0.0, (sum, item) => sum + (item.totalHutang ?? 0.0));
      sumQris.value =
          result.fold(0.0, (sum, item) => sum + (item.totalNonCash ?? 0.0));
      sumTitipan.value =
          result.fold(0.0, (sum, item) => sum + (item.addCostVal ?? 0.0));
      sumVch.value =
          result.fold(0.0, (sum, item) => sum + (item.feeEmpVal ?? 0.0));
    } finally {
      isLoading.value = false;
    }
  }
}
