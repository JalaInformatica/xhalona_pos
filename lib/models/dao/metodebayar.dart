class MetodeBayarDAO {
  int rowNumber;
  int rowId;
  String companyId;
  String payMetodeId;
  String payMetodeName;
  String payMetodeGroup;
  bool isCard;
  bool isCash;
  bool isDefault;
  bool isActive;
  bool isFixHmt;
  bool isBellowHmt;

  MetodeBayarDAO({
    this.rowNumber = 0,
    this.companyId = "",
    this.payMetodeId = "",
    this.payMetodeName = "",
    this.payMetodeGroup = "",
    this.rowId = 0,
    this.isCard = false,
    this.isCash = false,
    this.isDefault = false,
    this.isActive = false,
    this.isFixHmt = false,
    this.isBellowHmt = false,
  });

  MetodeBayarDAO.fromJson(Map<String, dynamic> json)
      : rowNumber = json['ROW_NUMBER'] ?? 0,
        rowId = json['ROW_ID'] ?? 0,
        companyId = json['COMPANY_ID'] ?? "",
        payMetodeId = json['PAYMENT_METHOD_ID'] ?? "",
        payMetodeGroup = json['PAYMENT_METHOD_GROUP'] ?? "",
        payMetodeName = json['PAYMENT_METHOD_NAME'] ?? "",
        isCard = json['IS_CARD'] ?? false,
        isCash = json['IS_CASH'] ?? false,
        isDefault = json['IS_DEFAULT'] ?? false,
        isBellowHmt = json['IS_BELLOW_AMT'] ?? false,
        isActive = json['IS_ACTIVE'] ?? false,
        isFixHmt = json['IS_FIX_AMT'] ?? false;

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'ROW_NUMBER': rowNumber,
      'COMPANY_ID': companyId,
      'PAYMENT_METHOD_ID': payMetodeId,
      'PAYMENT_METHOD_NAME': payMetodeName,
      'PAYMENT_METHOD_GROUP': payMetodeGroup,
      'ROW_ID': rowId,
      'IS_CARD': isCard,
      'IS_CASH': isCash,
      'IS_DEFAULT': isDefault,
      'IS_ACTIVE': isActive,
      'IS_FIX_AMT': isFixHmt,
      'IS_BELLOW_AMT': isBellowHmt,
    };
  }
}
