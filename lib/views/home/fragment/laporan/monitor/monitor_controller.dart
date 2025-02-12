import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xhalona_pos/models/dao/monitor.dart';
import 'package:xhalona_pos/repositories/monitor/monitor_repository.dart';

class MonitorController extends GetxController {
  MonitorRepository _monitorRepository = MonitorRepository();

  var monitorHeader = <MonitorDAO>[].obs;
  var isLoading = true.obs;
  // var trxStatusCategory = ProductStatusCategory.progress.obs;
  var isActive = false.obs;
  var filterValue = "".obs;
  DateTime dateNow = DateTime.now();
  late RxString fDateFrom = DateFormat('yyyy-MM-dd').format(dateNow).obs;
  late RxString fDateTo = DateFormat('yyyy-MM-dd').format(dateNow).obs;
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
    fetchProducts();
  }

  void updateFilterActive() async {
    isActive.value = !isActive.value;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchProducts();
  }

  void updateFilterValue(String newFilterValue) {
    filterValue.value = newFilterValue;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchProducts();
  }

  void updateFormat(String newFormat) {
    format.value = newFormat;
    fetchProducts();
  }

  void updateFilterDate(String newFormat, int tanda) {
    if (tanda == 1) {
      fDateTo.value = newFormat;
    }
    if (tanda == 0) {
      fDateFrom.value = newFormat;
    }

    fetchProducts();
  }

  void updatePageNo(int newFilterValue) {
    pageNo.value = newFilterValue;
    fetchProducts();
  }

  void updatePageRow(int newFilterValue) {
    pageRow.value = newFilterValue;
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final result = await _monitorRepository.getMonitor(
        fDateFrom: fDateFrom.value,
        filterValue: filterValue.value,
        fDateTo: fDateTo.value,
        format: format.value,
      );

      monitorHeader.value = result;

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
