import 'package:get/get.dart';
import 'package:xhalona_pos/models/response/paket.dart';
import 'package:xhalona_pos/repositories/paket_repository.dart';

class PaketController extends GetxController {
  PaketRepository _paketRepository = PaketRepository();

  var paketHeader = <PaketDAO>[].obs;
  var isLoading = true.obs;
  // var trxStatusCategory = ProductStatusCategory.progress.obs;
  var isActive = false.obs;
  var filterValue = "".obs;
  var filterPartId = "".obs;

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
      final result = await _paketRepository.getPaket(
          // statusCategory: getProductStatusCategoryStr(trxStatusCategory.value),
          filterPartId: filterPartId.value,
          isActive: '${isActive.value ? '1' : ''}',
          filterValue: filterValue.value,
          pageNo: pageNo.value,
          pageRow: pageRow.value);
      paketHeader.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}
