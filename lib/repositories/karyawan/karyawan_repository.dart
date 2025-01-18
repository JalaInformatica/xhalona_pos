import 'package:xhalona_pos/models/dao/karyawan.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/karyawan/karyawan_services.dart';

class KaryawanRepository extends AppRepository {
  KaryawanServices _karyawanService = KaryawanServices();

  Future<List<KaryawanDAO>> getKaryawan(
      {int? pageNo,
      int? pageRow,
      String? isActive,
      String? filterValue}) async {
    var result = await _karyawanService.getKaryawan(
        pageNo: pageNo,
        pageRow: pageRow,
        isActive: isActive,
        filterValue: filterValue);
    List data = getResponseListData(result);
    return data.map((karyawan) => KaryawanDAO.fromJson(karyawan)).toList();
  }

  Future<String> addEditKaryawan({
    String? empId,
    String? fullName,
    String? dateIn,
    String? isActive,
    String? bpjsNo,
    String? bpjsTk,
    String? gender,
    String? birthDate,
    String? birthPlace,
    String? alamat,
    String? kdDept,
    String? bonusAmount,
    String? bonusTarget,
    String? actionId,
  }) async {
    var result = await _karyawanService.addEditKaryawan(
      actionId: actionId,
      empId: empId,
      fullName: fullName,
      dateIn: dateIn,
      bpjsNo: bpjsNo,
      bpjsTk: bpjsTk,
      gender: gender,
      birthDate: birthDate,
      birthPlace: birthPlace,
      alamat: alamat,
      kdDept: kdDept,
      bonusAmount: bonusAmount,
      bonusTarget: bonusTarget,
      isActive: isActive,
    );
    List data = getResponseTrxData(result);
    return data.map((karyawan) => KaryawanDAO.fromJson(karyawan)).first.empId;
  }

  Future<String> deleteKaryawan({
    String? empId,
  }) async {
    var result = await _karyawanService.deleteKaryawan(
      empId: empId,
    );
    List data = getResponseTrxData(result);
    return data.map((karyawan) => KaryawanDAO.fromJson(karyawan)).first.empId;
  }
}
