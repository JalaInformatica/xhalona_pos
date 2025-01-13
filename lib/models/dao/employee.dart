class EmployeeDAO {
  String companyId;
  String empId;
  String fullName;
  String dateIn;
  int isActive;
  String? bpjsNo;
  String? bpjsTk;
  int gender;
  String birthDate;
  String birthPlace;
  String alamat;
  String kdDept;
  String createDate;
  String createBy;
  int bonusAmount;
  int bonusTarget;
  int bonusTargetQty;

  EmployeeDAO({
    this.companyId = "",
    this.empId = "",
    this.fullName = "",
    this.dateIn = "",
    this.isActive = 0,
    this.bpjsNo,
    this.bpjsTk,
    this.gender = 0,
    this.birthDate = "",
    this.birthPlace = "",
    this.alamat = "",
    this.kdDept = "",
    this.createDate = "",
    this.createBy = "",
    this.bonusAmount = 0,
    this.bonusTarget = 0,
    this.bonusTargetQty = 0,
  });

  // From JSON factory constructor
  EmployeeDAO.fromJson(Map<String, dynamic> json)
      : companyId = json['COMPANY_ID'] ?? "",
        empId = json['EMP_ID'] ?? "",
        fullName = json['FULL_NAME'] ?? "",
        dateIn = json['DATE_IN'] ?? "",
        isActive = json['IS_ACTIVE'] ?? 0,
        bpjsNo = json['BPJS_NO'],
        bpjsTk = json['BPJS_TK'],
        gender = json['GENDER'] ?? 0,
        birthDate = json['BIRTHDATE'] ?? "",
        birthPlace = json['BIRTHPLACE'] ?? "",
        alamat = json['ALAMAT'] ?? "",
        kdDept = json['KD_DEPT'] ?? "",
        createDate = json['CREATEDATE'] ?? "",
        createBy = json['CREATEBY'] ?? "",
        bonusAmount = json['BONUS_AMOUNT'] ?? 0,
        bonusTarget = json['BONUS_TARGET'] ?? 0,
        bonusTargetQty = json['BONUS_TARGET_QTY'] ?? 0;

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'COMPANY_ID': companyId,
      'EMP_ID': empId,
      'FULL_NAME': fullName,
      'DATE_IN': dateIn,
      'IS_ACTIVE': isActive,
      'BPJS_NO': bpjsNo,
      'BPJS_TK': bpjsTk,
      'GENDER': gender,
      'BIRTHDATE': birthDate,
      'BIRTHPLACE': birthPlace,
      'ALAMAT': alamat,
      'KD_DEPT': kdDept,
      'CREATEDATE': createDate,
      'CREATEBY': createBy,
      'BONUS_AMOUNT': bonusAmount,
      'BONUS_TARGET': bonusTarget,
      'BONUS_TARGET_QTY': bonusTargetQty,
    };
  }
}
