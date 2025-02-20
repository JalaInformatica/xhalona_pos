import 'dart:async';
import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/models/dao/transaction.dart';
import 'package:xhalona_pos/models/dto/tamu.dart';
import 'package:xhalona_pos/models/dto/transaction.dart';
import 'package:xhalona_pos/repositories/product/product_repository.dart';
import 'package:xhalona_pos/repositories/transaction/transaction_repository.dart';
import 'package:xhalona_pos/repositories/crystal_report/transaction_crystal_report_repository.dart';

class PosController extends GetxController {
  final TransactionRepository _transactionRepository = TransactionRepository();
  final ProductRepository _productRepository = ProductRepository();

  var products = <ProductDAO>[].obs;
  var isLoading = true.obs;

  var isOpenTransaksi = false.obs;

  var productFilterValue = "".obs;
  var productFilterCategory = "".obs;

  var currentTransactionId = "".obs;

  var currentTransaction = TransactionHeaderDAO().obs;
  var currentShiftId = "".obs;
  var currentTransactionDetail = <TransactionDetailDAO>[].obs;
  var selectedProductPartIdToTrx = "".obs;

  var isAddingProductToTrx = false.obs;
  var isDeletingProductFromTrx = false.obs;

  var showError = false.obs;

  var isNoteVisible = <String, bool>{}.obs;
  void toggleNoteVisible(String rowId) {
    isNoteVisible[rowId] = !(isNoteVisible[rowId] ?? false);
  }

  Timer? _debounceProduk;
  Timer? _debounceDiscount;
  Timer? _debounceNote;

  void updateProductFilterValue(String newFilterValue) {
    if (_debounceProduk?.isActive ?? false) _debounceProduk!.cancel();

    _debounceProduk = Timer(const Duration(seconds: 1), () {
      productFilterValue.value = newFilterValue;
      fetchProducts();
    });
  }

  void updateProductFilterKategori(String newFilterKategori) {
    productFilterCategory.value = newFilterKategori;
    fetchProducts();
  }

  void updateProductDiscount(TransactionDetailDAO trxDetail) {
    if (_debounceDiscount?.isActive ?? false) _debounceDiscount!.cancel();

    _debounceDiscount = Timer(const Duration(seconds: 1), () async {
      await _transactionRepository.editTransactionDetail(
       TransactionDetailDTO(
        rowId: trxDetail.rowId,
        salesId: trxDetail.salesId,
        partId: trxDetail.partId,
        qty: trxDetail.qty,
        isFreePick: trxDetail.isFreePick? 1 : 0,
        deductionPct: trxDetail.deductionPct,
        deductionVal: trxDetail.deductionVal,
        addCostPct: trxDetail.addCostPct,
        addCostVal: trxDetail.addCostVal,
        employeeId: trxDetail.employeeId,
        employeeId2: trxDetail.employeeId2,
        employeeId3: trxDetail.employeeId3,
        employeeId4: trxDetail.employeeId4,
        price: trxDetail.price,
        detNote: trxDetail.detNote
       ) 
      );
      currentTransaction.value = (await _transactionRepository
        .getTransactionHeader(transactionId: currentTransactionId.value)).first;
    });
  }

