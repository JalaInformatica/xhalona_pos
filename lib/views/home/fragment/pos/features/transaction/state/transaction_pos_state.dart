import 'package:xhalona_pos/models/dao/transaction.dart';

enum CustomerType {member, tamu}

class TransactionPosState {
  final bool isLoadingTransaction;
  final bool isLoadingTransactionDetail;
  final CustomerType customerType;
  final TransactionHeaderDAO transactionHeader;
  final List<TransactionDetailDAO> transactionDetailList; 
  
  TransactionPosState({
    TransactionHeaderDAO? transactionHeader,
    this.transactionDetailList = const [],
    this.isLoadingTransaction = false,
    this.isLoadingTransactionDetail = false,
    this.customerType = CustomerType.member
  })  : transactionHeader = transactionHeader ?? TransactionHeaderDAO();

  TransactionPosState copyWith({
    TransactionHeaderDAO? transactionHeader,
    List<TransactionDetailDAO>? transactionDetailList,
    bool? isLoadingTransaction,
    bool? isLoadingTransactionDetail,
    CustomerType? customerType
  }) {
    return TransactionPosState(
      transactionHeader: transactionHeader ?? this.transactionHeader,
      transactionDetailList: transactionDetailList ?? this.transactionDetailList,
      isLoadingTransaction: isLoadingTransaction ?? this.isLoadingTransaction,
      customerType: customerType ?? this.customerType,
      isLoadingTransactionDetail: isLoadingTransactionDetail ?? this.isLoadingTransactionDetail
    );
  }
}
