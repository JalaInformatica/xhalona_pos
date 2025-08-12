import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xhalona_pos/views/home/fragment/dashboard/repositories/dashboard_repositories.dart';

import '../states/dashboard_state.dart';


final dashboardViewModelProvider = AutoDisposeStateNotifierProvider<DashboardViewmodel, DashboardState>(
  (ref) => DashboardViewmodel(repository: DashboardRepositories())
);

class DashboardViewmodel extends StateNotifier<DashboardState> {
  final DashboardRepositories repository;

  DashboardViewmodel({
    required this.repository
  }): super(DashboardState()){
    initialize();
  }

  Future<void> initialize() async {
    state = state.copyWith(
      isLoadingTodayTransaction: true,
    );
    final todayTransaction = await repository.getTodayTransactionHeader(
      pageRow: 5
    );
    state = state.copyWith(
      todayTransaction: todayTransaction,
      isLoadingTodayTransaction: false
    );
  }
}