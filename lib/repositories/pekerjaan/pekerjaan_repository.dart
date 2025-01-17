import 'package:xhalona_pos/models/dao/pekerjaan.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/pekerjaan/pekerjaan_services.dart';

class PekerjaanRepository extends AppRepository {
  PekerjaanServices _PekerjaanService = PekerjaanServices();

  Future<List<PekerjaanDAO>> getPekerjaan({
    int? pageNo,
    int? pageRow,
    String? isActive,
    String? filterValue,
  }) async {
    var result = await _PekerjaanService.getPekerjaan(
        pageNo: pageNo, pageRow: pageRow, filterValue: filterValue);
    List data = getResponseListData(result);
    return data.map((Pekerjaan) => PekerjaanDAO.fromJson(Pekerjaan)).toList();
  }

  Future<String> addEditPekerjaan({
    String? jobId,
    String? jobDesc,
    String? actionId,
  }) async {
    var result = await _PekerjaanService.addEditPekerjaan(
      jobId: jobId,
      jobDesc: jobDesc,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => PekerjaanDAO.fromJson(dept)).first.jobId;
  }

  Future<String> deletePekerjaan({
    String? jobId,
  }) async {
    var result = await _PekerjaanService.deletePekerjaan(
      jobId: jobId,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => PekerjaanDAO.fromJson(dept)).first.jobId;
  }
}
