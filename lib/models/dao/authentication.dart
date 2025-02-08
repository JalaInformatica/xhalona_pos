class LoginDAO {
  String userId;
  String userName;
  String sessionLoginId;
  String companyId;
  String defCompanyId;
  String defSiteId;
  String loginDate;
  String loginIpFrom;
  int loginIsExpired;
  String roleId;

  // Default constructor with optional named parameters
  LoginDAO({
    this.userId = "",
    this.userName = "",
    this.sessionLoginId = "",
    this.companyId = "",
    this.defCompanyId = "",
    this.defSiteId = "",
    this.loginDate = "",
    this.loginIpFrom = "",
    this.loginIsExpired = 0,
    this.roleId = "",
  });

  // Named constructor to create an instance from a JSON object
  LoginDAO.fromJson(Map<String, dynamic> json)
      : userId = json['USER_ID'] ?? "",
        userName = json['UserName'] ?? "",
        sessionLoginId = json['SESSION_LOGIN_ID'] ?? "",
        companyId = json['COMPANY_ID'] ?? "",
        defCompanyId = json['DEF_COMPANY_ID'] ?? "",
        defSiteId = json['DEF_SITE_ID'] ?? "",
        loginDate = json['LOGIN_DATE'] ?? "",
        loginIpFrom = json['LOGIN_IP_FROM'] ?? "",
        loginIsExpired = json['LOGIN_IS_EXPIRED'] ?? 0,
        roleId = json['ROLE_ID'] ?? "";

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'SESSION_LOGIN_ID': sessionLoginId,
      'COMPANY_ID': companyId,
      'DEF_COMPANY_ID': defCompanyId,
      'DEF_SITE_ID': defSiteId,
      'LOGIN_DATE': loginDate,
      'LOGIN_IP_FROM': loginIpFrom,
      'LOGIN_IS_EXPIRED': loginIsExpired,
      'ROLE_ID': roleId,
    };
  }
}
