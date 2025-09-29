

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:xhalona_pos/models/response/employee.dart';
import 'package:xhalona_pos/models/response/kustomer.dart';
import 'package:xhalona_pos/globals/product/models/product.dart';
import 'package:xhalona_pos/models/response/shift.dart';
import 'package:xhalona_pos/globals/transaction/models/transaction_response.dart';
import 'package:xhalona_pos/models/dto/transaction.dart';
import 'package:xhalona_pos/views/home/fragment/pos/features/transaction/repositories/transaction_pos_repositories.dart';
import 'package:xhalona_pos/views/home/fragment/pos/features/transaction/state/transaction_pos_state.dart';
import 'package:pdf/widgets.dart' as pw;

final transactionPosViewModelProvider =
    AutoDisposeStateNotifierProvider.family<TransactionPosViewmodel, TransactionPosState, String>(
  (ref, salesId) => TransactionPosViewmodel(
    repository: TransactionPosRepository(),
    salesId: salesId),
);

class TransactionPosViewmodel extends StateNotifier<TransactionPosState>{
  final String salesId;
  final TransactionPosRepository repository;
  final TextEditingController customerController = TextEditingController();
  final TextEditingController guestNameController = TextEditingController();
  final TextEditingController guestPhoneController = TextEditingController();
  final TextEditingController productController = TextEditingController();

  TransactionPosViewmodel({
    required this.salesId,
    required this.repository,
  }) : super(TransactionPosState()){
    initialize();
  }

  void setCustomerType(CustomerType customerType){
    state = state.copyWith(customerType: customerType);
  }

  Future<void> initialize() async {
    await getTransaction();
    await getTransactionDetail();
  }

  Future<void> getTransaction() async {
    state = state.copyWith( isLoadingTransaction: true);
    final transaction = await repository.getTransactionHeader(salesId: salesId);
    state = state.copyWith(
      transactionHeader: transaction,
      isLoadingTransaction: false,
      customerType: transaction.supplierId.isNotEmpty || transaction.guestName.isEmpty? CustomerType.member : CustomerType.tamu,
    );
    customerController.text = "${state.transactionHeader.supplierName}";
  }

  Future<void> getTransactionDetail() async {
    state = state.copyWith(isLoadingTransactionDetail: true);
    final transactionDetail = await repository.getTransactionDetail(salesId: salesId);
    state = state.copyWith(
      isLoadingTransactionDetail: false,
      transactionDetailList: transactionDetail
    );
  }

  Future<List<EmployeeDAO>> getEmployeeList({required String filter}) async {
    final employeeList = await repository.getEmployees(
      pageRow: 5,
      filterValue: filter
    );
    return employeeList;
  }

  Future<List<KustomerDAO>> getMemberList({required String filter}) async {
    final memberList = await repository.getKustomer(
      pageRow: 5,
      filterValue: filter
    );
    return memberList;
  }

  Future<void> addCustomer({required KustomerDAO customer}) async {
    await repository.addCustomer(customer: customer);
  }

  Future<List<ProductDAO>> getProductList({required String filter}) async {
    state = state.copyWith();
    final productList = await repository.getProducts(
      pageRow: 5,
      filterValue: filter
    );
    return productList;
  }

  Future<void> editTransactionHeader({
    String? suplierId, 
    String? guestName,
    String? guestPhone,
    String? shiftId
    }) async {
    final transaction = state.transactionHeader;
    await repository.editTransactionHeader(transaction: TransactionDTO(
      salesId: salesId,
      supplierId: suplierId ?? transaction.supplierId,
      guestName: guestName ?? transaction.guestName,
      guestPhone: guestPhone ?? transaction.guestPhone,
      shiftId: shiftId ?? transaction.shiftId
    ));
  }

  Future<void> addTransactionDetail({
    required String partId,
  })async{
    await repository.addTransactionDetail(
      transactionDetail: TransactionDetailDTO(
        salesId: salesId,
        partId: partId,
        qty: 1
      )
    );
  }

  Future<void> editTransactionEmployee({
    required TransactionDetailResponse detail,
    required String partId,
    required String rowId,
    String? detNote,
    String? employeId,
    String? employeId2,
    String? employeId3,
    String? employeId4,
  }) async {
    await repository.editTransactionDetail(
      transactionDetail: TransactionDetailDTO(
        salesId: salesId,
        rowId: rowId,
        partId: partId,
        qty: 1,
        detNote: detNote ?? detail.detNote,
        employeeId: employeId ?? detail.employeeId,
        employeeId2: employeId2 ?? detail.employeeId2,
        employeeId3: employeId3 ?? detail.employeeId3,
        employeeId4: employeId4 ?? detail.employeeId4
      )
    );
  }

