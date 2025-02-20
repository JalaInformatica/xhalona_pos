import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:xhalona_pos/models/dao/kategori.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/models/dao/monitor.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/repositories/employee/employee_repository.dart';
import 'package:xhalona_pos/repositories/kategori_repository.dart';
import 'package:xhalona_pos/repositories/kustomer/kustomer_repository.dart';
import 'package:xhalona_pos/repositories/monitor/monitor_repository.dart';
import 'package:xhalona_pos/repositories/crystal_report/lap_penjualan_repository.dart';
import 'package:xhalona_pos/repositories/product/product_repository.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/monitor/monitor_widget.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/karyawan_controller.dart';

class MonitorController extends GetxController {
  MonitorRepository _monitorRepository = MonitorRepository();
  EmployeeRepository _employeeRepository = EmployeeRepository();
  KustomerRepository _kustomerRepository = KustomerRepository();
  ProductRepository _productRepository = ProductRepository();
  KategoriRepository _kategoriRepository = KategoriRepository();

  var showFilters = true.obs;

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
  TextEditingController customerController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  var kustomerHeader = <KustomerDAO>[].obs;
  var filterTableByCustomer = "".obs;
  Future<void>fetchKustomer(String? filter) async {
    kustomerHeader.value = await _kustomerRepository.getKustomer(
      pageRow: 5,
      filterValue: filter
    );          
  }

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

  Future<void>fetchKategori(String? filter) async {
    kategoriHeader.value = await _kategoriRepository.getKategori(
      pageRow: 5,
      filterValue: filter
    );          
  }

  var monitorHeader = <MonitorDAO>[].obs;
  var isLoading = true.obs;
  var isActive = false.obs;
  var filterValue = "".obs;

  var type = "Detail".obs;
  var shift = "".obs;

  var sortBy = "SALES_DATE".obs;

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
    sortBy.value = newFormat;
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

  List<List<MonitorTableCell>> groupingData(List<MonitorDAO> monitors){
    String? prevDate;
    String? prevSalesId;
    List<List<MonitorTableCell>> groupedData = [];

    for (int i=0; i<monitors.length; i++) {
      MonitorDAO monitor = monitors[i];
      
      String currentDate = monitor.createDate.split("T").first;
      String currentSalesId = monitor.salesId;
      if (prevDate != null && prevDate != currentDate) {
        groupedData.add(
          List.generate(19, (_) => MonitorTableCell(value: "-", color: AppColor.grey400,))
        );
      }

      // Step 2: Add the actual row
      groupedData.add([
        MonitorTableCell(value: currentDate),
        MonitorTableCell(value: monitor.shiftId),
        MonitorTableCell(value: shortenTrxId(currentSalesId)),
        MonitorTableCell(value: monitor.supplierName),
        MonitorTableCell(value: monitor.partName),
        MonitorTableCell(value: monitor.ketAnalisa),
        MonitorTableCell(value: monitor.qty.toString()),
        MonitorTableCell(value: monitor.price.toString()),
        MonitorTableCell(value: monitor.totalPrice.toString()),
        MonitorTableCell(value: monitor.discVal.toString()),
        MonitorTableCell(value: monitor.totalCompliment.toString()),
        MonitorTableCell(value: monitor.settlePaymentMethod),
        MonitorTableCell(value: monitor.feeEmpVal.toString()),
        MonitorTableCell(value: monitor.nettoValD.toString()),
        MonitorTableCell(value: monitor.totalCash.toString()),
        MonitorTableCell(value: monitor.totalNonCash.toString()),
        MonitorTableCell(value: monitor.totalHutang.toString()),
        MonitorTableCell(value: monitor.addCostVal.toString()),
        MonitorTableCell(value: monitor.fullName),
      ]);

      // Step 3: If salesId changes, insert a separator row
      if (prevSalesId != null && prevSalesId != currentSalesId) {
        groupedData.add(
          List.generate(19, (_) => MonitorTableCell(value: "-", color: AppColor.grey200,))
        );
      }

      

      prevDate = currentDate;
      prevSalesId = currentSalesId;
    }
    return groupedData;
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final result = await _monitorRepository.getMonitor(
        fDateFrom: DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(startDate.value)),
        fDateTo: DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(endDate.value)),
        format: sortBy.value,
      );
      print(filterTableByCustomer);
      monitorHeader.value = result
      .where((monitor) =>
        (filterTableByKategori.value.isEmpty || monitor.ketAnalisa == filterTableByKategori.value) &&
        (shift.value=="SEMUA" || monitor.shiftId == shift.value) &&
        (filterTableByTerapis.value.isEmpty || monitor.fullName == filterTableByTerapis.value) &&
        (filterTableByCustomer.value.isEmpty || monitor.supplierName == filterTableByCustomer.value) &&
        (filterTableByProduct.value.isEmpty || monitor.partName == (filterTableByProduct.value))
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
