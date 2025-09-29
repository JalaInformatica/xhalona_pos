class KaryawanDAO {
  String companyId;
  String empId;
  String fullName;
  String dateIn;
  int isActive;
  String bpjsNo;
  String? bpjsTk;
  int? gender;
  String? birthDate;
  String? birthPlace;
  String? alamat;
  String? kd_dept;
  int? bonusAmount;
  int? bonusTarget;
  int? bonusTargetQty;
  int? rowNumber;

  KaryawanDAO({
    this.companyId = "",
    this.empId = "",
    this.fullName = "",
    this.dateIn = "",
    this.isActive = 0,
    this.bpjsNo = "",
    this.bpjsTk,
    this.gender,
    this.birthDate,
    this.birthPlace,
    this.alamat,
    this.kd_dept,
    this.bonusAmount,
    this.bonusTarget,
    this.bonusTargetQty,
    this.rowNumber,
  });

  KaryawanDAO.fromJson(Map<String, dynamic> json)
      : companyId = json['COMPANY_ID'] ?? "",
        empId = json['EMP_ID'] ?? "",
        fullName = json['FULL_NAME'] ?? "",
        dateIn = json['DATE_IN'] ?? "",
        isActive = json['IS_ACTIVE'] ?? 0,
        bpjsNo = json['BPJS_NO'] ?? "",
        bpjsTk = json['BPJS_TK'],
        gender = json['GENDER'],
        birthDate = json['BIRTHDATE'],
        birthPlace = json['BIRTHPLACE'],
        alamat = json['ALAMAT'],
        kd_dept = json['KD_DEPT'],
        bonusAmount = json['BONUS_AMOUNT'],
        bonusTarget = json['BONUS_TARGET'],
        bonusTargetQty = json['BONUS_TARGET_QTY'],
        rowNumber = json['ROW_NUMBER'];

  Map<String, dynamic> toJson() {
    return {
      'COMPANY_ID': companyId,
      'EMP_ID': empId,
      'FULL_NAME': fullName,
      'DATE_IN': dateIn,
      'LevelID': isActive,
      'BPJS_NO': bpjsNo,
      'BPJS_TK': bpjsTk,
      'GENDER': gender,
      'BIRTHDATE': birthDate,
      'BIRTHPLACE': birthPlace,
      'ALAMAT': alamat,
      'KD_DEPT': kd_dept,
      'BONUS_AMOUNT': bonusAmount,
      'PROFILE_KECAMATAN': bonusTarget,
      'PROFILE_PROVINSI': bonusTargetQty,
      'ROW_NUMBER': rowNumber,
    };
  }
}
