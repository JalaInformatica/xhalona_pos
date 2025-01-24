class VarianDAO {
  String partId;
  String varId;
  String varName;
  String varGroupId;
  String varGroupName;
  String? partName;
  String? companyId;

  VarianDAO({
    this.partId = "",
    this.varId = "",
    this.varName = "",
    this.varGroupId = "",
    this.varGroupName = "",
    this.partName,
    this.companyId,
  });

  VarianDAO.fromJson(Map<String, dynamic> json)
      : partId = json['PART_ID'] ?? "",
        varId = json['VARIAN_ID'] ?? "",
        varName = json['VARIAN_NAME'] ?? "",
        varGroupId = json['VARIAN_GROUP_ID'] ?? "",
        varGroupName = json['VARIAN_GROUP_NAME'] ?? "",
        partName = json['PART_NAME'],
        companyId = json['COMPANY_ID'];

  Map<String, dynamic> toJson() {
    return {
      'PART_ID': partId,
      'VARIAN_ID': varId,
      'VARIAN_NAME': varName,
      'VARIAN_GROUP_ID': varGroupId,
      'VARIAN_GROUP_NAME': varGroupName,
      'PART_NAME': partName,
      'COMPANY_ID': companyId,
    };
  }
}
