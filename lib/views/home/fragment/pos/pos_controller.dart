import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/models/dao/transaction.dart';
import 'package:xhalona_pos/models/dto/transaction.dart';
import 'package:xhalona_pos/repositories/crystal_report/transaction_crystal_report_repository.dart';
import 'package:xhalona_pos/repositories/product/product_repository.dart';
import 'package:xhalona_pos/repositories/employee/employee_repository.dart';
import 'package:xhalona_pos/repositories/transaction/transaction_repository.dart';

class PosController extends GetxController {
  final TransactionRepository _transactionRepository = TransactionRepository();
  final ProductRepository _productRepository = ProductRepository();

  var products = <ProductDAO>[].obs;
  var isLoading = true.obs;

  var isOpenTransaksi = false.obs;

  var productFilterValue = "".obs;

  var currentTransactionId = "".obs;

  var currentTransaction = <TransactionHeaderDAO>[].obs;
  var currentTransactionDetail = <TransactionDetailDAO>[].obs;
  var selectedProductPartIdToTrx = "".obs;

  var isAddingProductToTrx= false.obs;
  var isDeletingProductFromTrx = false.obs;
  
  Timer? _debounce;

  void updateProductFilterValue(String newFilterValue) {
    if (_debounce?.isActive ?? false) _debounce!.cancel(); 

    _debounce = Timer(const Duration(seconds: 1), () {
      productFilterValue.value = newFilterValue; 
      fetchProducts(); 
    });
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final result = await _productRepository.getProducts(
        pageRow: 24,
        isActive: "1",
        filterValue: productFilterValue.value
      );
      products.value = result;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProductToTrx(ProductDAO product) async {
    selectedProductPartIdToTrx.value = product.partId;
    isAddingProductToTrx.value = true;
    if(currentTransactionId.value == ""){
      currentTransactionId.value = await _transactionRepository.addTransactionHeader(
        TransactionDTO()
      );
    }
    await _transactionRepository.addTransactionDetail(
        [
          TransactionDetailDTO(
          salesId: /*'AM0000001443'*/ currentTransactionId.value,
          partId: product.partId,
          qty: 1,
          price: product.unitPriceNet
        )]
    );
    currentTransaction.value = await _transactionRepository.getTransactionHeader(transactionId: currentTransactionId.value);
    currentTransactionDetail.value = await _transactionRepository.getTransactionDetail(transactionId: currentTransactionId.value);
    isAddingProductToTrx.value = false;
    selectedProductPartIdToTrx.value = "";
  }

  Future<void> deleteProductFromTrx(String rowId) async {
    isDeletingProductFromTrx.value = true;
    await _transactionRepository.deleteTransactionDetail(salesId: currentTransactionId.value, rowId: rowId);
    currentTransaction.value = await _transactionRepository.getTransactionHeader(transactionId: currentTransactionId.value);
    currentTransactionDetail.value = await _transactionRepository.getTransactionDetail(transactionId: currentTransactionId.value);
    isDeletingProductFromTrx.value = false;
  }

  Future<void> editTerapisOfTrx(String rowId, String employeeId) async {
    await _transactionRepository.editEmployeeTransactionDetail(
      salesId: currentTransactionId.value, 
      rowId: rowId,
      employeeId: employeeId
    );
    currentTransactionDetail.value = await _transactionRepository.getTransactionDetail(transactionId: currentTransactionId.value);
  }

  Future<String> printNota() async {
    return await TransactionCrystalReportRepository().printNota(salesId: currentTransactionId.value);
  }
}