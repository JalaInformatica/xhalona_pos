import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/summary.dart';
import 'package:xhalona_pos/repositories/summary/summary_repository.dart';

class SummaryController extends GetxController {
  SummaryRepository _summaryRepository = SummaryRepository();

  var summaryHeader = <SummaryDAO>[].obs;
  var isLoading = true.obs;
  // var trxStatusCategory = ProductStatusCategory.progress.obs;
  var isActive = false.obs;
  var filterValue = "".obs;
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

      // Ambil tanggal sekarang
      DateTime now = DateTime.now();
      String fYear = now.year.toString(); // Tahun dalam format "2025"
      String fMonth =
          now.month.toString().padLeft(2, '0'); // Bulan dalam format "02"
      String fDay =
          now.day.toString().padLeft(2, '0'); // Hari dalam format "12"

      final result = await _summaryRepository.getSummary(
        fDay: fDay,
        filterValue: filterValue.value,
        fMonth: fMonth,
        fYear: fYear,
      );

      // Periksa apakah result tidak kosong sebelum mengakses index [0]
      if (result.isNotEmpty) {
        summaryHeader.value = result;
        total.value = result[0].total == 0 ? '0' : result[0].total.toString();
      } else {
        summaryHeader.value = []; // Set ke list kosong jika tidak ada data
        total.value = '0'; // Pastikan total tidak error saat result kosong
      }
    } finally {
      isLoading.value = false;
    }
  }
}
