import 'package:xhalona_pos/models/dao/masterall.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/m_all/mAll_services.dart';

class MasAllRepository extends AppRepository {
  MasAllServices _MasAllService = MasAllServices();

  Future<List<MasAllDAO>> getMasAll({
    int? pageNo,
    int? pageRow,
    String? isActive,
    String? filterValue,
    String? group,
  }) async {
    var result = await _MasAllService.getMasAll(
        pageNo: pageNo,
        pageRow: pageRow,
        filterValue: filterValue,
        group: group);
    List data = getResponseListData(result);
    return data.map((MasAll) => MasAllDAO.fromJson(MasAll)).toList();
  }

  Future<String> addEditMasAll({
    int? rowId,
    String? masId,
    String? masCategory,
    String? isActive,
    String? actionId,
  }) async {
    var result = await _MasAllService.addEditMasAll(
      rowId: rowId,
      masId: masId,
      masCategory: masCategory,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => MasAllDAO.fromJson(dept)).first.rowId.toString();
  }

  Future<String> deleteMasAll({
    int? rowId,
    String? masId,
  }) async {
    var result = await _MasAllService.deleteMasAll(rowId: rowId, masId: masId);
    List data = getResponseTrxData(result);
    return data.map((dept) => MasAllDAO.fromJson(dept)).first.rowId.toString();
  }
}
