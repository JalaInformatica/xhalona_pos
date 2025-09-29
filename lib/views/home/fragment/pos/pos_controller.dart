// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:pdf/pdf.dart';
// import 'package:xhalona_pos/models/response/kustomer.dart';
// import 'package:xhalona_pos/globals/product/models/product.dart';
// import 'package:xhalona_pos/globals/transaction/models/transaction_response.dart';
// import 'package:xhalona_pos/models/dto/tamu.dart';
// import 'package:xhalona_pos/models/dto/transaction.dart';
// import 'package:xhalona_pos/globals/product/repositories/product_repository.dart';
// import 'package:xhalona_pos/globals/transaction/repositories/transaction_repository.dart';
// import 'package:xhalona_pos/repositories/crystal_report/transaction_crystal_report_repository.dart';
// import 'package:pdf/widgets.dart' as pw;

// class PosController extends GetxController {
//   final TransactionRepository _transactionRepository = TransactionRepository();
//   final ProductRepository _productRepository = ProductRepository();

//   var products = <ProductDAO>[].obs;
//   var isLoading = true.obs;

//   var isOpenTransaksi = false.obs;

//   var productFilterValue = "".obs;
//   var productFilterCategory = "".obs;

//   var currentTransactionId = "".obs;

//   var currentTransaction = TransactionResponse().obs;
//   var currentShiftId = "".obs;
//   var currentTransactionDetail = <TransactionDetailResponse>[].obs;
//   var selectedProductPartIdToTrx = "".obs;

//   var isAddingProductToTrx = false.obs;
//   var isDeletingProductFromTrx = false.obs;

//   var showError = false.obs;

//   var isNoteVisible = <String, bool>{}.obs;
//   void toggleNoteVisible(String rowId) {
//     isNoteVisible[rowId] = !(isNoteVisible[rowId] ?? false);
//   }

//   Timer? _debounceProduk;
//   Timer? _debounceDiscount;
//   Timer? _debounceNote;

//   void updateProductFilterValue(String newFilterValue) {
//     if (_debounceProduk?.isActive ?? false) _debounceProduk!.cancel();

//     _debounceProduk = Timer(const Duration(seconds: 1), () {
//       productFilterValue.value = newFilterValue;
//       fetchProducts();
//     });
//   }

//   void updateProductFilterKategori(String newFilterKategori) {
//     productFilterCategory.value = newFilterKategori;
//     fetchProducts();
//   }

//   void updateProductDiscount(TransactionDetailResponse trxDetail) {
//     if (_debounceDiscount?.isActive ?? false) _debounceDiscount!.cancel();

//     // _debounceDiscount = Timer(const Duration(seconds: 1), () async {
//     //   await _transactionRepository.editTransactionDetail(TransactionDetailDTO(
//     //       rowId: trxDetail.rowId,
//     //       salesId: trxDetail.salesId,
//     //       partId: trxDetail.partId,
//     //       qty: trxDetail.qty,
//     //       isFreePick: trxDetail.isFreePick ? 1 : 0,
//     //       deductionPct: trxDetail.deductionPct,
//     //       deductionVal: trxDetail.deductionVal,
//     //       addCostPct: trxDetail.addCostPct,
//     //       addCostVal: trxDetail.addCostVal,
//     //       employeeId: trxDetail.employeeId,
//     //       employeeId2: trxDetail.employeeId2,
//     //       employeeId3: trxDetail.employeeId3,
//     //       employeeId4: trxDetail.employeeId4,
//     //       price: trxDetail.price,
//     //       detNote: trxDetail.detNote));
//     //   currentTransaction.value = (await _transactionRepository
//     //           .getTransactionHeader(transactionId: currentTransactionId.value))
//     //       .first;
//     // });
//   }

//   void updateProductNote(TransactionDetailResponse trxDetail) {
//     if (_debounceNote?.isActive ?? false) _debounceNote!.cancel();

//     // _debounceNote = Timer(const Duration(seconds: 3), () async {
//     //   await _transactionRepository.editTransactionDetail(TransactionDetailDTO(
//     //       rowId: trxDetail.rowId,
//     //       salesId: trxDetail.salesId,
//     //       partId: trxDetail.partId,
//     //       qty: trxDetail.qty,
//     //       isFreePick: trxDetail.isFreePick ? 1 : 0,
//     //       deductionPct: trxDetail.deductionPct,
//     //       deductionVal: trxDetail.deductionVal,
//     //       addCostPct: trxDetail.addCostPct,
//     //       addCostVal: trxDetail.addCostVal,
//     //       employeeId: trxDetail.employeeId,
//     //       employeeId2: trxDetail.employeeId2,
//     //       employeeId3: trxDetail.employeeId3,
//     //       employeeId4: trxDetail.employeeId4,
//     //       price: trxDetail.price,
//     //       detNote: trxDetail.detNote));
//     //   currentTransaction.value = (await _transactionRepository
//     //           .getTransactionHeader(transactionId: currentTransactionId.value))
//     //       .first;
//     // });
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProducts();
//   }

