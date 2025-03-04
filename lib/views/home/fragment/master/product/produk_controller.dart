import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/repositories/product/product_repository.dart';

class ProductController extends GetxController {
  ProductRepository _productRepository = ProductRepository();

  var productHeader = <ProductDAO>[].obs;
  var isLoading = true.obs;
  // var trxStatusCategory = ProductStatusCategory.progress.obs;
  var isActive = false.obs;
  var isJasa = false.obs;
  var isPublish = false.obs;
  var isStock = false.obs;
  var isPaket = false.obs;
  var isPromo = false.obs;
  var isBahan = false.obs;
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

  Future<void> updateTypeValue(String newFilterValue) async {
    productHeader.value = await _productRepository.getProducts(
        pageRow: 5, filterValue: newFilterValue);
  }

  void updateFilterJasa() async {
    isJasa.value = !isJasa.value;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchProducts();
  }

  void updateFilterPublish() async {
    isPublish.value = !isPublish.value;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchProducts();
  }

  void updateFilterStock() async {
    isStock.value = !isStock.value;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchProducts();
  }

  void updateFilterPromo() async {
    isPromo.value = !isPromo.value;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchProducts();
  }

  void updateFilterPaket() async {
    isPaket.value = !isPaket.value;
    pageNo.value = 1;
    pageRow.value = 10;
    fetchProducts();
  }

  void updateFilterBahan() async {
    isBahan.value = !isBahan.value;
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
      final result = await _productRepository.getProducts(
          // statusCategory: getProductStatusCategoryStr(trxStatusCategory.value),
          isActive: '${isActive.value ? '1' : ''}',
          isFixQty: '${isJasa.value ? '1' : ''}',
          isNonSales: '${isBahan.value ? '1' : ''}',
          isPacket: '${isPaket.value ? '1' : ''}',
          isPromo: '${isPromo.value ? '1' : ''}',
          isStock: '${isStock.value ? '1' : ''}',
          isPublish: '${isPublish.value ? '1' : ''}',
          analisaId: '',
          analisaIdGlobal: '',
          filterValue: filterValue.value,
          partId: '',
          pageNo: pageNo.value,
          pageRow: pageRow.value);
      productHeader.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}
