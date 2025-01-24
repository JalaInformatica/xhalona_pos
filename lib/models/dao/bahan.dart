class BahanDAO {
  String partId;
  String unitId;
  String bomPartId;
  String bomPartName;
  String? partName;
  String? companyId;
  int rowId;

  BahanDAO({
    this.partId = "",
    this.unitId = "",
    this.bomPartId = "",
    this.bomPartName = "",
    this.partName,
    this.companyId,
    this.rowId = 0,
  });

  BahanDAO.fromJson(Map<String, dynamic> json)
      : partId = json['PART_ID'] ?? "",
        unitId = json['UNIT_ID'] ?? "",
        bomPartId = json['BOM_PART_ID'] ?? "",
        bomPartName = json['BOM_PART_NAME'] ?? "",
        partName = json['PART_NAME'],
        rowId = json['ROW_ID'] ?? 0,
        companyId = json['COMPANY_ID'];

  Map<String, dynamic> toJson() {
    return {
      'PART_ID': partId,
      'UNIT_ID': unitId,
      'BOM_PART_ID': bomPartId,
      'BOM_PART_NAME': bomPartName,
      'PART_NAME': partName,
      'ROW_ID': rowId,
      'COMPANY_ID': companyId,
    };
  }
}
