class ReportDAO {
  String salesId;
  String salesDate;
  String supplierId;
  String telp;
  String supplierName;
  String note;
  int brutoVal;
  int addCostVal;
  int discPct;
  int discVal;
  int pphPct;
  int pphVal;
  int ppnPct;
  int ppnVal;
  int nettoVal;
  String statusIdDesc;
  String settlePaymentMethod;
  int settlePaymentVal;
  String settleDate;
  String settleBy;
  String settleCardNumber;
  int queueNumber;
  String currencyId;
  int addCostPct;
  bool isActive;
  String partId;
  int qty;
  int price;
  int deductionPct;
  int deductionVal;
  String fullName;
  String employeeId;
  int totalPrice;
  int nettoValD;
  String partName;
  String ketAnalisa;
  int employeeFeeVal;
  String parentPartId;
  String parentPartName;
  bool isCash;
  bool isCard;
  int totalCash;
  int totalNonCash;
  int totalCompliment;
  int totalHutang;
  String shiftId;
  String createDate;

  ReportDAO({
    this.salesId = "",
    this.salesDate = "",
    this.supplierId = "",
    this.telp = "",
    this.supplierName = "",
    this.note = "",
    this.brutoVal = 0,
    this.addCostVal = 0,
    this.discPct = 0,
    this.discVal = 0,
    this.pphPct = 0,
    this.pphVal = 0,
    this.ppnPct = 0,
    this.ppnVal = 0,
    this.nettoVal = 0,
    this.statusIdDesc = "",
    this.settlePaymentMethod = "",
    this.settlePaymentVal = 0,
    this.settleDate = "",
    this.settleBy = "",
    this.settleCardNumber = "",
    this.queueNumber = 0,
    this.currencyId = "",
    this.addCostPct = 0,
    this.isActive = true,
    this.partId = "",
    this.qty = 0,
    this.price = 0,
    this.deductionPct = 0,
    this.deductionVal = 0,
    this.fullName = "",
    this.employeeId = "",
    this.totalPrice = 0,
    this.nettoValD = 0,
    this.partName = "",
    this.ketAnalisa = "",
    this.employeeFeeVal = 0,
    this.parentPartId = "",
    this.parentPartName = "",
    this.isCash = false,
    this.isCard = false,
    this.totalCash = 0,
    this.totalNonCash = 0,
    this.totalCompliment = 0,
    this.totalHutang = 0,
    this.shiftId = "",
    this.createDate = "",
  });

