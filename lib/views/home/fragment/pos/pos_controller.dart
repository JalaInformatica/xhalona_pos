import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/repositories/product/product_repository.dart';

class PosController extends GetxController {
  var products = <ProductDAO>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final result = await ProductRepository().getProducts(
        pageRow: 24,
        isActive: '1',
      );
      products.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}
