import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xhalona_pos/views/home/fragment/pos/repositories/pos_repository.dart';
import 'package:xhalona_pos/views/home/fragment/pos/states/pos_state.dart';

final posViewModelProvider = AutoDisposeStateNotifierProvider<PosViewmodel, PosState>(
  (ref) => PosViewmodel(repository: PosRepository())
);

class PosViewmodel extends StateNotifier<PosState>{
  final PosRepository repository;

  PosViewmodel({
    required this.repository
  }): super(PosState()){
    initialize();
  }

  Future<void> initialize({int? pageRow}) async {
    state = state.copyWith(
      isLoadingTodayTransaction: true,
      pageNo: 1
    );
    final todayTransaction = await repository.getTodayTransactionHeader(
      statusCategory: state.filterTransactionCategory,
      pageNo: state.pageNo,
      pageRow: pageRow ?? 10
    );
    // state = state.copyWith(
    //   todayTransaction: todayTransaction,
    //   isLoadingTodayTransaction: false
    // );
  }

  Future<void> onPageNoChanged(int pageNo) async {
    state = state.copyWith(isLoadingTodayTransaction: true,
      pageNo: pageNo,
    );
    final todayTransaction = await repository.getTodayTransactionHeader(
      statusCategory: state.filterTransactionCategory,
      pageNo: state.pageNo
    );
    // state = state.copyWith(
    //   todayTransaction: todayTransaction,
    //   isLoadingTodayTransaction: false
    // );
  }

  Future<void> onPageRowChanged(int pageRow) async {
    await initialize(pageRow : pageRow);
  }

  Future<void> setFilterStatusCategory({required String filterStatusCategory}) async {
    state = state.copyWith(
      filterTransactionCategory: filterStatusCategory
    );
    initialize();
  }

  Future<String> createTransaction() async {
    return ""; //await repository.createTransactionHeader();
  }
}