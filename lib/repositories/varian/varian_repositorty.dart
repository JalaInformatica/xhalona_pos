import 'package:xhalona_pos/models/response/varian.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/varian/varian_services.dart';

class VarianRepository extends AppRepository {
  VarianServices _VarianService = VarianServices();

  Future<List<VarianDAO>> getVarian(
      {int? pageNo,
      int? pageRow,
      String? isActive,
      String? filterValue,
      String? varGroupId}) async {
    var result = await _VarianService.getVarian(
        pageNo: pageNo,
        pageRow: pageRow,
        filterValue: filterValue,
        varGroupId: varGroupId);
    List data = getResponseListData(result);
    return data.map((Varian) => VarianDAO.fromJson(Varian)).toList();
  }

  Future<String> addEditVarian({
    String? varId,
    String? varName,
    String? varGroupId,
    String? actionId,
  }) async {
    var result = await _VarianService.addEditVarian(
      varGroupId: varGroupId,
      varName: varName,
      varId: varId,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data
        .map((dept) => VarianDAO.fromJson(dept))
        .first
        .varGroupId
        .toString();
  }

  Future<String> deleteVarian({
    String? varGroupId,
    String? varId,
  }) async {
    var result =
        await _VarianService.deleteVarian(varGroupId: varGroupId, varId: varId);
    List data = getResponseTrxData(result);
    return data
        .map((dept) => VarianDAO.fromJson(dept))
        .first
        .varGroupId
        .toString();
  }
}
