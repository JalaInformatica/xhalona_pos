import 'package:xhalona_pos/globals/transaction/models/transaction_response.dart';

enum CustomerType {member, tamu}

class TransactionPosState {
  final bool isLoadingTransaction;
  final bool isLoadingTransactionDetail;
  final CustomerType customerType;
  final TransactionResponse transactionHeader;
  final List<TransactionDetailResponse> transactionDetailList; 
  
  TransactionPosState({
    TransactionResponse? transactionHeader,
    this.transactionDetailList = const [],
    this.isLoadingTransaction = false,
    this.isLoadingTransactionDetail = false,
    this.customerType = CustomerType.member
  })  : transactionHeader = transactionHeader ?? TransactionResponse();

  TransactionPosState copyWith({
    TransactionResponse? transactionHeader,
    List<TransactionDetailResponse>? transactionDetailList,
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
