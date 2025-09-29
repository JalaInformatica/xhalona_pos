import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/response/employee.dart';
import 'package:xhalona_pos/models/response/kategori.dart';
import 'package:xhalona_pos/models/response/kustomer.dart';
import 'package:xhalona_pos/globals/monitor/monitor.dart';
import 'package:xhalona_pos/globals/product/models/product.dart';
import 'package:xhalona_pos/repositories/employee/employee_repository.dart';
import 'package:xhalona_pos/repositories/kategori_repository.dart';
import 'package:xhalona_pos/repositories/kustomer/kustomer_repository.dart';
import 'package:xhalona_pos/globals/monitor/monitor_repository.dart';
import 'package:xhalona_pos/globals/crystal_report/lap_penjualan_repository.dart';
import 'package:xhalona_pos/globals/product/repositories/product_repository.dart';
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

  var shift = "SEMUA".obs;

  var type = "Detail".obs;
  var formatId = <String>[].obs;
  
  void updateType(String newType){
    type.value = newType;
    switch(type.value){
      case "Subtotal":
        formatId.assignAll(["0"]);
      break;
      case "Rekap":
        formatId.assignAll(["0","1"]);
      break;
      default:
        formatId.assignAll([]);
    }
  }

  var sortBy = "SALES_DATE".obs;

  var total = "".obs;

  @override
  void onInit() {
    super.onInit();
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
      print('a ${sortBy.value}');
    switch(sortBy.value){
      case 'SALES_DATE':
        return groupingDataBy(
          monitors: monitors, 
          getSubId: (monitor)=>monitor.salesId,
          getRekapId: (monitor)=>monitor.createDate.split("T").first, 
          isFormatSalesId: true
        );
      case 'SETTLE_BY, SALES_DATE':
        return groupingDataBy(
          monitors: monitors, 
          getSubId: (monitor)=>monitor.createDate.split("T").first,
          getRekapId: (monitor)=>monitor.settleBy, 
        );
      case 'EMPLOYEE_ID, SALES_DATE':
        return groupingDataBy(
          monitors: monitors, 
          getSubId: (monitor)=>monitor.createDate.split("T").first,
          getRekapId: (monitor)=>monitor.fullName, 
        );
      case 'SUPPLIER_ID, SALES_DATE':
        return groupingDataBy(
          monitors: monitors, 
          getSubId: (monitor)=>monitor.createDate.split("T").first,
          getRekapId: (monitor)=>monitor.supplierName, 
        );
      case 'PART_ID, SALES_DATE':
        return groupingDataBy(
          monitors: monitors, 
          getSubId: (monitor)=>monitor.createDate.split("T").first,
          getRekapId: (monitor)=>monitor.partName, 
        );
      default:
        return groupingDataBy(
          monitors: monitors, 
          getSubId: (monitor)=>monitor.salesId,
          getRekapId: (monitor)=>monitor.createDate.split("T").first, 
        );
    }
  }

  List<List<MonitorTableCell>> groupingDataBy({
    required List<MonitorDAO> monitors,
    required String Function(MonitorDAO) getSubId,
    required String Function(MonitorDAO) getRekapId, 
    bool isFormatSalesId = false,
    }){
    String? nextSubId; 
    String? nextRekapId;

    int cummulativeDetailQty = 0;
    int cummulativeDetailTotal = 0;
    int cummulativeDetailNetto = 0;
    int cummulativeDetailDiscount = 0;
    int cummulativeDetailCompVch = 0;
    int cummulativeDetailCash = 0;
    int cummulativeDetailNonCash = 0;
    int cummulativeDetailDebt = 0;
    int cummulativeDetailTitipan = 0;

    int cummulativeRekapQty = 0;
    int cummulativeRekapTotalPrice = 0;
    int cummulativeRekapDiscount = 0;
    int cummulativeRekapNetto = 0;
    int cummulativeRekapCompVch = 0;
    int cummulativeRekapCash = 0;
    int cummulativeRekapNonCash = 0;
    int cummulativeRekapDebt = 0;
    int cummulativeRekapTitipan = 0;

    int grandQty=0;
    int grandTotal=0;
    int grandDiskon=0;
    int grandNetto=0;
    int grandCompVch=0;
    int grandCash=0;
    int grandNonCash=0;
    int grandDebt=0;
    int grandTitipan=0;

    List<List<MonitorTableCell>> groupedData = [];

    for (int i=0; i<monitors.length; i++) {
      MonitorDAO monitor = monitors[i];
      String currentRekapId = getRekapId(monitor); //monitor.createDate.split("T").first;
      String currentSubId = getSubId(monitor); //monitor.salesId;
      bool isTitipan = monitor.totalHutang.isNegative;
      
      groupedData.add([
        MonitorTableCell(value: "0",),
        MonitorTableCell(value: monitor.salesDate.split("T").first),
        MonitorTableCell(value: monitor.shiftId),
        MonitorTableCell(value: shortenTrxId(monitor.salesId)),
        MonitorTableCell(value: monitor.supplierName),
        MonitorTableCell(value: monitor.partName),
        MonitorTableCell(value: monitor.ketAnalisa),
        MonitorTableCell(
          value: monitor.qty.toString(),
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: formatThousands(monitor.price.toString()),
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: formatThousands(monitor.totalPrice.toString()),
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: formatThousands(monitor.deductionVal.toString()),
          alignment: Alignment.centerRight,
        ), //OR: DISCOUNT_VAL?
        MonitorTableCell(
          value: ""),
        MonitorTableCell(
          value: ""),
        MonitorTableCell(
          value: ""),
        MonitorTableCell(
          value: formatThousands(monitor.nettoValD.toString()),
          alignment: Alignment.centerRight,
        ), //TODO: SESUAIKAN DENGAN SETTLE_PAYMENT_VAL 
        MonitorTableCell(
          value: ""),
        MonitorTableCell(
          value: ""),
        MonitorTableCell(
          value: ""),
        MonitorTableCell(
          value: ""),
        MonitorTableCell(
          value: monitor.fullName),
      ]);

      cummulativeDetailQty+=monitor.qty;
      cummulativeDetailDiscount+=monitor.deductionVal;
      if(!isFormatSalesId){
        cummulativeDetailTotal+=monitor.totalPrice;
        cummulativeDetailNetto+=monitor.nettoValD;
        cummulativeDetailCompVch+= (monitor.nettoValD*(monitor.totalCompliment/monitor.nettoVal)).round();
        if(isTitipan){
          cummulativeDetailTitipan += ((monitor.totalHutang/monitor.nettoVal)*-(monitor.nettoValD)).round();
          cummulativeDetailCash+= monitor.totalCash>0? (monitor.nettoValD*((monitor.totalCash-(monitor.totalHutang*-1))/monitor.nettoVal)).round() : 0;
          cummulativeDetailNonCash+= monitor.totalNonCash>0? (monitor.nettoValD*((monitor.totalNonCash-(monitor.totalHutang*-1))/monitor.nettoVal)).round() : 0;
        }
        else {
          cummulativeDetailDebt += monitor.totalHutang;          
          cummulativeDetailCash+= (monitor.nettoValD*(monitor.totalCash/monitor.nettoVal)).round();
          cummulativeDetailNonCash+= (monitor.nettoValD*(monitor.totalNonCash/monitor.nettoVal)).round();
        }
      }

      if(i<monitors.length-1){
        MonitorDAO nextMonitor = monitors[i+1];
        nextSubId = getSubId(nextMonitor);
        nextRekapId = getRekapId(nextMonitor);
        
        if (nextSubId != currentSubId) {
          groupedData.add(
            [
              MonitorTableCell(value: "1",),
              MonitorTableCell(value: "", color: AppColor.grey200,),
              MonitorTableCell(
                value: monitor.shiftId, 
                color: AppColor.grey200, 
                fontWeight: FontWeight.bold,
              ),
              MonitorTableCell(
                value: "Kasir:", 
                alignment: Alignment.centerRight,
                color: AppColor.grey200,
                textAlign: TextAlign.end,
                fontWeight: FontWeight.bold,
              ),
              MonitorTableCell(
                value: monitor.settleBy, 
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
              ),
              MonitorTableCell(
                value: "", 
                color: AppColor.grey200,
              ),
              MonitorTableCell(
                value: shortenTrxId(monitor.salesId),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
              ),
              MonitorTableCell(
                value: cummulativeDetailQty.toString(),
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
                color: AppColor.grey200,
              ),
              MonitorTableCell(
                value: "",
                color: AppColor.grey200,
              ),
              MonitorTableCell(
                value: formatThousands((!isFormatSalesId? cummulativeDetailTotal : monitor.brutoVal).toString()),
                alignment: Alignment.centerRight,
                fontWeight: FontWeight.bold,
                color: AppColor.grey200,
              ),
              MonitorTableCell(
                value: formatThousands(cummulativeDetailDiscount.toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatThousands((!isFormatSalesId? cummulativeDetailNetto : monitor.nettoVal).toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: monitor.settlePaymentMethod,
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,                
              ),
              MonitorTableCell(
                value: formatThousands((!isFormatSalesId? cummulativeDetailCompVch : monitor.totalCompliment).toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatThousands((!isFormatSalesId? cummulativeDetailNetto : monitor.nettoVal).toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatThousands((!isFormatSalesId? cummulativeDetailCash : monitor.totalCash > 0 && isTitipan? monitor.totalCash -(monitor.totalHutang*-1) : monitor.totalCash).toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatThousands((!isFormatSalesId? cummulativeDetailNonCash : monitor.totalNonCash> 0 && isTitipan? monitor.totalNonCash - (monitor.totalHutang*-1) : monitor.totalNonCash).toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatThousands((!isFormatSalesId? cummulativeDetailDebt : monitor.totalHutang).toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatThousands((!isFormatSalesId? cummulativeDetailTitipan : (monitor.totalHutang*-1)).toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: "",
                color: AppColor.grey200,
              ),
            ]
          );
          cummulativeRekapQty+=cummulativeDetailQty;
          cummulativeRekapDiscount+= cummulativeDetailDiscount;
          if(isFormatSalesId){
            cummulativeRekapTotalPrice+= monitor.brutoVal;
            cummulativeRekapNetto+= monitor.nettoVal;
            cummulativeRekapCompVch+=monitor.totalCompliment;
            cummulativeRekapCash+=monitor.totalCash > 0 && isTitipan? monitor.totalCash -(monitor.totalHutang*-1) : monitor.totalCash;
            cummulativeRekapNonCash+=monitor.totalNonCash > 0 && isTitipan? monitor.totalNonCash -(monitor.totalHutang*-1) : monitor.totalNonCash;
            cummulativeRekapDebt+= isTitipan? 0 : monitor.totalHutang;
            cummulativeRekapTitipan += isTitipan? (monitor.totalHutang*-1):0;
          }
          else {
            cummulativeRekapTotalPrice+= cummulativeDetailTotal;
            cummulativeRekapNetto+= cummulativeDetailNetto;
            cummulativeRekapCompVch+=cummulativeDetailCompVch;
            cummulativeRekapCash+=cummulativeDetailCash;
            cummulativeRekapNonCash+=cummulativeDetailNonCash;
            cummulativeRekapDebt+= cummulativeDetailDebt;
            cummulativeRekapTitipan += cummulativeDetailTitipan;
          }

          cummulativeDetailQty = 0;
          cummulativeDetailTotal = 0;
          cummulativeDetailNetto = 0;
          cummulativeDetailDiscount = 0;
          cummulativeDetailCompVch = 0;
          cummulativeDetailCash = 0;
          cummulativeDetailNonCash = 0;
          cummulativeDetailDebt = 0;
          cummulativeDetailTitipan = 0;

        }

        if (nextRekapId != currentRekapId) {
          groupedData.add(
            [
              MonitorTableCell(value: "2",),
              MonitorTableCell(
                value: currentRekapId, 
                color: AppColor.navyColor,
                fontColor: AppColor.whiteColor,
                fontWeight: FontWeight.bold,
              ),
              MonitorTableCell(
                value: "", 
                color: AppColor.navyColor, 
                fontColor: AppColor.whiteColor,
              ),
              MonitorTableCell(
                value: "", 
                color: AppColor.navyColor,
              ),
              MonitorTableCell(
                value: "", 
                color: AppColor.navyColor,
              ),
              MonitorTableCell(
                value: "", 
                color: AppColor.navyColor,
              ),
              MonitorTableCell(
                value: "",
                color: AppColor.navyColor,
              ),
              MonitorTableCell(
                value: cummulativeRekapQty.toString(),
                fontColor: AppColor.whiteColor,
                fontWeight: FontWeight.bold,
                color: AppColor.navyColor,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: "",
                color: AppColor.navyColor,
              ),
              MonitorTableCell(value: 
                formatToRupiah(cummulativeRekapTotalPrice),
                fontColor: AppColor.whiteColor,
                fontWeight: FontWeight.bold,
                color: AppColor.navyColor,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapDiscount),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapNetto),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: "",
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,                
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapCompVch),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapNetto),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapCash),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapNonCash),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapDebt),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapTitipan),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: "",
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
              ),
            ]
          );
          grandQty+=cummulativeRekapQty;
          grandTotal+=cummulativeRekapTotalPrice;
          grandDiskon+=cummulativeRekapDiscount;
          grandNetto+=cummulativeRekapNetto;
          grandCompVch+=cummulativeRekapCompVch;
          grandCash+=cummulativeRekapCash;
          grandNonCash+=cummulativeRekapNonCash;
          grandDebt+=cummulativeRekapDebt;
          grandTitipan+=cummulativeRekapTitipan;

          cummulativeRekapQty = 0;
          cummulativeRekapTotalPrice = 0;
          cummulativeRekapDiscount = 0;
          cummulativeRekapNetto = 0;
          cummulativeRekapCompVch = 0;
          cummulativeRekapCash = 0;
          cummulativeRekapNonCash = 0;
          cummulativeRekapDebt = 0;
          cummulativeRekapTitipan = 0;
        }
      }

      else {
        groupedData.add(
            [
              MonitorTableCell(value: "1",),
              MonitorTableCell(value: "", color: AppColor.grey200,),
              MonitorTableCell(
                value: monitor.shiftId, 
                color: AppColor.grey200, 
                fontWeight: FontWeight.bold,
              ),
              MonitorTableCell(
                value: "Kasir:", 
                alignment: Alignment.centerRight,
                color: AppColor.grey200,
                textAlign: TextAlign.end,
                fontWeight: FontWeight.bold,
              ),
              MonitorTableCell(
                value: monitor.settleBy, 
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
              ),
              MonitorTableCell(
                value: "", 
                color: AppColor.grey200,
              ),
              MonitorTableCell(
                value: shortenTrxId(monitor.salesId),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
              ),
              MonitorTableCell(
                value: cummulativeDetailQty.toString(),
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
                color: AppColor.grey200,
              ),
              MonitorTableCell(
                value: "",
                color: AppColor.grey200,
              ),
              MonitorTableCell(
                value: formatThousands((!isFormatSalesId? cummulativeDetailTotal : monitor.brutoVal).toString()),
                alignment: Alignment.centerRight,
                fontWeight: FontWeight.bold,
                color: AppColor.grey200,
              ),
              MonitorTableCell(
                value: formatThousands(cummulativeDetailDiscount.toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatThousands((!isFormatSalesId? cummulativeDetailNetto : monitor.nettoVal).toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: monitor.settlePaymentMethod,
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,                
              ),
              MonitorTableCell(
                value: formatThousands((!isFormatSalesId? cummulativeDetailCompVch : monitor.totalCompliment).toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatThousands((!isFormatSalesId? cummulativeDetailNetto : monitor.nettoVal).toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatThousands((!isFormatSalesId? cummulativeDetailCash : monitor.totalCash).toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatThousands((!isFormatSalesId? cummulativeDetailNonCash : monitor.totalNonCash).toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatThousands(isTitipan? "0" : monitor.totalHutang.toString()),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatThousands(isTitipan? (monitor.totalHutang*-1).toString() : "0"),
                color: AppColor.grey200,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: "",
                color: AppColor.grey200,
              ),
            ]
          );
          
        cummulativeRekapQty+=cummulativeDetailQty;
          cummulativeRekapDiscount+= cummulativeDetailDiscount;
          if(isFormatSalesId){
            cummulativeRekapTotalPrice+= monitor.brutoVal;
            cummulativeRekapNetto+= monitor.nettoVal;
            cummulativeRekapCompVch+=monitor.totalCompliment;
            cummulativeRekapCash+=monitor.totalCash > 0 && isTitipan? monitor.totalCash -(monitor.totalHutang*-1) : monitor.totalCash;
            cummulativeRekapNonCash+=monitor.totalNonCash > 0 && isTitipan? monitor.totalNonCash -(monitor.totalHutang*-1) : monitor.totalNonCash;
            cummulativeRekapDebt+= isTitipan? 0 : monitor.totalHutang;
            cummulativeRekapTitipan += isTitipan? (monitor.totalHutang*-1):0;
          }
          else {
            cummulativeRekapTotalPrice+= cummulativeDetailTotal;
            cummulativeRekapNetto+= cummulativeDetailNetto;
            cummulativeRekapCompVch+=cummulativeDetailCompVch;
            cummulativeRekapCash+=cummulativeDetailCash;
            cummulativeRekapNonCash+=cummulativeDetailNonCash;
            cummulativeRekapDebt+= cummulativeDetailDebt;
            cummulativeRekapTitipan += cummulativeDetailTitipan;
          }

          cummulativeDetailQty = 0;
          cummulativeDetailTotal = 0;
          cummulativeDetailNetto = 0;
          cummulativeDetailDiscount = 0;
          cummulativeDetailCompVch = 0;
          cummulativeDetailCash = 0;
          cummulativeDetailNonCash = 0;
          cummulativeDetailDebt = 0;
          cummulativeDetailTitipan = 0;


        groupedData.add(
            [
              MonitorTableCell(value: "2",),
              MonitorTableCell(
                value: currentRekapId, 
                color: AppColor.navyColor,
                fontColor: AppColor.whiteColor,
                fontWeight: FontWeight.bold,
              ),
              MonitorTableCell(
                value: "", 
                color: AppColor.navyColor, 
                fontColor: AppColor.whiteColor,
              ),
              MonitorTableCell(
                value: "", 
                color: AppColor.navyColor,
              ),
              MonitorTableCell(
                value: "", 
                color: AppColor.navyColor,
              ),
              MonitorTableCell(
                value: "", 
                color: AppColor.navyColor,
              ),
              MonitorTableCell(
                value: "",
                color: AppColor.navyColor,
              ),
              MonitorTableCell(
                value: cummulativeRekapQty.toString(),
                fontColor: AppColor.whiteColor,
                fontWeight: FontWeight.bold,
                color: AppColor.navyColor,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: "",
                color: AppColor.navyColor,
              ),
              MonitorTableCell(value: 
                formatToRupiah(cummulativeRekapTotalPrice),
                fontColor: AppColor.whiteColor,
                fontWeight: FontWeight.bold,
                color: AppColor.navyColor,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapDiscount),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapNetto),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: "",
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,                
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapCompVch),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapNetto),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapCash),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapNonCash),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapDebt),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: formatToRupiah(cummulativeRekapTitipan),
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
                fontWeight: FontWeight.bold,
                alignment: Alignment.centerRight,
              ),
              MonitorTableCell(
                value: "",
                fontColor: AppColor.whiteColor,
                color: AppColor.navyColor,
              ),
            ]
          );
      }      
      
    }

    grandQty+=cummulativeRekapQty;
    grandTotal+=cummulativeRekapTotalPrice;
    grandDiskon+=cummulativeRekapDiscount;
    grandNetto+=cummulativeRekapNetto;
    grandCompVch+=cummulativeRekapCompVch;
    grandCash+=cummulativeRekapCash;
    grandNonCash+=cummulativeRekapNonCash;
    grandDebt+=cummulativeRekapDebt;
    grandTitipan+=cummulativeRekapTitipan;

    groupedData.addAll(
      [[
        MonitorTableCell(value: ""),
        MonitorTableCell(
          value: "Grand Total", 
          color: AppColor.purpleColor,
          fontColor: AppColor.whiteColor,
          fontWeight: FontWeight.bold,
        ),
        MonitorTableCell(
          value: "", 
          color: AppColor.purpleColor, 
          fontColor: AppColor.whiteColor,
        ),
        MonitorTableCell(
          value: "", 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          value: "", 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          value: "", 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          value: "",
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          value: grandQty.toString(),
          fontColor: AppColor.whiteColor,
          fontWeight: FontWeight.bold,
          color: AppColor.purpleColor,
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: "",
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(value: 
          formatToRupiah(grandTotal),
          fontColor: AppColor.whiteColor,
          fontWeight: FontWeight.bold,
          color: AppColor.purpleColor,
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: formatToRupiah(grandDiskon),
          fontColor: AppColor.whiteColor,
          color: AppColor.purpleColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: formatToRupiah(grandNetto),
          fontColor: AppColor.whiteColor,
          color: AppColor.purpleColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: "",
          fontColor: AppColor.whiteColor,
          color: AppColor.purpleColor,
          fontWeight: FontWeight.bold,                
        ),
        MonitorTableCell(
          value: formatToRupiah(grandCompVch),
          fontColor: AppColor.whiteColor,
          color: AppColor.purpleColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: formatToRupiah(grandNetto),
          fontColor: AppColor.whiteColor,
          color: AppColor.purpleColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: formatToRupiah(grandCash),
          fontColor: AppColor.whiteColor,
          color: AppColor.purpleColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: formatToRupiah(grandNonCash),
          fontColor: AppColor.whiteColor,
          color: AppColor.purpleColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: formatToRupiah(grandDebt),
          fontColor: AppColor.whiteColor,
          color: AppColor.purpleColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: formatToRupiah(grandTitipan),
          fontColor: AppColor.whiteColor,
          color: AppColor.purpleColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: "",
          fontColor: AppColor.whiteColor,
          color: AppColor.purpleColor,
        ),
      ],
      [
        MonitorTableCell(
          value: "",
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor, 
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          value: getPercentage(grandDiskon, grandTotal),
          fontColor: AppColor.whiteColor,
          color: AppColor.purpleColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: getPercentage(grandNetto, grandTotal),
          fontColor: AppColor.whiteColor,
          color: AppColor.purpleColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          value: getPercentage(grandCash,grandNetto),
          fontColor: AppColor.whiteColor,
          color: AppColor.purpleColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          value: getPercentage(grandNonCash,grandNetto),
          fontColor: AppColor.whiteColor,
          color: AppColor.purpleColor,
          fontWeight: FontWeight.bold,
          alignment: Alignment.centerRight,
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor,
        ),
        MonitorTableCell(
          customWidget: SizedBox.shrink(), 
          color: AppColor.purpleColor,
        ),
      ]]
    );

    isLoading.value = false;
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
      monitorHeader.value = result
      .where((monitor) =>
        (filterTableByKategori.value.isEmpty || monitor.ketAnalisa == filterTableByKategori.value) &&
        (shift.value=="SEMUA" || monitor.shiftId == shift.value) &&
        (filterTableByTerapis.value.isEmpty || monitor.fullName == filterTableByTerapis.value) &&
        (filterTableByCustomer.value.isEmpty || monitor.supplierName == filterTableByCustomer.value) &&
        (filterTableByProduct.value.isEmpty || monitor.partName == (filterTableByProduct.value))
      ).toList();
    } finally {
    }
  }
}
