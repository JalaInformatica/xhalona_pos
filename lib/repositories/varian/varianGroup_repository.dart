import 'package:xhalona_pos/models/response/varian.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/varian/varianGroup_services.dart';

class VarianGroupRepository extends AppRepository {
  VarianGroupServices _VarianGroupService = VarianGroupServices();

  Future<List<VarianDAO>> getVarianGroup(
      {int? pageNo,
      int? pageRow,
      String? isActive,
      String? filterValue,
      String? varGroupId}) async {
    var result = await _VarianGroupService.getVarianGroup(
        pageNo: pageNo,
        pageRow: pageRow,
        filterValue: filterValue,
        varGroupId: varGroupId);
    List data = getResponseListData(result);
    return data.map((VarianGroup) => VarianDAO.fromJson(VarianGroup)).toList();
  }

  Future<String> addEditVarianGroup({
    String? varId,
    String? varName,
    String? varGroupId,
    String? actionId,
  }) async {
    var result = await _VarianGroupService.addEditVarianGroup(
      varGroupId: varGroupId,
      varName: varName,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data
        .map((dept) => VarianDAO.fromJson(dept))
        .first
        .varGroupId
        .toString();
  }

  Future<String> deleteVarianGroup({
    String? varGroupId,
  }) async {
    var result = await _VarianGroupService.deleteVarianGroup(
      varGroupId: varGroupId,
    );
    List data = getResponseTrxData(result);
    return data
        .map((dept) => VarianDAO.fromJson(dept))
        .first
        .varGroupId
        .toString();
  }
}
