import 'package:xhalona_pos/models/dao/coa.dart';
import 'package:xhalona_pos/services/coa/coa_services.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';

class CoaRepository extends AppRepository {
  CoaServices _CoaService = CoaServices();

  Future<List<CoaDAO>> getCoa({
    int? pageNo,
    int? pageRow,
    String? isActive,
    String? filterValue,
  }) async {
    var result = await _CoaService.getCoa(
        pageNo: pageNo, pageRow: pageRow, filterValue: filterValue);
    List data = getResponseListData(result);
    return data.map((Coa) => CoaDAO.fromJson(Coa)).toList();
  }

  Future<String> addEditCoa({
    String? accId,
    String? pAccId,
    String? namaRek,
    String? jenisRek,
    String? flagDk,
    String? flagTm,
    String? isActive,
    String? actionId,
  }) async {
    var result = await _CoaService.addEditCoa(
      accId: accId,
      pAccId: pAccId,
      namaRek: namaRek,
      jenisRek: jenisRek,
      flagDk: flagDk,
      flagTm: flagTm,
      isActive: isActive,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data.map((kustomer) => CoaDAO.fromJson(kustomer)).first.acId;
  }

  Future<String> deleteCoa({
    String? accId,
  }) async {
    var result = await _CoaService.deleteCoa(
      accId: accId,
    );
    List data = getResponseTrxData(result);
    return data.map((kustomer) => CoaDAO.fromJson(kustomer)).first.acId;
  }
}
