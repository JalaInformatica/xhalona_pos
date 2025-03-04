import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/kustomer/kustomer_services.dart';

class KustomerRepository extends AppRepository {
  KustomerServices _KustomerService = KustomerServices();

  Future<List<KustomerDAO>> getKustomer({
    int? pageNo,
    int? pageRow,
    String? isActive,
    String? filterValue,
    String? isSuplier,
  }) async {
    var result = await _KustomerService.getKustomer(
        pageNo: pageNo,
        pageRow: pageRow,
        filterValue: filterValue,
        isSuplier: isSuplier);
    List data = getResponseListData(result);
    return data.map((Kustomer) => KustomerDAO.fromJson(Kustomer)).toList();
  }

  Future<String> addEditKustomer({
    String? suplierId,
    String? suplierName,
    String? adress1,
    String? adress2,
    String? telp,
    String? emailAdress,
    String? isPayable,
    String? isCompliment,
    String? isSuplier,
    String? actionId,
  }) async {
    var result = await _KustomerService.addEditKustomer(
      suplierId: suplierId,
      suplierName: suplierName,
      adress1: adress1,
      adress2: adress2,
      telp: telp,
      emailAdress: emailAdress,
      isPayable: isPayable,
      isCompliment: isCompliment,
      isSuplier: isSuplier,
      actionId: actionId,
    );
    return getResponseTrxData(result).first["NO_TRX"];
  }

  Future<String> deleteKustomer({
    String? suplierId,
  }) async {
    var result = await _KustomerService.deleteKustomer(
      suplierId: suplierId,
    );
    List data = getResponseTrxData(result);
    return data
        .map((kustomer) => KustomerDAO.fromJson(kustomer))
        .first
        .suplierId;
  }
}
