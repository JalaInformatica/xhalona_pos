import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:xhalona_pos/models/dao/kategori.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/models/dao/monitor.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/repositories/employee/employee_repository.dart';
import 'package:xhalona_pos/repositories/kustomer/kustomer_repository.dart';
import 'package:xhalona_pos/repositories/monitor/monitor_repository.dart';
import 'package:xhalona_pos/repositories/crystal_report/lap_penjualan_repository.dart';
import 'package:xhalona_pos/repositories/product/product_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/karyawan_controller.dart';

class MonitorController extends GetxController {
  MonitorRepository _monitorRepository = MonitorRepository();
  EmployeeRepository _employeeRepository = EmployeeRepository();
  KustomerRepository _kustomerRepository = KustomerRepository();
  ProductRepository _productRepository = ProductRepository();

  var startDate = DateFormat("dd-MM-yyyy").format(DateTime.now()).obs;
  var endDate = DateFormat("dd-MM-yyyy").format(DateTime.now()).obs;
  
  var isFilterByTerapis = false.obs;
  var isFilterByCustomer = false.obs;
  var isFilterByProduct = false.obs;
  var isFilterByKategori = false.obs;

  var terapisHeader = <EmployeeDAO>[].obs;
  var filterTableByTerapis = "".obs;

  Future<void>fetchTerapis(String? filter) async {
    terapisHeader.value = await _employeeRepository.getEmployees(
      pageRow: 5,
      filterValue: filter
    );          
  }

  TextEditingController productController = TextEditingController();
  TextEditingController employeeController = TextEditingController();

  var kustomerHeader = <KustomerDAO>[].obs;
  var filterTableByCustomer = "".obs;

  var productHeader = <ProductDAO>[].obs;
  var filterTableByProduct = "".obs;

  Future<void>fetchProducts(String? filter) async {
    productHeader.value = await _productRepository.getProducts(
      pageRow: 5,
      filterValue: filter
    );          
  }

  var kategoriHeader = <KategoriDAO>[].obs;
  var filterTableByKategori = "".obs;

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
        (filterTableByKategori.value.isEmpty || monitor.ketAnalisa == filterTableByKategori.value) &&
        (shift.value=="SEMUA" || monitor.shiftId == shift.value) &&
        (filterTableByTerapis.value.isEmpty || monitor.empId == filterTableByTerapis.value) &&
        (filterTableByCustomer.value.isEmpty || monitor.supplierName == filterTableByCustomer.value) &&
        (filterTableByProduct.value.isEmpty || monitor.partName.contains(filterTableByProduct.value))
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
