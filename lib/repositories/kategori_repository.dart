import 'package:xhalona_pos/models/dao/kategori.dart';
import 'package:xhalona_pos/services/kategori_services.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';

class KategoriRepository extends AppRepository {
  KategoriServices _KategoriService = KategoriServices();

  Future<List<KategoriDAO>> getKategori(
      {int? pageNo,
      int? pageRow,
      String? isActive,
      String? filterValue,
      String? companyId}) async {
    var result = await _KategoriService.getKategori(
        pageNo: pageNo,
        pageRow: pageRow,
        filterValue: filterValue,
        companyId: companyId);
    List data = getResponseListData(result);
    return data.map((Kategori) => KategoriDAO.fromJson(Kategori)).toList();
  }

  Future<String> addEditKategori({
    String? analisaId,
    String? ketAnalisa,
    String? isActive,
    String? actionId,
  }) async {
    var result = await _KategoriService.addEditKategori(
      analisaId: analisaId,
      ketAnalisa: ketAnalisa,
      isActive: isActive,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => KategoriDAO.fromJson(dept)).first.analisaId;
  }

  Future<String> deleteKategori({
    String? analisaId,
  }) async {
    var result = await _KategoriService.deleteKategori(
      analisaId: analisaId,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => KategoriDAO.fromJson(dept)).first.analisaId;
  }
}
