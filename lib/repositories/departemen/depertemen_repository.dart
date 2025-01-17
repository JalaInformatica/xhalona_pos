import 'package:xhalona_pos/models/dao/departemen.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/departemen/departemen_services.dart';

class DepartemenRepository extends AppRepository {
  DepartemenServices _DepartemenService = DepartemenServices();

  Future<List<DepartemenDAO>> getDepartemen({
    int? pageNo,
    int? pageRow,
    String? isActive,
    String? filterValue,
  }) async {
    var result = await _DepartemenService.getDepartemen(
        pageNo: pageNo, pageRow: pageRow, filterValue: filterValue);
    List data = getResponseListData(result);
    return data
        .map((Departemen) => DepartemenDAO.fromJson(Departemen))
        .toList();
  }

  Future<String> addEditDepartemen({
    String? kdDept,
    String? nmDept,
    String? actionId,
  }) async {
    var result = await _DepartemenService.addEditDept(
      kdDept: kdDept,
      nmDept: nmDept,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => DepartemenDAO.fromJson(dept)).first.kdDept;
  }

  Future<String> deleteDepartemen({
    String? kdDept,
  }) async {
    var result = await _DepartemenService.deleteDept(
      kdDept: kdDept,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => DepartemenDAO.fromJson(dept)).first.kdDept;
  }
}