  ReportDAO.fromJson(Map<String, dynamic> json)
      : salesId = json['SALES_ID'] ?? "",
        salesDate = json['SALES_DATE'] ?? "",
        supplierId = json['SUPPLIER_ID'] ?? "",
        telp = json['TELP'] ?? "",
        supplierName = json['SUPPLIER_NAME'] ?? "",
        note = json['NOTE'] ?? "",
        brutoVal = json['BRUTO_VAL'] ?? 0,
        addCostVal = json['ADD_COST_VAL'] ?? 0,
        discPct = json['DISC_PCT'] ?? 0,
        discVal = json['DISC_VAL'] ?? 0,
        pphPct = json['PPH_PCT'] ?? 0,
        pphVal = json['PPH_VAL'] ?? 0,
        ppnPct = json['PPN_PCT'] ?? 0,
        ppnVal = json['PPN_VAL'] ?? 0,
        nettoVal = json['NETTO_VAL'] ?? 0,
        statusIdDesc = json['STATUS_ID_DESC'] ?? "",
        settlePaymentMethod = json['SETTLE_PAYMENT_METHOD'] ?? "",
        settlePaymentVal = json['SETTLE_PAYMENT_VAL'] ?? 0,
        settleDate = json['SETTLE_DATE'] ?? "",
        settleBy = json['SETTLE_BY'] ?? "",
        settleCardNumber = json['SETTLE_CARD_NUMBER'] ?? "",
        queueNumber = json['QUEUE_NUMBER'] ?? 0,
        currencyId = json['CURRENCY_ID'] ?? "",
        addCostPct = json['ADD_COST_PCT'] ?? 0,
        isActive = json['IS_ACTIVE'] ?? true,
        partId = json['PART_ID'] ?? "",
        qty = json['QTY'] ?? 0,
        price = json['PRICE'] ?? 0,
        deductionPct = json['DEDUCTION_PCT'] ?? 0,
        deductionVal = json['DEDUCTION_VAL'] ?? 0,
        fullName = json['FULL_NAME'] ?? "",
        employeeId = json['EMPLOYEE_ID'] ?? "",
        totalPrice = json['TOTAL_PRICE'] ?? 0,
        nettoValD = json['NETTO_VAL_D'] ?? 0,
        partName = json['PART_NAME'] ?? "",
        ketAnalisa = json['KET_ANALISA'] ?? "",
        employeeFeeVal = json['FEE_EMPLOYEE_VAL'] ?? 0,
        parentPartId = json['PARENT_PART_ID'] ?? "",
        parentPartName = json['PARENT_PART_NAME'] ?? "",
        isCash = json['IS_CASH'] ?? false,
        isCard = json['IS_CARD'] ?? false,
        totalCash = json['TOTAL_CASH'] ?? 0,
        totalNonCash = json['TOTAL_NON_CASH'] ?? 0,
        totalCompliment = json['TOTAL_COMPLIMENT'] ?? 0,
        totalHutang = json['TOTAL_HUTANG'] ?? 0,
        shiftId = json['SHIFT_ID'] ?? "",
        createDate = json['CREATEDATE'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      'SALES_ID': salesId,
      'SALES_DATE': salesDate,
      'SUPPLIER_ID': supplierId,
      'TELP': telp,
      'SUPPLIER_NAME': supplierName,
      'NOTE': note,
      'BRUTO_VAL': brutoVal,
      'ADD_COST_VAL': addCostVal,
      'DISC_PCT': discPct,
      'DISC_VAL': discVal,
      'PPH_PCT': pphPct,
      'PPH_VAL': pphVal,
      'PPN_PCT': ppnPct,
      'PPN_VAL': ppnVal,
      'NETTO_VAL': nettoVal,
      'STATUS_ID_DESC': statusIdDesc,
      'SETTLE_PAYMENT_METHOD': settlePaymentMethod,
      'SETTLE_PAYMENT_VAL': settlePaymentVal,
      'SETTLE_DATE': settleDate,
      'SETTLE_BY': settleBy,
      'SETTLE_CARD_NUMBER': settleCardNumber,
      'QUEUE_NUMBER': queueNumber,
      'CURRENCY_ID': currencyId,
      'ADD_COST_PCT': addCostPct,
      'IS_ACTIVE': isActive,
      'PART_ID': partId,
      'QTY': qty,
      'PRICE': price,
      'DEDUCTION_PCT': deductionPct,
      'DEDUCTION_VAL': deductionVal,
      'FULL_NAME': fullName,
      'EMPLOYEE_ID': employeeId,
      'TOTAL_PRICE': totalPrice,
      'NETTO_VAL_D': nettoValD,
      'PART_NAME': partName,
      'KET_ANALISA': ketAnalisa,
      'FEE_EMPLOYEE_VAL': employeeFeeVal,
      'PARENT_PART_ID': parentPartId,
      'PARENT_PART_NAME': parentPartName,
      'IS_CASH': isCash,
      'IS_CARD': isCard,
      'TOTAL_CASH': totalCash,
      'TOTAL_NON_CASH': totalNonCash,
      'TOTAL_COMPLIMENT': totalCompliment,
      'TOTAL_HUTANG': totalHutang,
      'SHIFT_ID': shiftId,
      'CREATEDATE': createDate,
    };
  }
}