import 'package:flutter/material.dart';
import 'package:flutter_widgets/core/viewmodels/viewmodel_handler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xhalona_pos/views/home/fragment/dashboard/repositories/dashboard_repositories.dart';

import '../states/dashboard_state.dart';

final dashboardViewModelProvider = AutoDisposeStateNotifierProvider<DashboardViewmodel, DashboardState>(
  (ref) => DashboardViewmodel(repository: DashboardRepository())
);

class DashboardViewmodel extends StateNotifier<DashboardState> {
  final DashboardRepository repository;

  DashboardViewmodel({
    required this.repository
  }): super(DashboardState.initial()){
    initialize();
  }

  Future<void> initialize() async {
    state = state.copyWith(
      todayTransaction: const AsyncLoading(),
      nettoToday: const AsyncLoading(),
      trxToday: const AsyncLoading()
    );

    await fetchTodayTransactions();
    await fetchTodayTrx();
  }

  Future<void> fetchTodayTransactions() async {
    ViewModelHandler.tryCatchAsync(
      run: () async {
        state = state.copyWith(todayTransaction: const AsyncLoading());
        final todayTransaction = await repository.getTodayTransactionHeader(
          pageRow: 5
        );
        ViewModelHandler.handlePaginatedResponseCode(
          todayTransaction,
          onSuccess: (data){
            state = state.copyWith(todayTransaction: AsyncData(data));
          },
          onError: (msg){
            throw(msg);
          }
        );        
      }, 
      onError: (e, st){
        state = state.copyWith(todayTransaction: AsyncValue.error(e, st));
      }
    );
  }

  Future<void> fetchTodayTrx() async {
    // try {
    //   state = state.copyWith(todayTransaction: const AsyncLoading());
    //   final todayTransaction = await repository.getTodayTransactionHeader(
    //     pageRow: 5
    //   );
    //   state = state.copyWith(todayTransaction: AsyncData(todayTransaction));
    //   // ViewModelHandler.handleResponseCode(
    //   //   todayTransaction,
    //   //   onSuccess: (data){
    //   //     state.copyWith();
    //   //   },
    //   //   onError: (msg){
    //   //     throw(msg);
    //   //   }
    //   // );
    // } catch (e, st){
    //   state = state.copyWith(todayTransaction: AsyncError(e, st));
    // }
  }
}