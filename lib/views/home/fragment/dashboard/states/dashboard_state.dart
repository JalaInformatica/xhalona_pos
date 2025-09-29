import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xhalona_pos/globals/transaction/models/transaction_response.dart';


class DashboardState {
  final AsyncValue<List<TransactionResponse>> todayTransaction;
  final AsyncValue<double> nettoToday;
  final AsyncValue<double> trxToday;

  const DashboardState({
    required this.todayTransaction,
    required this.nettoToday,
    required this.trxToday,    
  });

  DashboardState copyWith({
    AsyncValue<List<TransactionResponse>>? todayTransaction,
    AsyncValue<double>? nettoToday,
    AsyncValue<double>? trxToday,
    
    
  }) {
    return DashboardState(
      todayTransaction: todayTransaction ?? this.todayTransaction,
      nettoToday: nettoToday ?? this.nettoToday,
      trxToday: trxToday ?? this.trxToday,
      
      
    );
  }

  factory DashboardState.initial() => const DashboardState(
    todayTransaction: AsyncValue.loading(),
    nettoToday: AsyncValue.loading(),
    trxToday: AsyncValue.loading(),
    
    
  );
}