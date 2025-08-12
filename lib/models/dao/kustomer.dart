class KustomerDAO {
  String suplierId;
  String suplierName;
  String address2;
  String address1;
  String telp;
  String emailAdress;
  String? scID;
  String? createdBy;
  bool isPayable;
  bool isCompliment;
  num totalStamp;
  num totalWallet;

  KustomerDAO({
    this.suplierId = "",
    this.suplierName = "",
    this.address2 = "",
    this.address1 = "",
    this.telp = "",
    this.emailAdress = "",
    this.scID,
    this.createdBy,
    this.isPayable = false,
    this.isCompliment = false,
    this.totalStamp = 0,
    this.totalWallet = 0
  });

  KustomerDAO.fromJson(Map<String, dynamic> json)
      : suplierId = json['SUPPLIER_ID'] ?? "",
        suplierName = json['SUPPLIER_NAME'] ?? "",
        address2 = json['ADDRESS2'] ?? "",
        address1 = json['ADDRESS1'] ?? "",
        telp = json['TELP'] ?? "",
        emailAdress = json['EMAIL_ADDRESS'] ?? "",
        scID = json['SOURCE_ID'] ?? '',
        isPayable = json['IS_PAYABLE'] ?? false,
        isCompliment = json['IS_COMPLIMENT'] ?? false,
        createdBy = json['CREATEBY'] ?? '',
        totalStamp = json['TOTAL_STAMP_VALUE'] ?? 0,
        totalWallet = json['TOTAL_WALLET_VALUE'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'SUPPLIER_ID': suplierId,
      'SUPPLIER_NAME': suplierName,
      'ADDRESS2': address2,
      'ADDRESS1': address1,
      'TELP': telp,
      'EMAIL_ADDRESS': emailAdress,
      'SOURCE_ID': scID,
      'CREATEBY': createdBy,
    };
  }
}
