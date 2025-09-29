class KasBankDetailDAO {
  int rowId;
  int rowNumber;
  String detCompanyId;
  String detSiteId;
  String detCurrencyId;
  String detVoucherNo;
  String acId;
  String namaRek;
  int qty;
  int priceUnit;
  String uraianDet;
  String flagDK;
  String acIdFull;
  String invoiceDate;

  KasBankDetailDAO({
    this.rowNumber = 0,
    this.detCompanyId = "",
    this.detSiteId = "",
    this.detCurrencyId = "",
    this.detVoucherNo = "",
    this.rowId = 0,
    this.acId = "",
    this.namaRek = "",
    this.uraianDet = "",
    this.flagDK = "",
    this.acIdFull = "",
    this.invoiceDate = "",
    this.qty = 0,
    this.priceUnit = 0,
  });

  KasBankDetailDAO.fromJson(Map<String, dynamic> json)
      : rowNumber = json['ROW_NUMBER'] ?? 0,
        rowId = json['ROW_ID'] ?? 0,
        detCompanyId = json['DET_COMPANY_ID'] ?? "",
        detSiteId = json['DET_SITE_ID'] ?? "",
        detCurrencyId = json['DET_CURRENCY_ID'] ?? "",
        detVoucherNo = json['DET_VOUCHER_NO'] ?? "",
        acId = json['ACCOUNT_ID'] ?? "",
        namaRek = json['NAMA_REKENING'] ?? "",
        uraianDet = json['URAIAN_DET'] ?? "",
        flagDK = json['FLAG_DK'] ?? "",
        acIdFull = json['ACCOUNT_ID_FULL'] ?? "",
        invoiceDate = json['INVOICE_DATE'] ?? "",
        priceUnit = json['PRICE_UNIT'] ?? 0,
        qty = json['QTY'] ?? 0;

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'ROW_NUMBER': rowNumber,
      'DET_COMPANY_ID': detCompanyId,
      'DET_SITE_ID': detSiteId,
      'DET_CURRENCY_ID': detCurrencyId,
      'DET_VOUCHER_NO': detVoucherNo,
      'ROW_ID': rowId,
      'ACCOUNT_ID': acId,
      'NAMA_REKENING': namaRek,
      'URAIAN_DET': uraianDet,
      'FLAG_DK': flagDK,
      'ACCOUNT_ID_FULL': acIdFull,
      'INVOICE_DATE': invoiceDate,
      'QTY': qty,
      'PRICE_UNIT': priceUnit,
    };
  }
}
