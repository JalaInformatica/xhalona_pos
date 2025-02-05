import 'package:xhalona_pos/models/dao/metodebayar.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/metodebayar/metodebayar_services.dart';

class MetodeBayarRepository extends AppRepository {
  MetodeBayarServices _MetodeBayarService = MetodeBayarServices();

  Future<List<MetodeBayarDAO>> getMetodeBayar({
    int? pageNo,
    int? pageRow,
    String? filterValue,
    String? payMethodeGroup,
  }) async {
    var result = await _MetodeBayarService.getMetodeBayar(
        pageNo: pageNo,
        pageRow: pageRow,
        filterValue: filterValue,
        payMethodeGroup: payMethodeGroup);
    List data = getResponseListData(result);
    return data
        .map((MetodeBayar) => MetodeBayarDAO.fromJson(MetodeBayar))
        .toList();
  }

  Future<String> addEditMetodeBayar({
    String? payMethodeId,
    String? payMethodeGroup,
    String? payMethodeName,
    String? isCash,
    String? isCard,
    String? isDefault,
    String? isfixAmt,
    String? isbellowAmt,
    String? isActive,
    String? isPiutang,
    String? isnumberCard,
    String? actionId,
  }) async {
    var result = await _MetodeBayarService.addEditMetodeBayar(
      payMethodeId: payMethodeId,
      payMethodeGroup: payMethodeGroup,
      payMethodeName: payMethodeName,
      isCash: isCash,
      isCard: isCard,
      isDefault: isDefault,
      isfixAmt: isfixAmt,
      isbellowAmt: isbellowAmt,
      isPiutang: isPiutang,
      isnumberCard: isnumberCard,
      isActive: isActive,
      actionId: actionId,
    );
    List data = getResponseTrxData(result);
    return data
        .map((kustomer) => MetodeBayarDAO.fromJson(kustomer))
        .first
        .payMetodeId;
  }

  Future<String> deleteMetodeBayar({
    String? payMethodeId,
  }) async {
    var result = await _MetodeBayarService.deleteMetodeBayar(
      payMethodeId: payMethodeId,
    );
    List data = getResponseTrxData(result);
    return data
        .map((kustomer) => MetodeBayarDAO.fromJson(kustomer))
        .first
        .payMetodeId;
  }
}
