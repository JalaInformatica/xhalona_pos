import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/models/dao/shift.dart';
import 'package:xhalona_pos/models/dao/transaction.dart';
import 'package:xhalona_pos/models/dto/transaction.dart';
import 'package:xhalona_pos/repositories/crystal_report/transaction_crystal_report_repository.dart';
import 'package:xhalona_pos/repositories/employee/employee_repository.dart';
import 'package:xhalona_pos/repositories/kustomer/kustomer_repository.dart';
import 'package:xhalona_pos/repositories/product/product_repository.dart';
import 'package:xhalona_pos/repositories/shift/shift_repository.dart';
import 'package:xhalona_pos/repositories/transaction/transaction_repository.dart';

class TransactionPosRepository {
  final KustomerRepository _customerRepository = KustomerRepository();
  final ProductRepository _productRepository = ProductRepository();
  final EmployeeRepository _employeeRepository = EmployeeRepository();
  final TransactionRepository _transactionRepository = TransactionRepository();
  final TransactionCrystalReportRepository _transactionCrystalReportRepository = TransactionCrystalReportRepository();
  final ShiftRepository _shiftRepository = ShiftRepository();

  Future<List<KustomerDAO>> getKustomer({
    int? pageNo,
    int? pageRow,
    String? filterValue,
  }) async {
    return _customerRepository.getKustomer(
      pageNo: pageNo,
      pageRow: pageRow,
      filterValue: filterValue 
    );
  }

  Future<void> addCustomer({
    required KustomerDAO customer
  }) async {
    _customerRepository.addEditKustomer(
      telp: customer.telp,
      suplierName: customer.suplierName,
      emailAdress: customer.emailAdress,
      adress1: customer.address1
    );
  }

  Future<List<ProductDAO>> getProducts({
    int? pageNo,
    int? pageRow,
    String? filterValue,
  }) async {
    return _productRepository.getProducts(
      pageNo: pageNo,
      pageRow: pageRow,
      filterValue: filterValue
    );
  }

  Future<List<EmployeeDAO>> getEmployees({
    int? pageNo,
    int? pageRow,
    String? filterValue,
  }) async {
    return _employeeRepository.getEmployees(
      pageNo: pageNo,
      pageRow: pageRow,
      filterValue: filterValue
    );
  }

  Future<TransactionHeaderDAO> getTransactionHeader({
    required String salesId
  }) async {
    final data = await _transactionRepository.getTransactionHeader(transactionId: salesId);
    if(data.isNotEmpty){
      return data.first;
    }
    return TransactionHeaderDAO();
  }

  Future<void> editTransactionHeader({
    required TransactionDTO transaction
  }) async {
    await _transactionRepository.editTransactionHeader(transaction);
  }

  Future<void> addTransactionDetail({
    required TransactionDetailDTO transactionDetail
  }) async {
    await _transactionRepository.addTransactionDetail([transactionDetail]);
  }

  Future<void> editTransactionDetail({
    required TransactionDetailDTO transactionDetail
  }) async {
    await _transactionRepository.editTransactionDetail(transactionDetail);
  }

  Future<List<TransactionDetailDAO>> getTransactionDetail({
    required String salesId
  }) async {
    return await _transactionRepository.getTransactionDetail(transactionId: salesId);
  }

  Future<String> printNota({required String salesId}) async {
    return await _transactionCrystalReportRepository
        .printNota(salesId: salesId);
  }

  Future<List<ShiftDAO>> getShift({required String filterValue}) async {
    return await _shiftRepository.getShifts(
      pageNo: 1,
      pageRow: 5,
      filterValue: filterValue
    );
  }

  Future<void> cancelTransaction({required String salesId}) async {
    await _transactionRepository.deleteTransactionHeader(salesId);
  }

  Future<String> createTransactionHeader() async {
    TransactionDTO transaction = TransactionDTO();
    return await _transactionRepository.addTransactionHeader(
      transaction
    );
  }

  Future<void> deleteTransactionDetail({required String salesId, required String rowId}) async {
    await _transactionRepository.deleteTransactionDetail(salesId: salesId, rowId: rowId);
  }
}