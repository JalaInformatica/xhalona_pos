import 'package:get/get.dart';
import 'package:xhalona_pos/models/response/departemen.dart';
import 'package:xhalona_pos/repositories/departemen/depertemen_repository.dart';

class DepartemenController extends GetxController {
  DepartemenRepository _deptRepository = DepartemenRepository();

  var departemenHeader = <DepartemenDAO>[].obs;
  var isLoading = true.obs;
  // var trxStatusCategory = ProductStatusCategory.progress.obs;
  var isActive = false.obs;
  var filterValue = "".obs;

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

  Future<void> updateTypeValue(String newFilterValue) async {
    departemenHeader.value = await _deptRepository.getDepartemen(
        pageNo: 1, pageRow: 5, filterValue: newFilterValue);
  }

  Future<void> updateFilterValue(String newFilterValue) async {
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
      final result = await _deptRepository.getDepartemen(
          // statusCategory: getProductStatusCategoryStr(trxStatusCategory.value),
          isActive: '${isActive.value ? '1' : ''}',
          filterValue: filterValue.value,
          pageNo: pageNo.value,
          pageRow: pageRow.value);
      departemenHeader.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}
