import 'package:xhalona_pos/models/response/kasbankdetail.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/kasbank/kasbankdetail_services.dart';

class KasBankDetailRepository extends AppRepository {
  KasBankDetailServices _kasBankDetailService = KasBankDetailServices();

  Future<List<KasBankDetailDAO>> getKasBankDetail({
    String? vocherNo,
  }) async {
    var result = await _kasBankDetailService.getKasBankDetail(
      vocherNo: vocherNo,
    );
    List data = getResponseListData(result);
    return data
        .map((kasBankDetail) => KasBankDetailDAO.fromJson(kasBankDetail))
        .toList();
  }

  Future<String> addEditKasBankDetail({
    String? acId,
    String? voucerNo,
    String? qty,
    String? priceUnit,
    String? flagDk,
    String? uraianDet,
    String? rowId,
    String? actionId,
  }) async {
    var result = await _kasBankDetailService.addEditKasBankDetail(
      acId: acId,
      qty: qty,
      priceUnit: priceUnit,
      flagDk: flagDk,
      voucerNo: voucerNo,
      uraianDet: uraianDet,
      rowId: rowId,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data
        .map((kustomer) => KasBankDetailDAO.fromJson(kustomer))
        .first
        .acId;
  }

  Future<String> deleteKasBankDetail({
    String? voucerNo,
    String? rowId,
  }) async {
    var result = await _kasBankDetailService.deleteKasBankDetail(
        voucerNo: voucerNo, rowId: rowId);
    List data = getResponseTrxData(result);
    return data
        .map((kustomer) => KasBankDetailDAO.fromJson(kustomer))
        .first
        .acId;
  }
}
