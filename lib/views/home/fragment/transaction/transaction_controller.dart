import 'package:get/get.dart';
import 'package:xhalona_pos/globals/transaction/models/transaction_response.dart';
import 'package:xhalona_pos/core/constant/transaction.dart';
import 'package:xhalona_pos/globals/crystal_report/transaction_crystal_report_repository.dart';
import 'package:xhalona_pos/globals/transaction/repositories/transaction_repository.dart';

enum DateType {DATE, MONTH, NONE}

class TransactionController extends GetxController {
  TransactionRepository _transactionRepository = TransactionRepository();

  var transactionHeader = <TransactionResponse>[].obs;
  var transactionDetail = <TransactionDetailResponse>[].obs;
  var isLoading = true.obs;
  var trxStatusCategory = TransactionStatusCategory.progress.obs;
  var isOnline = false.obs;
  var filterValue = "".obs;
  var salesId = "".obs;
  RxInt sumNetto = 0.obs;
  RxInt sumPayment = 0.obs;
  RxInt sumDebt = 0.obs;

  var filterDateType = DateType.DATE.obs;
  // DateType get dateType => _dateType.value;
  // set dateType(DateType dateType){
  //   _dateType.value = dateType;

  // }


  DateTime dateNow = DateTime.now();
  late RxnInt filterDay = RxnInt(dateNow.day);
  late RxnInt filterMonth = RxnInt(dateNow.month);
  late RxnInt filterYear = RxnInt(dateNow.year);
  var isDateFilterChanged = true.obs;

  var pageNo = 1.obs;
  var pageRow = 10.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
    fetchGetDetailTransactions();
  }

  void updateFilterTrxOnline() async {
    isOnline.value = !isOnline.value;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchTransactions();
  }

  void updateFilterTrxStatusCategory(
      TransactionStatusCategory newStatusCategory) async {
    if (trxStatusCategory.value != newStatusCategory) {
      trxStatusCategory.value = newStatusCategory;
      pageNo.value = 1;
      pageRow.value = 10;
      fetchTransactions();
    }
  }

  void updateFilterTrxDate({
    required DateType dateType, 
    int? day, int? month, int? year
    }) {
    filterDateType.value = dateType;
    filterYear.value = year;
    filterMonth.value = month;
    filterDay.value = day;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchTransactions();
  }

  void updateFilterTrxNone() {
    filterYear.value = null;
    filterMonth.value = null;
    filterDay.value = null;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchTransactions();
  }

  void updateFilterValue(String newFilterValue) {
    filterValue.value = newFilterValue;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchTransactions();
  }

  void updateTrxDetail(String newFilterValue) {
    salesId.value = newFilterValue;
    fetchGetDetailTransactions();
  }

  void updatePageNo(int newFilterValue) {
    pageNo.value = newFilterValue;
    fetchTransactions();
  }

  void updatePageRow(int newFilterValue) {
    pageRow.value = newFilterValue;
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      // isLoading.value = true;
      // final result = await _transactionRepository.getTransactionHeader(
      //     statusCategory:
      //         getTransactionStatusCategoryStr(trxStatusCategory.value),
      //     sourceId: isOnline.value ? "ONLINE" : "",
      //     filterDay: filterDay.value,
      //     filterMonth: filterMonth.value,
      //     filterYear: filterYear.value,
      //     filterValue: filterValue.value,
      //     pageNo: pageNo.value,
      //     pageRow: pageRow.value);
      // transactionHeader.value = result;
      // sumNetto.value = result.fold(0, (sum, item) => sum + (item.nettoVal));
      // sumPayment.value = result.fold(0, (sum, item) => sum + (item.paymentVal));
      // sumDebt.value = result.fold(0, (sum, item) => sum + (item.totalHutang));
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> printNota(String salesId) async {
    return await TransactionCrystalReportRepository()
        .printNota(salesId: salesId);
  }

  Future<void> fetchGetDetailTransactions() async {
    // try {
    //   isLoading.value = true;
    //   final result = await _transactionRepository.getTransactionDetail(
    //     transactionId: salesId.value,
    //   );
    //   transactionDetail.value = result;
    // } finally {
    //   isLoading.value = false;
    // }
  }
}