  Future<void> editTransactionDetail({
    required TransactionDetailResponse detail,
    required String partId,
    required String rowId,
    int? qty,
    String? detNote,
    String? employeId,
    String? employeId2,
    String? employeId3,
    String? employeId4,
    int? deductionVal
  }) async {
    await repository.editTransactionDetail(
      transactionDetail: TransactionDetailDTO(
        salesId: salesId,
        rowId: rowId,
        partId: partId,
        qty: qty ?? detail.qty,
        detNote: detNote ?? detail.detNote,
        employeeId: employeId ?? detail.employeeId,
        employeeId2: employeId2 ?? detail.employeeId2,
        employeeId3: employeId3 ?? detail.employeeId3,
        employeeId4: employeId4 ?? detail.employeeId4,
        deductionVal: deductionVal ?? detail.deductionVal
      )
    );
  }

Future<pw.Document> generateQueuePDF() async {
    final fontRegular = pw.Font.ttf(await rootBundle.load("assets/fonts/GoogleSans-Regular.ttf"));
    final fontBold = pw.Font.ttf(await rootBundle.load("assets/fonts/GoogleSans-Bold.ttf"));

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll57,
        build: (pw.Context context) {
          return pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  state.transactionHeader.companyName,
                  style: pw.TextStyle(font: fontRegular, fontSize: 12),
                ),
                pw.Text(
                  "Nomor Antrian",
                  style: pw.TextStyle(font: fontRegular, fontSize: 12),
                ),
                pw.Text(
                  state.transactionHeader.queueNumber.toString(),
                  style: pw.TextStyle(font: fontRegular, fontSize: 24),
                ),
                pw.Text(
                  state.transactionHeader.guestName.isEmpty ? state.transactionHeader.supplierName : state.transactionHeader.guestName,
                  style: pw.TextStyle(font: fontRegular, fontSize: 14),
                ),
                pw.Table(
                  // border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FlexColumnWidth(2), // No
                    1: pw.FlexColumnWidth(3), // Produk
                    2: pw.FlexColumnWidth(3), // Terapis
                    3: pw.FlexColumnWidth(2), // Paraf
                  },
                  children: [
                    // Table Header
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("No",
                              style: pw.TextStyle(
                                  font: fontBold, fontSize: 8)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("Produk",
                              style: pw.TextStyle(fontSize: 8,
                                  font: fontBold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("Terapis",
                              style: pw.TextStyle(fontSize: 8,
                                  font: fontBold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text("Paraf",
                              style: pw.TextStyle(fontSize: 8,
                                  font: fontBold)),
                        ),
                      ],
                    ),

                    // Table Rows (Data)
                    ...List.generate(
                      state.transactionDetailList.length,
                      (index) {
                        TransactionDetailResponse detail =
                            state.transactionDetailList[index];
                        return pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text("${index + 1}",
                                  style: pw.TextStyle(fontSize: 8,
                                    font: fontRegular,
                                  )),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(detail.partName,
                                  style: pw.TextStyle(fontSize: 8,
                                    font: fontRegular,
                                  )),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(detail.fullName,
                                  style: pw.TextStyle(fontSize: 8,
                                    font: fontRegular,
                                  )),
                            ),
                            pw.Container(
                              decoration: pw.BoxDecoration(
                                border: pw.Border(bottom: pw.BorderSide(style: pw.BorderStyle.dotted))
                              ),
                              padding: const pw.EdgeInsets.all(4),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Tambahan :", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, font: fontRegular)),
                    pw.Container(
                      padding: pw.EdgeInsets.only(top: 15),
                      decoration: pw.BoxDecoration(
                        border: pw.Border(bottom: pw.BorderSide(style: pw.BorderStyle.dotted))
                      )
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(top: 15),
                      decoration: pw.BoxDecoration(
                        border: pw.Border(bottom: pw.BorderSide(style: pw.BorderStyle.dotted))
                      )
                    ),
                  ]
                )
              ]);
        },
      ),
    );
    return pdf;
  }

  Future<void> cancelTransaction() async {
    return await repository.cancelTransaction(salesId: salesId);
  }
  
  Future<void> deleteTransactionDetail({required String rowId}) async {
    return await repository.deleteTransactionDetail(salesId: salesId, rowId: rowId);
  }

  Future<String> printNota() async {
    return await repository.printNota(salesId: salesId);
  }

  Future<List<ShiftDAO>> getShifts({required String filterValue}) async {
    return await repository.getShift(filterValue: filterValue);
  }

  Future<String> createTransaction() async {
    return await repository.createTransactionHeader();
  }
}