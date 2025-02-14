import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/report.dart';
import 'package:xhalona_pos/models/dao/summary.dart';
import 'package:xhalona_pos/repositories/report/report_repository.dart';

class DashboardController extends GetxController {
  ReportRepository _reportRepository = ReportRepository();

  var summaryHeader = <SummaryDAO>[].obs;
  var isLoading = true.obs;
  var isActive = false.obs;
  var filterValue = "".obs;
  var nettoValDThisMonth = 0.obs;
  var totalTrxThisMonth = 0.obs;

  var nettoValDToday = 0.obs;
  var totalTrxToday = 0.obs;
  List<ReportDAO> salesThisMonth = [];

  var dataNetPerMonthValue = <FlSpot>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;

    DateTime now = DateTime.now();
    salesThisMonth = await _reportRepository.getReport(
      actionId: "R_01",
      startDate: DateTime(now.year, now.month, 1).toString(),
      endDate: DateTime(now.year, now.month + 1, 0).toString(),
    );

    nettoValDToday.value = salesThisMonth.where((sale) {
      DateTime saleDate = DateTime.parse(sale.salesDate);
      return saleDate.year == now.year &&
          saleDate.month == now.month &&
          saleDate.day == now.day;
    }).fold(0, (acc, sale) => acc + sale.nettoValD);

    nettoValDThisMonth.value = salesThisMonth.where((sale) {
      DateTime saleDate = DateTime.parse(sale.salesDate);
      return saleDate.year == now.year && saleDate.month == now.month;
    }).fold(0, (acc, sale) => acc + sale.nettoValD);

    totalTrxThisMonth.value = salesThisMonth.where((sale) {
      DateTime saleDate = DateTime.parse(sale.salesDate);
      return saleDate.year == now.year && saleDate.month == now.month;
    }).length;

    totalTrxToday.value = salesThisMonth.where((sale) {
      DateTime saleDate = DateTime.parse(sale.salesDate);
      return saleDate.year == now.year &&
          saleDate.month == now.month &&
          saleDate.day == now.day;
    }).length;

    await fetchGraph();
  }

  var dataNetPerMonthLabel = <int>[].obs;

  Future<void> fetchGraph() async {
    Map<int, double> dataNetPerMonth = {};

    for (var sale in salesThisMonth) {
      DateTime saleDate = DateTime.parse(sale.salesDate);
      int dayNumber = saleDate.day;

      if (!dataNetPerMonth.containsKey(dayNumber)) {
        dataNetPerMonth[dayNumber] = 0;
      }
      dataNetPerMonth[dayNumber] =
          (dataNetPerMonth[dayNumber] ?? 0) + sale.nettoValD;
    }

    dataNetPerMonthValue.value = dataNetPerMonth.entries
      .toList()
      .asMap()
      .entries
      .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
      .toList();

    dataNetPerMonthLabel.value = dataNetPerMonth.entries.map((entry)=>entry.key).toList();
  }
}
