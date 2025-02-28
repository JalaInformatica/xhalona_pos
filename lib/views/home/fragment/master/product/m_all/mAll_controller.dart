import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/masterall.dart';
import 'package:xhalona_pos/repositories/m_all/mAll_repository.dart';

class MasAllController extends GetxController {
  MasAllRepository _masAllRepository = MasAllRepository();

  var masAllHeader = <MasAllDAO>[].obs;
  var isLoading = true.obs;
  // var trxStatusCategory = ProductStatusCategory.progress.obs;
  var isActive = false.obs;
  var filterValue = "".obs;
  var group = "".obs;

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

  void updateFilterValue(String newFilterValue) {
    filterValue.value = newFilterValue;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchProducts();
  }

  void updateGroupMasterId(String newGroup) {
    group.value = newGroup;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchProducts();
  }

  Future<void> updateTypeValue(String newFilterValue) async {
    masAllHeader.value = await _masAllRepository.getMasAll(
        pageRow: 5, filterValue: newFilterValue);
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
      final result = await _masAllRepository.getMasAll(
          // statusCategory: getProductStatusCategoryStr(trxStatusCategory.value),
          isActive: '${isActive.value ? '1' : ''}',
          filterValue: filterValue.value,
          group: group.value,
          pageNo: pageNo.value,
          pageRow: pageRow.value);
      masAllHeader.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}
