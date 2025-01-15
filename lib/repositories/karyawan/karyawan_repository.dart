import 'package:xhalona_pos/models/dao/karyawan.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/karyawan/karyawan_services.dart';

class KaryawanRepository extends AppRepository {
  KaryawanServices _karyawanService = KaryawanServices();

  Future<List<KaryawanDAO>> getKaryawan({
    int? pageNo,
    int? pageRow,
    String? isActive,
    String? filterValue,
  }) async {
    var result = await _karyawanService.getKaryawan(
        pageNo: pageNo,
        pageRow: pageRow,
        isActive: isActive,
        filterValue: filterValue);
    List data = getResponseListData(result);
    return data.map((karyawan) => KaryawanDAO.fromJson(karyawan)).toList();
  }
}
