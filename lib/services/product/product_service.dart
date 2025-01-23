import 'dart:convert';
import 'package:xhalona_pos/services/response_handler.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;

class ProductService {
  Future<String> getProducts(
      {int? pageNo,
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
      String? filterValue}) async {
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

  Future<String> addEditProduct({
    String? partId,
    String? partName,
    String? deskripsi,
    String? actionId,
    String? analisaId,
    String? analisaIdGlobal,
    int? isFixQty,
    int? isFixPrice,
    int? isFree,
    int? isPacket,
    int? isStock,
    String? unit1,
    int? discPct,
    int? discVal,
    int? unitPrice,
    String? isActive,
    int? isPromo,
    String? thumbImage,
    String? mainImage,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_produk';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": actionId == '1' ? "EDIT_H" : "ADD_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "PART_ID": partId,
        "PART_NAME": partName,
        "SPEC": deskripsi,
        "ANALISA_ID": analisaId,
        "ANALISA_ID_GLOBAL": analisaIdGlobal,
        "IS_FIX_QTY": isFixQty,
        "IS_FIX_PRICE": isFixPrice,
        "IS_FREE": isFree,
        "IS_PACKET": isPacket,
        "IS_STOCK": isStock,
        "UNIT_1": unit1,
        "DISCOUNT_PCT": discPct,
        "DISCOUNT_VAL": discVal,
        "UNIT_PRICE": unitPrice,
        "IS_ACTIVE": isActive,
        "IS_PROMO": isPromo,
        "THUMB_IMAGE": thumbImage,
        "MAIN_IMAGE": mainImage,
        "IMG_THUMB": "",
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }

  Future<String> deleteProduct({
    String? partId,
  }) async {
    await api.fetchUserSessionInfo();
    var url = '/SALES/m_produk';
    var body = jsonEncode({
      "rq": {
        "ACTION_ID": "DELETE_H",
        "IP": api.ip,
        "COMPANY_ID": api.companyId,
        "SITE_ID": "",
        "USER_ID": api.userId,
        "SESSION_LOGIN_ID": api.sessionId,
        "DATA": [
          {"PART_ID": partId}
        ]
      }
    });

    var response =
        await api.post(url, headers: await api.requestHeaders(), body: body);

    return ResponseHandler.handle(response);
  }
}
