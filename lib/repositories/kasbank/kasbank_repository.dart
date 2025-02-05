import 'package:xhalona_pos/models/dao/kasbank.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/kasbank/kasbank_services.dart';

class KasBankRepository extends AppRepository {
  KasBankServices _KasBankService = KasBankServices();

  Future<List<KasBankDAO>> getKasBank({
    int? pageNo,
    int? pageRow,
    String? isActive,
    String? filterValue,
  }) async {
    var result = await _KasBankService.getKasBank(
        pageNo: pageNo, pageRow: pageRow, filterValue: filterValue);
    List data = getResponseListData(result);
    return data.map((KasBank) => KasBankDAO.fromJson(KasBank)).toList();
  }

  Future<String> addEditKasBank({
    String? acId,
    String? refID,
    String? subModulId,
    String? vocherDate,
    String? vocherNo,
    String? ket,
    String? actionId,
  }) async {
    var result = await _KasBankService.addEditKasBank(
      acId: acId,
      refID: refID,
      subModulId: subModulId,
      vocherDate: vocherDate,
      vocherNo: vocherNo,
      ket: ket,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data.map((kustomer) => KasBankDAO.fromJson(kustomer)).first.acId;
  }

  Future<String> deleteKasBank({
    String? voucherNo,
  }) async {
    var result = await _KasBankService.deleteKasBank(
      voucherNo: voucherNo,
    );
    List data = getResponseTrxData(result);
    return data.map((kustomer) => KasBankDAO.fromJson(kustomer)).first.acId;
  }

  Future<String> postingKasBank({
    String? voucherNo,
  }) async {
    var result = await _KasBankService.postingKasBank(
      voucherNo: voucherNo,
    );
    List data = getResponseTrxData(result);
    return data.map((kustomer) => KasBankDAO.fromJson(kustomer)).first.acId;
  }

  Future<String> unpostingKasBank({
    String? voucherNo,
  }) async {
    var result = await _KasBankService.unpostingKasBank(
      voucherNo: voucherNo,
    );
    List data = getResponseTrxData(result);
    return data.map((kustomer) => KasBankDAO.fromJson(kustomer)).first.acId;
  }

  Future<String> printKasBank({
    String? voucherNo,
  }) async {
    var result = await _KasBankService.printKasBank(
      voucherNo: voucherNo,
    );
    String url = getResponseURLData(result);
    return url;
  }
}
