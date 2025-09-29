import 'package:xhalona_pos/models/response/paket.dart';
import 'package:xhalona_pos/services/paket_services.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';

class PaketRepository extends AppRepository {
  PaketServices _PaketService = PaketServices();

  Future<List<PaketDAO>> getPaket({
    int? pageNo,
    int? pageRow,
    String? isActive,
    String? filterValue,
    String? filterPartId,
  }) async {
    var result = await _PaketService.getPaket(
      pageNo: pageNo,
      pageRow: pageRow,
      filterPartId: filterPartId,
      filterValue: filterValue ?? filterPartId,
    );
    List data = getResponseListData(result);
    return data.map((Paket) => PaketDAO.fromJson(Paket)).toList();
  }

  Future<String> addEditPaket({
    String? rowId,
    String? partId,
    String? comPartId,
    String? comValue,
    String? comUnitPrice,
    String? actionId,
  }) async {
    var result = await _PaketService.addEditPaket(
      rowId: rowId,
      partId: partId,
      comPartId: comPartId,
      comValue: comValue,
      comUnitPrice: comUnitPrice,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => PaketDAO.fromJson(dept)).first.rowId.toString();
  }

  Future<String> deletePaket({
    String? rowId,
  }) async {
    var result = await _PaketService.deletePaket(
      rowId: rowId,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => PaketDAO.fromJson(dept)).first.rowId.toString();
  }
}
