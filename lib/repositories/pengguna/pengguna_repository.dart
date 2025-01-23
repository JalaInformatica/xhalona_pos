import 'package:xhalona_pos/models/dao/pengguna.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/pengguna/pengguna_services.dart';

class PenggunaRepository extends AppRepository {
  PenggunaServices _PenggunaService = PenggunaServices();

  Future<List<PenggunaDAO>> getPengguna({
    int? pageNo,
    int? pageRow,
    String? isActive,
    String? filterValue,
  }) async {
    var result = await _PenggunaService.getPengguna(
        pageNo: pageNo, pageRow: pageRow, filterValue: filterValue);
    List data = getResponseListData(result);
    return data.map((Pengguna) => PenggunaDAO.fromJson(Pengguna)).toList();
  }

  Future<String> addEditPengguna({
    String? password,
    String? memberId,
    String? roleId,
    String? deptId,
    String? levelId,
    String? email,
    String? isActive,
    String? actionId,
  }) async {
    var result = await _PenggunaService.addEditPengguna(
      memberId: memberId,
      password: password,
      roleId: roleId,
      deptId: deptId,
      levelId: levelId,
      email: email,
      isActive: isActive,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => PenggunaDAO.fromJson(dept)).first.memberId;
  }

  Future<String> deletePengguna({
    String? memberId,
  }) async {
    var result = await _PenggunaService.deletePengguna(
      memberId: memberId,
    );
    List data = getResponseTrxData(result);
    return data.map((dept) => PenggunaDAO.fromJson(dept)).first.memberId;
  }
}
