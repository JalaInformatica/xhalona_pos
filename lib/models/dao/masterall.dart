class MasAllDAO {
  String createdBy;
  String groupMId;
  String companyId;
  String masterId;
  String masDesc;
  String masCategory;
  int rowId;
  String? isActive;

  MasAllDAO({
    this.createdBy = "",
    this.groupMId = "",
    this.companyId = "",
    this.masterId = "",
    this.masDesc = "",
    this.masCategory = "",
    this.rowId = 0,
    this.isActive,
  });

  MasAllDAO.fromJson(Map<String, dynamic> json)
      : createdBy = json['CREATEBY'] ?? "",
        groupMId = json['GROUP_MASTER_ID'] ?? "",
        companyId = json['COMPANY_ID'] ?? "",
        masterId = json['MASTER_ID'] ?? "",
        masDesc = json['MASTER_DESC'] ?? "",
        masCategory = json['MASTER_CATEGORY'] ?? "",
        rowId = json['ROW_ID'] ?? 0,
        isActive = json['IS_ACTIVE'];

  Map<String, dynamic> toJson() {
    return {
      'CREATEBY': createdBy,
      'GROUP_MASTER_ID': groupMId,
      'COMPANY_ID': companyId,
      'MASTER_ID': masterId,
      'MASTER_DESC': masDesc,
      'MASTER_CATEGORY': masCategory,
      'ROW_ID': rowId,
      'IS_ACTIVE': isActive,
    };
  }
}
