class KasBankDAO {
  int rowNumber;
  String moduleId;
  String subModuleId;
  String currencyId;
  String siteId;
  String voucherNo;
  String voucherDate;
  String groupId;
  int rowId;
  int brutoVal;
  String acId;
  String namaAc;
  String jenisAc;
  String refId;
  String invoiceNo;
  String invoiceDate;
  String ket;
  String refName;
  String refPhone1;
  int jmlBayar;
  int nettoVal;
  bool isActive;
  String paySourceId;
  String accesUserId;
  bool isHaveDetail;
  bool isApproved;
  String createDate;
  String createBy;

  KasBankDAO({
    this.rowNumber = 0,
    this.moduleId = "",
    this.subModuleId = "",
    this.currencyId = "",
    this.siteId = "",
    this.voucherNo = "",
    this.voucherDate = "",
    this.groupId = "",
    this.rowId = 0,
    this.brutoVal = 0,
    this.acId = "",
    this.namaAc = "",
    this.jenisAc = "",
    this.refId = "",
    this.invoiceNo = "",
    this.invoiceDate = "",
    this.ket = "",
    this.refName = "",
    this.refPhone1 = "",
    this.jmlBayar = 0,
    this.nettoVal = 0,
    this.isActive = false,
    this.paySourceId = "",
    this.accesUserId = "",
    this.isHaveDetail = false,
    this.isApproved = false,
    this.createDate = "",
    this.createBy = "",
  });

  KasBankDAO.fromJson(Map<String, dynamic> json)
      : rowNumber = json['ROW_NUMBER'] ?? 0,
        rowId = json['ROW_ID'] ?? 0,
        moduleId = json['MODULE_ID'] ?? "",
        subModuleId = json['SUBMODULE_ID'] ?? "",
        siteId = json['SITE_ID'] ?? "",
        currencyId = json['CURRENCY_ID'] ?? "",
        isApproved = json['IS_APPROVED'] ?? false,
        isActive = json['IS_ACTIVE'] ?? false,
        createDate = json['CREATEDATE'] ?? "",
        createBy = json['CREATEBY'] ?? "",
        voucherNo = json['VOUCHER_NO'] ?? "",
        voucherDate = json['VOUCHER_DATE'] ?? "",
        groupId = json['GROUP_ID'] ?? "",
        acId = json['AC_ID'] ?? "",
        namaAc = json['NAMA_AC'] ?? "",
        jenisAc = json['JENIS_AC'] ?? "",
        refId = json['REFFERENCE_ID'] ?? "",
        invoiceNo = json['INVOICE_NO'] ?? "",
        invoiceDate = json['INVOICE_DATE'] ?? "",
        ket = json['KETERANGAN'] ?? "",
        refName = json['REFFERENCE_NAME'] ?? "",
        refPhone1 = json['REFFERENCE_PHONE1'] ?? "",
        isHaveDetail = json['IS_HAVE_DETAIL'] ?? false,
        paySourceId = json['PAYMENT_SOURCE_ID'] ?? "",
        brutoVal = json['BRUTO_VAL'] ?? 0,
        nettoVal = json['NETTO_VAL'] ?? 0,
        jmlBayar = json['JUMLAH_BAYAR'] ?? 0,
        accesUserId = json['ACCESS_TO_USER_ID'] ?? "";

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'ROW_NUMBER': rowNumber,
      'MODULE_ID': moduleId,
      'SUBMODULE_ID': subModuleId,
      'CURRENCY_ID': currencyId,
      'SITE_ID': siteId,
      'VOUCHER_NO': voucherNo,
      'VOUCHER_DATE': voucherDate,
      'GROUP_ID': groupId,
      'ROW_ID': rowId,
      'BRUTO_VAL': brutoVal,
      'AC_ID': acId,
      'NAMA_AC': namaAc,
      'JENIS_AC': jenisAc,
      'REFFERENCE_ID': refId,
      'INVOICE_NO': invoiceNo,
      'INVOICE_DATE': invoiceDate,
      'KETERANGAN': ket,
      'REFFERENCE_NAME': refName,
      'REFFERENCE_PHONE1': refPhone1,
      'JUMLAH_BAYAR': jmlBayar,
      'NETTO_VAL': nettoVal,
      'IS_ACTIVE': isActive,
      'PAYMENT_SOURCE_ID': paySourceId,
      'ACCESS_TO_USER_ID': accesUserId,
      'IS_HAVE_DETAIL': isHaveDetail,
      'IS_APPROVED': isApproved,
      'CREATEDATE': createDate,
      'CREATEBY': createBy,
    };
  }
}
