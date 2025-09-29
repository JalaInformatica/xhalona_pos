import 'package:xhalona_pos/models/response/bahan.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/bahan/bahan_services.dart';

class BahanRepository extends AppRepository {
  BahanServices _BahanService = BahanServices();

  Future<List<BahanDAO>> getBahan(
      {int? pageNo,
      int? pageRow,
      String? isActive,
      String? filterValue,
      String? filterPartId}) async {
    var result = await _BahanService.getBahan(
        pageNo: pageNo,
        pageRow: pageRow,
        filterValue: filterValue,
        filterPartId: filterPartId);
    List data = getResponseListData(result);
    return data.map((Bahan) => BahanDAO.fromJson(Bahan)).toList();
  }

  Future<String> addEditBahan({
    String? rowId,
    String? partId,
    String? bomPartId,
    String? unitId,
    String? actionId,
  }) async {
    var result = await _BahanService.addEditBahan(
      rowId: rowId,
      partId: partId,
      bomPartId: bomPartId,
      unitId: unitId,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => BahanDAO.fromJson(dept)).first.partId;
  }

  Future<String> deleteBahan({
    String? rowId,
  }) async {
    var result = await _BahanService.deleteBahan(
      rowId: rowId,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => BahanDAO.fromJson(dept)).first.partId;
  }
}
