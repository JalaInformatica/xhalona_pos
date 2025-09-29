import 'package:xhalona_pos/models/response/rekening.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/rekening/rekening_services.dart';

class RekeningRepository extends AppRepository {
  RekeningServices _RekeningService = RekeningServices();

  Future<List<RekeningDAO>> getRekening({
    int? pageNo,
    int? pageRow,
    String? isActive,
    String? filterValue,
  }) async {
    var result = await _RekeningService.getRekening(
        pageNo: pageNo, pageRow: pageRow, filterValue: filterValue);
    List data = getResponseListData(result);
    return data.map((Rekening) => RekeningDAO.fromJson(Rekening)).toList();
  }

  Future<String> addEditKaryawan({
    String? acId,
    String? jenisAc,
    String? namaAc,
    String? acNoReff,
    String? acGL,
    String? acGroupId,
    String? nCodeIn,
    String? nCodeOut,
    String? bankName,
    String? bankAcName,
    String? acsUserId,
    String? isActive,
    String? actionId,
  }) async {
    var result = await _RekeningService.addEditRekening(
      acId: acId,
      jenisAc: jenisAc,
      namaAc: namaAc,
      acNoReff: acNoReff,
      acGL: acGL,
      acGroupId: acGroupId,
      nCodeIn: nCodeIn,
      nCodeOut: nCodeOut,
      bankAcName: bankAcName,
      bankName: bankName,
      acsUserId: acsUserId,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data.map((rek) => RekeningDAO.fromJson(rek)).first.acId;
  }

  Future<String> deleteKaryawan({
    String? acId,
  }) async {
    var result = await _RekeningService.deleteRekening(
      acId: acId,
    );
    List data = getResponseTrxData(result);
    return data.map((rek) => RekeningDAO.fromJson(rek)).first.acId;
  }
}
