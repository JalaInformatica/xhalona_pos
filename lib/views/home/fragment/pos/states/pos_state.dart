import 'package:xhalona_pos/models/dao/transaction.dart';

class PosState {
  bool isLoadingTodayTransaction;
  List<TransactionHeaderDAO> todayTransaction;
  String filterTransactionCategory;
  int pageNo;

  PosState({
    this.filterTransactionCategory = '',
    this.todayTransaction = const [],
    this.isLoadingTodayTransaction = false,
    this.pageNo = 1
  });

  PosState copyWith({
    List<TransactionHeaderDAO>? todayTransaction,
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