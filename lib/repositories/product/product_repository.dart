import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/product/product_service.dart';

class ProductRepository extends AppRepository {
  ProductService _productService = ProductService();

  Future<List<ProductDAO>> getProducts(
      {int? pageNo,
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
      String? filterValue}) async {
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
      filterValue: filterValue,
    );
    List data = getResponseListData(result);
    return data.map((product) => ProductDAO.fromJson(product)).toList();
  }

  Future<String> addEditProduct({
    String? partId,
    String? partName,
    String? deskripsi,
    String? actionId,
    String? analisaId,
    String? analisaIdGlobal,
    int? isFixQty,
    int? isFixPrice,
    int? isFree,
    int? isPacket,
    int? isStock,
    String? unit1,
    int? discPct,
    int? discVal,
    int? unitPrice,
    String? isActive,
    int? isPromo,
    String? thumbImage,
    String? mainImage,
  }) async {
    var result = await _productService.addEditProduct(
      partId: partId,
      partName: partName,
      deskripsi: deskripsi,
      analisaId: actionId,
      analisaIdGlobal: analisaIdGlobal,
      isFixQty: isFixQty,
      isFixPrice: isFixPrice,
      isFree: isFree,
      isPacket: isPacket,
      isStock: isStock,
      unit1: unit1,
      discPct: discPct,
      discVal: discVal,
      unitPrice: unitPrice,
      isActive: isActive,
      isPromo: isPromo,
      mainImage: mainImage,
      thumbImage: thumbImage,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => ProductDAO.fromJson(dept)).first.partId;
  }

  Future<String> deleteProduct({
    String? partId,
  }) async {
    var result = await _productService.deleteProduct(
      partId: partId,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => ProductDAO.fromJson(dept)).first.partId;
  }
}