//   Future<void> fetchProducts() async {
//     try {
//       isLoading.value = true;
//       final result = await _productRepository.getProducts(
//           pageRow: 24,
//           isActive: "1",
//           filterField: "PART_NAME",
//           filterValue: productFilterValue.value,
//           analisaId: productFilterCategory.value);
//       products.value = result;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> reinitTransaction(TransactionResponse transaction) async {
//     // currentTransactionId.value = transaction.salesId;
//     // currentTransaction.value = transaction;
//     // currentTransactionDetail.value = await _transactionRepository
//     //     .getTransactionDetail(transactionId: currentTransactionId.value);
//     // showError.value = false;
//   }

//   Future<void> resetTransaction() async {
//     currentTransactionId.value = "";
//     currentTransaction.value = TransactionResponse();
//     currentTransactionDetail.value = [];
//     showError.value = false;
//   }

//   Future<void> cancelTransaction() async {
//     // String trxId = await _transactionRepository
//     //     .deleteTransactionHeader(currentTransactionId.value);
//     // if (trxId.isNotEmpty) {
//     //   resetTransaction();
//     // }
//   }

//   Future<void> newTransaction() async {
//     // currentTransaction.value = TransactionResponse();
//     // currentTransactionDetail.value = [];
//     // currentTransactionId.value =
//     // await _transactionRepository.addTransactionHeader(TransactionDTO());
//     // if (currentShiftId.value.isNotEmpty) {
//     //   editShiftTrx();
//     // }    
//   }

//   Future<pw.Document> generateQueuePDF() async {
//     final fontRegular = pw.Font.ttf(await rootBundle.load("assets/fonts/GoogleSans-Regular.ttf"));
//     final fontBold = pw.Font.ttf(await rootBundle.load("assets/fonts/GoogleSans-Bold.ttf"));

//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.roll57,
//         build: (pw.Context context) {
//           return pw.Column(
//               mainAxisSize: pw.MainAxisSize.min,
//               mainAxisAlignment: pw.MainAxisAlignment.start,
//               crossAxisAlignment: pw.CrossAxisAlignment.center,
//               children: [
//                 pw.Text(
//                   currentTransaction.value.companyName,
//                   style: pw.TextStyle(font: fontRegular, fontSize: 12),
//                 ),
//                 pw.Text(
//                   "Nomor Antrian",
//                   style: pw.TextStyle(font: fontRegular, fontSize: 12),
//                 ),
//                 pw.Text(
//                   currentTransaction.value.queueNumber.toString(),
//                   style: pw.TextStyle(font: fontRegular, fontSize: 24),
//                 ),
//                 pw.Text(
//                   currentTransaction.value.guestName.isEmpty ? currentTransaction.value.supplierName : currentTransaction.value.guestName,
//                   style: pw.TextStyle(font: fontRegular, fontSize: 14),
//                 ),
//                 pw.Table(
//                   // border: pw.TableBorder.all(),
//                   columnWidths: {
//                     0: pw.FlexColumnWidth(2), // No
//                     1: pw.FlexColumnWidth(3), // Produk
//                     2: pw.FlexColumnWidth(3), // Terapis
//                     3: pw.FlexColumnWidth(2), // Paraf
//                   },
//                   children: [
//                     // Table Header
//                     pw.TableRow(
//                       children: [
//                         pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text("No",
//                               style: pw.TextStyle(
//                                   font: fontBold, fontSize: 8)),
//                         ),
//                         pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text("Produk",
//                               style: pw.TextStyle(fontSize: 8,
//                                   font: fontBold)),
//                         ),
//                         pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text("Terapis",
//                               style: pw.TextStyle(fontSize: 8,
//                                   font: fontBold)),
//                         ),
//                         pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text("Paraf",
//                               style: pw.TextStyle(fontSize: 8,
//                                   font: fontBold)),
//                         ),
//                       ],
//                     ),

//                     // Table Rows (Data)
//                     ...List.generate(
//                       currentTransactionDetail.length,
//                       (index) {
//                         TransactionDetailResponse detail =
//                             currentTransactionDetail[index];
//                         return pw.TableRow(
//                           children: [
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(4),
//                               child: pw.Text("${index + 1}",
//                                   style: pw.TextStyle(fontSize: 8,
//                                     font: fontRegular,
//                                   )),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(4),
//                               child: pw.Text(detail.partName,
//                                   style: pw.TextStyle(fontSize: 8,
//                                     font: fontRegular,
//                                   )),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(4),
//                               child: pw.Text(detail.fullName,
//                                   style: pw.TextStyle(fontSize: 8,
//                                     font: fontRegular,
//                                   )),
//                             ),
//                             pw.Container(
//                               decoration: pw.BoxDecoration(
//                                 border: pw.Border(bottom: pw.BorderSide(style: pw.BorderStyle.dotted))
//                               ),
//                               padding: const pw.EdgeInsets.all(4),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//                 pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text("Tambahan :", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, font: fontRegular)),
//                     pw.Container(
//                       padding: pw.EdgeInsets.only(top: 15),
//                       decoration: pw.BoxDecoration(
//                         border: pw.Border(bottom: pw.BorderSide(style: pw.BorderStyle.dotted))
//                       )
//                     ),
//                     pw.Container(
//                       padding: pw.EdgeInsets.only(top: 15),
//                       decoration: pw.BoxDecoration(
//                         border: pw.Border(bottom: pw.BorderSide(style: pw.BorderStyle.dotted))
//                       )
//                     ),
//                   ]
//                 )
//               ]);
//         },
//       ),
//     );
//     return pdf;
//   }

