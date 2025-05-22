import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/report.dart';
import 'package:xhalona_pos/models/dao/summary.dart';
import 'package:xhalona_pos/repositories/report/report_repository.dart';

enum DashboardType {MONTHLY, ANNUAL}

class DashboardController extends GetxController {
  ReportRepository _reportRepository = ReportRepository();

  var filterMonth = DateTime.now().month.obs;
  var filterYear = DateTime.now().year.obs;

  var summaryHeader = <SummaryDAO>[].obs;
  var isLoading = true.obs;
  var isActive = false.obs;
  var filterValue = "".obs;
  var nettoValDThisMonth = 0.obs;
  var totalTrxThisMonth = 0.obs;

  var nettoValDToday = 0.obs;
  var totalTrxToday = 0.obs;
  List<ReportDAO> salesThisMonth = [];

  DateTime now = DateTime.now();

  late Rx<DateTime?> nettoPerDayStartDate = DateTime(now.year, now.month, 1).obs;
  late Rx<DateTime?> nettoPerDayEndDate = DateTime(now.year, now.month + 1, 0).obs;

  late var trxPerDayStartDate = DateTime(now.year, now.month, 1).toString().obs;
  late var trxPerDayEndDate = DateTime(now.year, now.month + 1, 0).toString().obs;

  var dashboardType = DashboardType.MONTHLY.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;

    if(dashboardType.value == DashboardType.MONTHLY){
      salesThisMonth = await _reportRepository.getReport(
        actionId: "R_01",
        startDate: DateTime(filterYear.value, filterMonth.value, 1),
        endDate: DateTime(filterYear.value, filterMonth.value + 1, 0),
      );
    }
    else {
      salesThisMonth = await _reportRepository.getReport(
        actionId: "R_01",
        startDate: DateTime(filterYear.value, 1, 1),
        endDate: DateTime(filterYear.value, 12, 31),
      );
    }

    nettoValDToday.value = salesThisMonth.where((sale) {
      DateTime saleDate = DateTime.parse(sale.salesDate);
      return saleDate.year == now.year &&
          saleDate.month == now.month &&
          saleDate.day == now.day;
    }).fold(0, (acc, sale) => acc + sale.nettoValD);

    nettoValDThisMonth.value = salesThisMonth.fold(0, (acc, sale) => acc + sale.nettoValD);

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

  var dataPerMonthLabel = <int>[].obs;
  var dataNetPerMonthValue = <FlSpot>[].obs;
  var dataTrxPerMonthValue = <FlSpot>[].obs;

  var dataNetPerTerapisLabel = <String>[].obs;
  var dataNetPerTerapisValue = <FlSpot>[].obs;
  var dataTrxPerTerapisLabel = <String>[].obs;
  var dataTrxPerTerapisValue = <FlSpot>[].obs;

  var dataNetPerProdukLabel = <String>[].obs;
  var dataNetPerProdukValue = <FlSpot>[].obs;

  Future<void> fetchGraph() async {
    Map<int, double> dataNetPerMonth = {};
    Map<int, int> dataTrxPerMonth = {};

    for (var sale in salesThisMonth) {
      DateTime saleDate = DateTime.parse(sale.salesDate);
      int dayNumber = 0;
      if(dashboardType.value==DashboardType.MONTHLY){
        dayNumber = saleDate.day;
      }
      else {
        dayNumber = saleDate.month;
      }

      if (!dataNetPerMonth.containsKey(dayNumber)) {
        dataNetPerMonth[dayNumber] = 0;
      }
      if (!dataTrxPerMonth.containsKey(dayNumber)) {
        dataTrxPerMonth[dayNumber] = 0;
      }

      dataNetPerMonth[dayNumber] =
          (dataNetPerMonth[dayNumber] ?? 0) + sale.nettoValD;

      dataTrxPerMonth[dayNumber] = (dataTrxPerMonth[dayNumber] ?? 0) + 1;
    }

    dataNetPerMonthValue.value = dataNetPerMonth.entries
        .toList()
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
        .toList();

    dataTrxPerMonthValue.value = dataTrxPerMonth.entries
        .toList()
        .asMap()
        .entries
        .map((entry) =>
            FlSpot(entry.key.toDouble(), entry.value.value.toDouble()))
        .toList();

    dataPerMonthLabel.value =
        dataNetPerMonth.entries.map((entry) => entry.key).toList();

    Map<String, double> dataNetPerTerapis = {};
    Map<String, int> dataTrxPerTerapis = {};

    for (var sale in salesThisMonth) {
      String employeeName = sale.fullName;
      if (employeeName.isEmpty) {
        continue;
      }

      if (!dataNetPerTerapis.containsKey(employeeName)) {
        dataNetPerTerapis[employeeName] = 0;
      }
      if (!dataTrxPerTerapis.containsKey(employeeName)) {
        dataTrxPerTerapis[employeeName] = 0;
      }

      dataNetPerTerapis[employeeName] =
          (dataNetPerTerapis[employeeName] ?? 0) + sale.nettoValD;

      dataTrxPerTerapis[employeeName] =
          (dataTrxPerTerapis[employeeName] ?? 0) + 1;
    }

    List<MapEntry<String, double>> sortedDataNetPerTerapis =
        dataNetPerTerapis.entries.toList();
    sortedDataNetPerTerapis.sort((a, b) => b.value.compareTo(a.value));

    dataNetPerTerapisValue.value = sortedDataNetPerTerapis
        .take(5)
        .toList()
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
        .toList();

    List<MapEntry<String, int>> sortedDataTrxPerTerapis =
        dataTrxPerTerapis.entries.toList();
    sortedDataTrxPerTerapis.sort((a, b) => b.value.compareTo(a.value));

    dataTrxPerTerapisValue.value = sortedDataTrxPerTerapis
        .take(5)
        .toList()
        .asMap()
        .entries
        .map((entry) =>
            FlSpot(entry.key.toDouble(), entry.value.value.toDouble()))
        .toList();

    dataTrxPerTerapisLabel.value =
        dataTrxPerTerapis.entries.map((entry) => entry.key).toList();

    dataNetPerTerapisLabel.value =
        dataNetPerTerapis.entries.map((entry) => entry.key).toList();

    Map<String, double> dataNetPerProduk = {};
    for (var sale in salesThisMonth) {
      String partName = sale.partName;
      if (partName.isEmpty) {
        continue;
      }

      if (!dataNetPerProduk.containsKey(partName)) {
        dataNetPerProduk[partName] = 0;
      }

      dataNetPerProduk[partName] =
          (dataNetPerProduk[partName] ?? 0) + sale.nettoValD;
    }

    List<MapEntry<String, double>> sortedDataNetPerProduk =
        dataNetPerProduk.entries.toList();
    sortedDataNetPerProduk.sort((a, b) => b.value.compareTo(a.value));

    dataNetPerProdukValue.value = sortedDataNetPerProduk
        .take(5)
        .toList()
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
        .toList();

    dataNetPerProdukLabel.value =
        dataNetPerProduk.entries.map((entry) => entry.key).toList();
  }
}