  void updateProductNote(TransactionDetailDAO trxDetail) {
    if (_debounceNote?.isActive ?? false) _debounceNote!.cancel();

    _debounceNote = Timer(const Duration(seconds: 3), () async {
      await _transactionRepository.editTransactionDetail(
       TransactionDetailDTO(
        rowId: trxDetail.rowId,
        salesId: trxDetail.salesId,
        partId: trxDetail.partId,
        qty: trxDetail.qty,
        isFreePick: trxDetail.isFreePick? 1 : 0,
        deductionPct: trxDetail.deductionPct,
        deductionVal: trxDetail.deductionVal,
        addCostPct: trxDetail.addCostPct,
        addCostVal: trxDetail.addCostVal,
        employeeId: trxDetail.employeeId,
        employeeId2: trxDetail.employeeId2,
        employeeId3: trxDetail.employeeId3,
        employeeId4: trxDetail.employeeId4,
        price: trxDetail.price,
        detNote: trxDetail.detNote
       ) 
      );
      currentTransaction.value = (await _transactionRepository
        .getTransactionHeader(transactionId: currentTransactionId.value)).first;
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
          filterField: "PART_NAME", 
          filterValue: productFilterValue.value,
          analisaId: productFilterCategory.value
      );
      products.value = result;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reinitTransaction(TransactionHeaderDAO transaction) async {
    currentTransactionId.value = transaction.salesId;
    currentTransaction.value = transaction;
    currentTransactionDetail.value = await _transactionRepository
        .getTransactionDetail(transactionId: currentTransactionId.value);
    showError.value = false;
  }

  Future<void> newTransaction() async {
    currentTransactionId.value = "";
    currentTransaction.value = TransactionHeaderDAO();
    currentTransactionDetail.value = [];
    showError.value = false;
  }

  Future<void> cancelTransaction() async {
    String trxId = await _transactionRepository.deleteTransactionHeader(currentTransactionId.value);
    if(trxId.isNotEmpty){
      newTransaction();      
    }
  }

  Future<void> addProductToTrx(ProductDAO product) async {
    selectedProductPartIdToTrx.value = product.partId;
    isAddingProductToTrx.value = true;
    if (currentTransactionId.value == "") {
      currentTransactionId.value =
          await _transactionRepository.addTransactionHeader(TransactionDTO());
      if(currentShiftId.value.isNotEmpty){
        editShiftTrx();
      }
    }
    await _transactionRepository.addTransactionDetail([
      TransactionDetailDTO(
          salesId: /*'AM0000001443'*/ currentTransactionId.value,
          partId: product.partId,
          qty: 1,
          price: product.unitPriceNet)
    ]);
    currentTransaction.value = (await _transactionRepository
        .getTransactionHeader(transactionId: currentTransactionId.value)).first;
    currentTransactionDetail.value = await _transactionRepository
        .getTransactionDetail(transactionId: currentTransactionId.value);
    isAddingProductToTrx.value = false;
    selectedProductPartIdToTrx.value = "";
  }

  Future<void> setCurrentShift(String shiftId) async {
    currentShiftId.value = shiftId;
    if(currentTransactionId.isNotEmpty){
      editShiftTrx();
    }
  }

  Future<void> editShiftTrx() async{
    var currentTrxValue = currentTransaction.value;
    await _transactionRepository.editTransactionHeader(
      TransactionDTO(
        salesId: currentTransactionId.value,
        supplierId: currentTrxValue.supplierId,
        guestName: currentTrxValue.guestName,
        guestPhone: currentTrxValue.guestPhone,
        note: currentTrxValue.note,
        voucherCode: "",
        shiftId: currentShiftId.value
      )
    );
    currentTransaction.value = (await _transactionRepository
      .getTransactionHeader(transactionId: currentTransactionId.value)).first;
  }

  Future<void> addTamuToTrx(TamuDTO tamuDTO ) async{
    var currentTrxValue = currentTransaction.value;
    await _transactionRepository.editTransactionHeader(
      TransactionDTO(
        salesId: currentTrxValue.salesId,
        supplierId: tamuDTO.guestPhone,
        guestName: tamuDTO.guestName,
        guestPhone: tamuDTO.guestPhone,
        note: currentTrxValue.note,
        voucherCode: "",
        shiftId: currentTrxValue.shiftId
      )
    );
    currentTransaction.value = (await _transactionRepository
        .getTransactionHeader(transactionId: currentTransactionId.value)).first;
  }

  Future<void> addMemberToTrx(KustomerDAO tamuDAO ) async{
    var currentTrxValue = currentTransaction.value;
    await _transactionRepository.editTransactionHeader(
      TransactionDTO(
        salesId: currentTrxValue.salesId,
        supplierId: tamuDAO.suplierId,
        guestName: tamuDAO.suplierName,
        guestPhone: tamuDAO.telp,
        note: currentTrxValue.note,
        voucherCode: "",
        shiftId: currentTrxValue.shiftId
      )
    );
    currentTransaction.value = (await _transactionRepository
        .getTransactionHeader(transactionId: currentTransactionId.value)).first;
  }

  Future<void> deleteProductFromTrx(String rowId) async {
    isDeletingProductFromTrx.value = true;
    await _transactionRepository.deleteTransactionDetail(
        salesId: currentTransactionId.value, rowId: rowId);
    currentTransaction.value = (await _transactionRepository
        .getTransactionHeader(transactionId: currentTransactionId.value)).first;
    currentTransactionDetail.value = await _transactionRepository
        .getTransactionDetail(transactionId: currentTransactionId.value);
    isDeletingProductFromTrx.value = false;
  }

  Future<void> editTerapisOfTrx(String rowId, String employeeId) async {
    await _transactionRepository.editEmployeeTransactionDetail(
        salesId: currentTransactionId.value,
        rowId: rowId,
        employeeId: employeeId);
    currentTransactionDetail.value = await _transactionRepository
        .getTransactionDetail(transactionId: currentTransactionId.value);
  }

  Future<String> printNota() async {
    return await TransactionCrystalReportRepository()
        .printNota(salesId: currentTransactionId.value);
  }
}
