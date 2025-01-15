import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class ProductService {
  Future<String> getProducts({
    int? pageNo,
    int? pageRow,
    String? isActive,
    String? isStock,
    String? isPacket,
    String? isFixQty,
    String? isNonSales,
    String? isPromo,
    String? analisaIdGlobal,
    String? analisaId,
    String? partId,
    String? filterField,
    String? filterValue
    String? filterValue,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_produk';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "LIST_H_WEB",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "FILTER_FIELD": filterField ?? "",
        "FILTER_VALUE": filterValue ?? filterValue ?? '',
        "PAGE_NO": pageNo ?? 1,
        "PAGE_ROW": pageRow ?? 10,
        "SORT_ORDER_BY": "ROW_ID",
        "SORT_ORDER_TYPE": "DESC",
        "IS_ACTIVE": isActive ?? "",
        "IS_PACKET": isPacket ?? "",
        "IS_PROMO": isPromo ?? "",
        "IS_FIX_QTY": isFixQty ?? "",
        "IS_STOCK": isStock ?? "",
        "ANALISA_ID_GLOBAL": analisaIdGlobal ?? "",
        "ANALISA_ID": analisaId ?? "",
        "PART_ID": partId ?? "",
        "IS_NON_SALES": isNonSales ?? "",
      }
    });

    print('object: $body');
    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
