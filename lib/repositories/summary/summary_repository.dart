import 'package:xhalona_pos/models/dao/summary.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/summary/summary_services.dart';

class SummaryRepository extends AppRepository {
  SummaryServices _SummaryService = SummaryServices();

  Future<List<SummaryDAO>> getSummary({
    String? fDay,
    String? fMonth,
    String? filterValue,
    String? fYear,
  }) async {
    var result = await _SummaryService.getSummary(
      fDay: fDay,
      fMonth: fMonth,
      fYear: fYear,
      filterValue: filterValue,
    );
    List data = getResponseListData(result);
    return data.map((Summary) => SummaryDAO.fromJson(Summary)).toList();
  }
}
