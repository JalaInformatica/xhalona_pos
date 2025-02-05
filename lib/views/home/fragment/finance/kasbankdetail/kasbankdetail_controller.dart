import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/kasbankdetail.dart';
import 'package:xhalona_pos/repositories/kasbank/kasbankdetail_repository.dart';

class KasBankDetailController extends GetxController {
  KasBankDetailRepository _kbdetailRepository = KasBankDetailRepository();

  var kbdetailHeader = <KasBankDetailDAO>[].obs;
  var isLoading = true.obs;
  // var trxStatusCategory = ProductStatusCategory.progress.obs;
  var isActive = false.obs;
  var filterValue = "".obs;
  var vocherNo = "".obs;

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
      final result = await _kbdetailRepository.getKasBankDetail(
        // statusCategory: getProductStatusCategoryStr(trxStatusCategory.value),
        vocherNo: vocherNo.value,
      );
      kbdetailHeader.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}
