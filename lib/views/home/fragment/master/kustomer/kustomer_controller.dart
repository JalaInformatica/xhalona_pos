import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/repositories/kustomer/kustomer_repository.dart';

enum FilterCompliment {ALL, TRUE, FALSE}
enum FilterDebt {ALL, TRUE, FALSE}

class KustomerController extends GetxController {
  KustomerRepository _kustomerRepository = KustomerRepository();

  var kustomerHeader = <KustomerDAO>[].obs;
  var isLoading = true.obs;
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
    fetchKustomers();
  }

  void updateFilterActive() async {
    isActive.value = !isActive.value;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchKustomers();
  }

  void updateFilterDialog({
    required FilterCompliment newFilterCompliment,
    required FilterDebt newFilterDebt
  }) async {
    filterCompliment.value = newFilterCompliment;
    filterDebt.value = newFilterDebt;
    fetchKustomers();
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
    fetchKustomers();
  }

  void updateMonitorValue(String newFilterValue) {
    isSuplier.value = '';
    filterValue.value = newFilterValue;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchKustomers();
  }

  void updatePageNo(int newFilterValue) {
    pageNo.value = newFilterValue;
    fetchKustomers();
  }

  void updatePageRow(int newFilterValue) {
    pageRow.value = newFilterValue;
    fetchKustomers();
  }

  Future<void> fetchKustomers() async {
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

  Future<void> deleteKustomer(String supplierId) async{
    await _kustomerRepository.deleteKustomer(
      suplierId: supplierId
    );
  }
}
