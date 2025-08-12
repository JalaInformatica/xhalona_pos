import 'package:xhalona_pos/models/dao/transaction.dart';

class DashboardState {
  final bool isLoadingTodayTransaction;
  final List<TransactionHeaderDAO> todayTransaction;

  DashboardState({
    this.todayTransaction = const [],
    this.isLoadingTodayTransaction = false,
  });

   DashboardState copyWith({
    List<TransactionHeaderDAO>? todayTransaction,
    bool? isLoadingTodayTransaction
  }){
    return  DashboardState(
      todayTransaction: todayTransaction ?? this.todayTransaction,
      isLoadingTodayTransaction: isLoadingTodayTransaction ?? this.isLoadingTodayTransaction
    );
  }  
}