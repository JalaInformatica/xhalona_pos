class TransactionDTO {
  String salesId;
  String supplierId;
  String guestName;
  String guestPhone;
  String note;
  String voucherCode;
  String shiftId;

  TransactionDTO({
    this.salesId = "",
    this.supplierId = "",
    this.guestName = "",
    this.guestPhone = "",
    this.note = "",
    this.voucherCode = "",
    this.shiftId = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "SALES_ID": salesId,
      "SUPPLIER_ID": supplierId,
      "GUEST_NAME": guestName,
      "GUEST_PHONE": guestPhone,
      "NOTE": note,
      "VOUCHER_CODE": voucherCode,
      "SHIFT_ID": shiftId,
    };
  }
}

class TransactionDetailDTO {
  String salesId;
  String partId;
  int qty;
  int deductionPct;
  int deductionVal;
  int addCostPct;
  int addCostVal;
  String employeeId;
  int isFreePick;
  int price;
  String detNote;
  String employeeId2;
  String employeeId3;
  String employeeId4;

  TransactionDetailDTO({
    this.salesId = "",
    this.partId = "",
    this.qty = 0,
    this.deductionPct = 0,
    this.deductionVal = 0,
    this.addCostPct = 0,
    this.addCostVal = 0,
    this.employeeId = "",
    this.isFreePick = 0,
    this.price = 0,
    this.detNote = "",
    this.employeeId2 = "",
    this.employeeId3 = "",
    this.employeeId4 = "",
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      "SALES_ID": salesId,
      "PART_ID": partId,
      "QTY": qty,
      "DEDUCTION_PCT": deductionPct.toString(),
      "DEDUCTION_VAL": deductionVal.toString(),
      "ADD_COST_PCT": addCostPct.toString(),
      "ADD_COST_VAL": addCostVal.toString(),
      "EMPLOYEE_ID": employeeId,
      "IS_FREE_PICK": isFreePick.toString(),
      "PRICE": price.toString(),
      "DET_NOTE": detNote,
      "EMPLOYEE_ID2": employeeId2,
      "EMPLOYEE_ID3": employeeId3,
      "EMPLOYEE_I4": employeeId4,
    };
  }
}