//   Future<void> addProductToTrx(ProductDAO product) async {
//     selectedProductPartIdToTrx.value = product.partId;
//     isAddingProductToTrx.value = true;
//     if (currentTransactionId.value == "") {
//       await newTransaction();
//       if (currentShiftId.value.isNotEmpty) {
//         editShiftTrx();
//       }
//     }
//     await _transactionRepository.addTransactionDetail([
//       TransactionDetailDTO(
//           salesId: /*'AM0000001443'*/ currentTransactionId.value,
//           partId: product.partId,
//           qty: 1,
//           price: product.unitPriceNet)
//     ]);
//     currentTransaction.value = (await _transactionRepository
//             .getTransactionHeader(transactionId: currentTransactionId.value))
//         .first;
//     currentTransactionDetail.value = await _transactionRepository
//         .getTransactionDetail(transactionId: currentTransactionId.value);
//     isAddingProductToTrx.value = false;
//     selectedProductPartIdToTrx.value = "";
//   }

//   Future<void> setCurrentShift(String shiftId) async {
//     currentShiftId.value = shiftId;
//     if (currentTransactionId.isNotEmpty) {
//       editShiftTrx();
//     }
//   }

//   Future<void> editShiftTrx() async {
//     var currentTrxValue = currentTransaction.value;
//     await _transactionRepository.editTransactionHeader(TransactionDTO(
//         salesId: currentTransactionId.value,
//         supplierId: currentTrxValue.supplierId,
//         guestName: currentTrxValue.guestName,
//         guestPhone: currentTrxValue.guestPhone,
//         note: currentTrxValue.note,
//         voucherCode: "",
//         shiftId: currentShiftId.value));
//     currentTransaction.value = (await _transactionRepository
//             .getTransactionHeader(transactionId: currentTransactionId.value))
//         .first;
//   }

//   Future<void> addTamuToTrx(TamuDTO tamuDTO) async {
//     var currentTrxValue = currentTransaction.value;
//     await _transactionRepository.editTransactionHeader(TransactionDTO(
//         salesId: currentTransactionId.value,
//         supplierId: tamuDTO.guestPhone,
//         guestName: tamuDTO.guestName,
//         guestPhone: tamuDTO.guestPhone,
//         note: currentTrxValue.note,
//         voucherCode: "",
//         shiftId: currentTrxValue.shiftId));
//     currentTransaction.value = (await _transactionRepository
//             .getTransactionHeader(transactionId: currentTransactionId.value))
//         .first;
//   }

//   Future<void> addMemberToTrx(KustomerDAO tamuDAO) async {
//     var currentTrxValue = currentTransaction.value;
//     await _transactionRepository.editTransactionHeader(TransactionDTO(
//         salesId: currentTransactionId.value,
//         supplierId: tamuDAO.suplierId,
//         guestName: tamuDAO.suplierName,
//         guestPhone: tamuDAO.telp,
//         note: currentTrxValue.note,
//         voucherCode: "",
//         shiftId: currentTrxValue.shiftId));
//     currentTransaction.value = (await _transactionRepository
//             .getTransactionHeader(transactionId: currentTransactionId.value))
//         .first;
//   }

//   Future<void> deleteProductFromTrx(String rowId) async {
//     isDeletingProductFromTrx.value = true;
//     await _transactionRepository.deleteTransactionDetail(
//         salesId: currentTransactionId.value, rowId: rowId);
//     currentTransaction.value = (await _transactionRepository
//             .getTransactionHeader(transactionId: currentTransactionId.value))
//         .first;
//     currentTransactionDetail.value = await _transactionRepository
//         .getTransactionDetail(transactionId: currentTransactionId.value);
//     isDeletingProductFromTrx.value = false;
//   }

//   Future<void> editTerapisOfTrx(String rowId, String employeeId) async {
//     await _transactionRepository.editEmployeeTransactionDetail(
//         salesId: currentTransactionId.value,
//         rowId: rowId,
//         employeeId: employeeId);
//     currentTransactionDetail.value = await _transactionRepository
//         .getTransactionDetail(transactionId: currentTransactionId.value);
//   }

//   Future<String> printNota() async {
//     return await TransactionCrystalReportRepository()
//         .printNota(salesId: currentTransactionId.value);
//   }
// }
