import 'package:intl/intl.dart';
import 'package:xhalona_pos/core/helper/date_helper.dart';
import 'package:xhalona_pos/models/response/report.dart';
import 'package:xhalona_pos/models/response/summary.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/summary/report_services.dart';

class ReportRepository extends AppRepository {
  final ReportServices _service = ReportServices();

  Future<List<SummaryDAO>> getSummary({
    String? fDay,
    String? fMonth,
    String? filterValue,
    String? fYear,
  }) async {
    var result = await _service.getSummary(
      fDay: fDay,
      fMonth: fMonth,
      fYear: fYear,
      filterValue: filterValue,
    );
    List data = getResponseListData(result);
    return data.map((Summary) => SummaryDAO.fromJson(Summary)).toList();
  }

  Future<List<ReportDAO>> getReport({
    required String actionId,
    DateTime? startDate,
    DateTime? endDate,
    int? bulan,
    int? tahun,
  }) async {
    var result = await _service.getReport(
      actionId: actionId,
      startDate: startDate != null? DateHelper.dateToAPIFormat(startDate) : "",
      endDate: endDate != null? DateHelper.dateToAPIFormat(endDate) : "",
      bulan: bulan,
      tahun: tahun
    );
    List data = getResponseListData(result);
    return data.map((report) => ReportDAO.fromJson(report)).toList();
  }
}
