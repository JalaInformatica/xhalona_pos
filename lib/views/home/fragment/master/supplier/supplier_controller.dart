import 'package:get/get.dart';
import 'package:xhalona_pos/models/response/kustomer.dart';
import 'package:xhalona_pos/repositories/kustomer/kustomer_repository.dart';

enum FilterCompliment {ALL, TRUE, FALSE}
enum FilterDebt {ALL, TRUE, FALSE}

class SupplierController extends GetxController {
  KustomerRepository _kustomerRepository = KustomerRepository();

  var kustomerHeader = <KustomerDAO>[].obs;
  var isLoading = true.obs;
  // var trxStatusCategory = ProductStatusCategory.progress.obs;
  var isActive = false.obs;
  var filterValue = "".obs;
  var isSuplier = "".obs;

  var pageNo = 1.obs;
  var pageRow = 10.obs;

  var filterCompliment = FilterCompliment.ALL.obs;
  var filterDebt = FilterDebt.ALL.obs;
  var isFilteredDialog = false.obs;

  List<String> filter = ["","1","0"];

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

  void updateFilterDialog({
    required FilterCompliment newFilterCompliment,
    required FilterDebt newFilterDebt
  }) async {
    filterCompliment.value = newFilterCompliment;
    filterDebt.value = newFilterDebt;
    fetchProducts();
  }

  // void updateFilterTrxStatusCategory(ProductStatusCategory newStatusCategory) async {
  //   if(trxStatusCategory.value!=newStatusCategory){
  //     trxStatusCategory.value = newStatusCategory;
  //     pageNo.value = 1;
  //     pageRow.value = 10;
  //     fetchProducts();
  //   }
  // }

  Future<void> updateTypeValue(String newFilterValue) async {
    kustomerHeader.value = await _kustomerRepository.getKustomer(
        pageRow: 5, filterValue: newFilterValue, isSuplier: '1');
  }

  Future<void> updateFilterValue(String newFilterValue) async {
    filterValue.value = newFilterValue;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchProducts();
  }

  void updateMonitorValue(String newFilterValue) {
    isSuplier.value = '';
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
      final result = await _kustomerRepository.getKustomer(
          // statusCategory: getProductStatusCategoryStr(trxStatusCategory.value),
          isActive: '${isActive.value ? '1' : ''}',
          filterValue: filterValue.value,
          pageNo: pageNo.value,
          pageRow: pageRow.value,
          isSuplier: isSuplier.value,
          isCompliment: filter[filterCompliment.value.index],
          isPayable: filter[filterDebt.value.index]
          );
      kustomerHeader.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}
