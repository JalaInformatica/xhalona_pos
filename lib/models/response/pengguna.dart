class PenggunaDAO {
  String userId;
  String userName;
  String emailAddress;
  String rId;
  String memberId;
  String companyId;
  int? levelId;
  String? deptId;
  bool? isActive;
  String? empId;
  String? defCompanyId;
  String? defSiteId;
  String? roleId;

  PenggunaDAO({
    this.userId = "",
    this.userName = "",
    this.emailAddress = "",
    this.rId = "",
    this.memberId = "",
    this.companyId = "",
    this.levelId,
    this.deptId,
    this.isActive,
    this.empId,
    this.defCompanyId,
    this.defSiteId,
    this.roleId,
  });

  PenggunaDAO.fromJson(Map<String, dynamic> json)
      : userId = json['USER_ID'] ?? "",
        userName = json['USERNAME'] ?? "",
        emailAddress = json['EMAILADDRESS'] ?? "",
        rId = json['R_ID'] ?? "",
        memberId = json['MEMBER_ID'] ?? "",
        companyId = json['COMPANYID'] ?? "",
        levelId = json['LEVELID'],
        deptId = json['DEPARTMENTID'],
        isActive = json['ISACTIVE'],
        empId = json['EMP_ID'],
        defCompanyId = json['DEF_COMPANY_ID'],
        defSiteId = json['DEF_SITE_ID'],
        roleId = json['ROLE_ID'];

  Map<String, dynamic> toJson() {
    return {
      'USER_ID': userId,
      'USERNAME': userName,
      'EmailAddress': emailAddress,
      'R_ID': rId,
      'LevelID': memberId,
      'COMPANYID': companyId,
      'LEVELID': levelId,
      'DEPARTMENTID': deptId,
      'ISACTIVE': isActive,
      'EMP_ID': empId,
      'DEF_COMPANY_ID': defCompanyId,
      'DEF_SITE_ID': defSiteId,
      'ROLE_ID': roleId,
    };
  }
}
