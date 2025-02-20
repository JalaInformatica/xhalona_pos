import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/transaction.dart';
import 'package:xhalona_pos/core/constant/transaction.dart';
import 'package:xhalona_pos/repositories/transaction/transaction_repository.dart';

class TransactionController extends GetxController {
  TransactionRepository _transactionRepository = TransactionRepository();

  var transactionHeader = <TransactionHeaderDAO>[].obs;
  var transactionDetail = <TransactionDetailDAO>[].obs;
  var isLoading = true.obs;
  var trxStatusCategory = TransactionStatusCategory.progress.obs;
  var isOnline = false.obs;
  var filterValue = "".obs;
  var salesId = "".obs;
  RxDouble sumTrx = 0.0.obs;

  DateTime dateNow = DateTime.now();
  late RxInt filterDay = dateNow.day.obs;
  late RxInt filterMonth = dateNow.month.obs;
  late RxInt filterYear = dateNow.year.obs;

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

  void updateFilterTrxDate(DateTime selectedDay) {
    filterYear.value = selectedDay.year;
    filterMonth.value = selectedDay.month;
    filterDay.value = selectedDay.day;
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
      isLoading.value = true;
      final result = await _transactionRepository.getTransactionHeader(
          statusCategory:
              getTransactionStatusCategoryStr(trxStatusCategory.value),
          sourceId: isOnline.value ? "ONLINE" : "",
          filterDay: filterDay.value,
          filterMonth: filterMonth.value,
          filterYear: filterYear.value,
          filterValue: filterValue.value,
          pageNo: pageNo.value,
          pageRow: pageRow.value);
      transactionHeader.value = result;
      sumTrx.value =
          result.fold(0.0, (sum, item) => sum + (item.nettoVal ?? 0.0));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchGetDetailTransactions() async {
    try {
      isLoading.value = true;
      final result = await _transactionRepository.getTransactionDetail(
        transactionId: salesId.value,
      );
      transactionDetail.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}
