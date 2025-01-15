import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/product/product_service.dart';

class ProductRepository extends AppRepository {
  ProductService _productService = ProductService();

  Future<List<ProductDAO>> getProducts({
    int? pageNo,
    int? pageRow,
    String? isActive,
    String? isStock,
    String? isPacket,
    String? isFixQty,
    String? isNonSales,
    String? isPromo,
    String? analisaIdGlobal,
    String? analisaId,
    String? partId,
    String? filterField,
    String? filterValue
    String? filterValue,
  }) async {
    var result = await _productService.getProducts(
        pageNo: pageNo,
        pageRow: pageRow,
        isActive: isActive,
        isStock: isStock,
        isPacket: isPacket,
        isFixQty: isFixQty,
        isNonSales: isNonSales,
        isPromo: isPromo,
        analisaId: analisaId,
        analisaIdGlobal: analisaIdGlobal,
        partId: partId,
      filterField: filterField,
      filterValue: filterValue,,
        filterValue: filterValue);
    List data = getResponseListData(result);
    return data.map((product) => ProductDAO.fromJson(product)).toList();
  }
}
