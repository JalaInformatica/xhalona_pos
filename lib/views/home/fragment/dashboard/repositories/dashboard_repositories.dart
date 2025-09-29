import 'package:flutter_widgets/core/models/response/response_model.dart';
import 'package:xhalona_pos/globals/transaction/models/transaction_response.dart';
import 'package:xhalona_pos/globals/transaction/repositories/transaction_repository.dart';
import 'package:xhalona_pos/repositories/xhalona_repository.dart';

import '../services/dashboard_service.dart';

class DashboardRepository extends XhalonaRepository {
  final TransactionRepository _transactionRepository = TransactionRepository();
  final DashboardService _dashboardService = DashboardService();

  Future<ResponseModelPaginated<TransactionResponse>> getTodayTransactionHeader({
    int? pageNo,
    int? pageRow,
    String? filterValue,
    String? statusCategory
  }){
    DateTime now = DateTime.now();
    return _transactionRepository.getTransactionHeader(
      pageNo: pageNo,
      pageRow: pageRow,
      filterValue: filterValue,
      filterDay: now.day,
      filterMonth: now.month,
      filterYear: now.year,
      statusCategory: statusCategory
    );
  }

  Future<ResponseModel<dynamic>> getTransactionSummary({int? day, int? month, int? year}) async {
    var result = await _dashboardService.getTransactionSummary(day: day, month: month, year: year);
    return getResponseSingleData<dynamic>(
      result,
      formatter: (data)=>data
    );
  }
}