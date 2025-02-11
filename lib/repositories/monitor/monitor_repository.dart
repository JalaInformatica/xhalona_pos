import 'package:xhalona_pos/models/dao/monitor.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/monitor/monitor_services.dart';

class MonitorRepository extends AppRepository {
  MonitorServices _MonitorService = MonitorServices();

  Future<List<MonitorDAO>> getMonitor({
    String? fDateFrom,
    String? fDateTo,
    String? filterValue,
    String? format,
  }) async {
    var result = await _MonitorService.getMonitor(
      fDateFrom: fDateFrom,
      fDateTo: fDateTo,
      format: format,
      filterValue: filterValue,
    );
    List data = getResponseListData(result);
    return data.map((Monitor) => MonitorDAO.fromJson(Monitor)).toList();
  }
}
