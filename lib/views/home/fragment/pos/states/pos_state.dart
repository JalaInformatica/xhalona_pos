import 'package:xhalona_pos/globals/transaction/models/transaction_response.dart';

class PosState {
  bool isLoadingTodayTransaction;
  List<TransactionResponse> todayTransaction;
  String filterTransactionCategory;
  int pageNo;

  PosState({
    this.filterTransactionCategory = '',
    this.todayTransaction = const [],
    this.isLoadingTodayTransaction = false,
    this.pageNo = 1
  });

  PosState copyWith({
    List<TransactionResponse>? todayTransaction,
    bool? isLoadingTodayTransaction,
    String? filterTransactionCategory,
    int? pageNo
  }){
    return PosState(
      filterTransactionCategory: filterTransactionCategory ?? this.filterTransactionCategory,
      todayTransaction: todayTransaction ?? this.todayTransaction,
      isLoadingTodayTransaction: isLoadingTodayTransaction ?? this.isLoadingTodayTransaction,
      pageNo: pageNo ?? this.pageNo
    );
  }  
}