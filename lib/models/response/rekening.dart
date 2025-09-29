class RekeningDAO {
  String companyId;
  String siteId;
  String acCurrecyId;
  String jenisAc;
  String acId;
  String namaAc;
  String? acNoReff;
  String? acGL;
  String? acGroupId;
  String? numberInCode;
  String? numberOutCode;
  String? bankName;
  String? bankAcName;
  bool? isActive;
  String? accesToUserId;

  RekeningDAO({
    this.companyId = "",
    this.siteId = "",
    this.acCurrecyId = "",
    this.jenisAc = "",
    this.acId = "",
    this.namaAc = "",
    this.acNoReff,
    this.acGL,
    this.acGroupId,
    this.numberInCode,
    this.numberOutCode,
    this.bankName,
    this.bankAcName,
    this.isActive,
    this.accesToUserId,
  });

  RekeningDAO.fromJson(Map<String, dynamic> json)
      : companyId = json['COMPANY_ID'] ?? "",
        siteId = json['SITE_ID'] ?? "",
        acCurrecyId = json['AC_CURRENCY_ID'] ?? "",
        jenisAc = json['JENIS_AC'] ?? "",
        acId = json['AC_ID'] ?? "",
        namaAc = json['NAMA_AC'] ?? "",
        acNoReff = json['AC_NO_REFF'],
        acGL = json['ACCOUNT_GL'],
        acGroupId = json['AC_GROUP_ID'],
        numberInCode = json['NUMBERING_CODE_IN'],
        numberOutCode = json['NUMBERING_CODE_OUT'],
        bankName = json['BANK_NAME'],
        bankAcName = json['BANK_ACCOUNT_NAME'],
        isActive = json['ISACTIVE'],
        accesToUserId = json['ACCESS_TO_USER_ID'];

  Map<String, dynamic> toJson() {
    return {
      'COMPANY_ID': companyId,
      'SITE_ID': siteId,
      'AC_CURRENCY_ID': acCurrecyId,
      'JENIS_AC': jenisAc,
      'AC_ID': acId,
      'NAMA_AC': namaAc,
      'AC_NO_REFF': acNoReff,
      'PROFILE_BIRTH_DATE': acGL,
      'AC_GROUP_ID': acGroupId,
      'NUMBERING_CODE_IN': numberInCode,
      'NUMBERING_CODE_OUT': numberOutCode,
      'BANK_NAME': bankName,
      'BANK_ACCOUNT_NAME': bankAcName,
      'ISACTIVE': isActive,
      'ACCESS_TO_USER_ID': accesToUserId,
    };
  }
}
