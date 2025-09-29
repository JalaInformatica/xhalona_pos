class SessionResponse {
  String sessionLoginId;
  DateTime loginDate;
  int loginIsExpired;
  String loginIpFrom;
  String companyId;
  String defCompanyId;
  String defSiteId;
  String roleId;

  SessionResponse({
    required this.sessionLoginId,
    required this.loginDate,
    required this.loginIsExpired,
    required this.loginIpFrom,
    required this.companyId,
    required this.defCompanyId,
    required this.defSiteId,
    required this.roleId,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      sessionLoginId: json['SESSION_LOGIN_ID'] ?? "",
      loginDate: json['LOGIN_DATE'] != null ? DateTime.tryParse(json['LOGIN_DATE']) ?? DateTime(1970, 1, 1) : DateTime(1970, 1, 1),
      loginIsExpired: json['LOGIN_IS_EXPIRED'] ?? 0,
      loginIpFrom: json['LOGIN_IP_FROM'] ?? "",
      companyId: json['COMPANY_ID'] ?? "",
      defCompanyId: json['DEF_COMPANY_ID'] ?? "",
      defSiteId: json['DEF_SITE_ID'] ?? "",
      roleId: json['ROLE_ID'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SESSION_LOGIN_ID': sessionLoginId,
      'LOGIN_DATE': loginDate.toIso8601String(),
      'LOGIN_IS_EXPIRED': loginIsExpired,
      'LOGIN_IP_FROM': loginIpFrom,
      'COMPANY_ID': companyId,
      'DEF_COMPANY_ID': defCompanyId,
      'DEF_SITE_ID': defSiteId,
      'ROLE_ID': roleId,
    };
  }
}