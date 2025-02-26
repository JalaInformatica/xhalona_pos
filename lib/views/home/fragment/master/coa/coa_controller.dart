import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/coa.dart';
import 'package:xhalona_pos/repositories/coa/coa_repository.dart';

class CoaController extends GetxController {
  CoaRepository _coaRepository = CoaRepository();

  var coaHeader = <CoaDAO>[].obs;
  var isLoading = true.obs;
  // var trxStatusCategory = ProductStatusCategory.progress.obs;
  var isActive = false.obs;
  var filterValue = "".obs;
  var isSuplier = "".obs;

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

  // void updateFilterTrxStatusCategory(ProductStatusCategory newStatusCategory) async {
  //   if(trxStatusCategory.value!=newStatusCategory){
  //     trxStatusCategory.value = newStatusCategory;
  //     pageNo.value = 1;
  //     pageRow.value = 10;
  //     fetchProducts();
  //   }
  // }

  Future<void> updateFilterValue(String newFilterValue) async {
    coaHeader.value =
        await _coaRepository.getCoa(pageRow: 5, filterValue: newFilterValue);
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
      final result = await _coaRepository.getCoa(
        // statusCategory: getProductStatusCategoryStr(trxStatusCategory.value),
        isActive: '${isActive.value ? '1' : ''}',
        filterValue: filterValue.value,
        pageNo: pageNo.value,
        pageRow: pageRow.value,
      );
      coaHeader.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}
