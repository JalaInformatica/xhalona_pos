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
  var format = "SETTLE_BY".obs;
  var total = "".obs;

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
        fDateFrom: '2025-01-01',
        filterValue: filterValue.value,
        fDateTo: fDateTo.value,
        format: format.value,
      );

      monitorHeader.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}
