class PaketDAO {
  String partId;
  String comPartId;
  int comValue;
  int comUnitPrice;
  String companyId;
  String? partName;
  String? cpartName;
  int? rowId;

  PaketDAO(
      {this.partId = "",
      this.comPartId = "",
      this.comValue = 0,
      this.comUnitPrice = 0,
      this.companyId = "",
      this.partName,
      this.cpartName,
      this.rowId});

  PaketDAO.fromJson(Map<String, dynamic> json)
      : partId = json['PART_ID'] ?? "",
        comPartId = json['COMPONENT_PART_ID'] ?? "",
        comValue = json['COMPONENT_VALUE'] ?? 0,
        comUnitPrice = json['COMPONENT_UNIT_PRICE'] ?? 0,
        companyId = json['COMPANYID'] ?? "",
        partName = json['PART_NAME'],
        cpartName = json['COMPONENT_PART_NAME'],
        rowId = json['ROW_ID'];

  Map<String, dynamic> toJson() {
    return {
      'PART_ID': partId,
      'COMPONENT_PART_ID': comPartId,
      'COMPONENT_VALUE': comValue,
      'COMPONENT_UNIT_PRICE': comUnitPrice,
      'COMPANYID': companyId,
      'PART_NAME': partName,
      'COMPONENT_PART_NAME': cpartName,
      'ROW_ID': rowId,
    };
  }
}
