import 'package:get/get.dart';
import 'package:xhalona_pos/models/response/varian.dart';
import 'package:xhalona_pos/repositories/varian/varianGroup_repository.dart';

class VarianGroupController extends GetxController {
  VarianGroupRepository _kategoriRepository = VarianGroupRepository();

  var kategoriHeader = <VarianDAO>[].obs;
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

  void updateFilterValue(String newFilterValue) {
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
      final result = await _kategoriRepository.getVarianGroup(
          // statusCategory: getProductStatusCategoryStr(trxStatusCategory.value),
          isActive: '${isActive.value ? '1' : ''}',
          filterValue: filterValue.value,
          pageNo: pageNo.value,
          pageRow: pageRow.value);
      kategoriHeader.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}
