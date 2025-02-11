class MonitorDAO {
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
  String settlePaymentMethod;
  int settlePaymentVal;
  String settleDate;
  String settleBy;
  String settleCardNumber;
  int queueNumber;
  String currencyId;
  int addCostPct;
  String partId;
  bool isActive;
  int qty;
  int price;
  int deductionVal;
  int deductionPct;
  String fullName;
  String empId;
  int totalPrice;
  int nettoValD;
  String partName;
  String ketAnalisa;
  int feeEmpVal;
  String pPartId;
  String pPartName;
  bool isCard;
  bool isCash;
  int totalCash;
  int totalNonCash;
  int totalCompliment;
  int totalHutang;
  String shiftId;
  String createDate;

  MonitorDAO({
    this.pphPct = 0,
    this.pphVal = 0,
    this.currencyId = "",
    this.partId = "",
    this.salesId = "",
    this.salesDate = "",
    this.qty = 0,
    this.price = 0,
    this.brutoVal = 0,
    this.note = "",
    this.supplierId = "",
    this.supplierName = "",
    this.telp = "",
    this.deductionVal = 0,
    this.deductionPct = 0,
    this.fullName = "",
    this.empId = "",
    this.ketAnalisa = "",
    this.addCostPct = 0,
    this.addCostVal = 0,
    this.discPct = 0,
    this.discVal = 0,
    this.ppnPct = 0,
    this.ppnVal = 0,
    this.totalPrice = 0,
    this.nettoValD = 0,
    this.feeEmpVal = 0,
    this.nettoVal = 0,
    this.isActive = false,
    this.partName = "",
    this.pPartId = "",
    this.pPartName = "",
    this.settlePaymentMethod = "",
    this.settlePaymentVal = 0,
    this.settleDate = "",
    this.settleBy = "",
    this.settleCardNumber = "",
    this.queueNumber = 0,
    this.isCard = false,
    this.shiftId = "",
    this.totalCash = 0,
    this.totalNonCash = 0,
    this.totalCompliment = 0,
    this.totalHutang = 0,
    this.isCash = false,
    this.createDate = "",
  });

  MonitorDAO.fromJson(Map<String, dynamic> json)
      : pphPct = json['PPH_PCT'] ?? 0,
        pphVal = json['PPH_VAL'] ?? 0,
        currencyId = json['CURRENCY_ID'] ?? "",
        partId = json['SITE_ID'] ?? "",
        salesId = json['SALES_ID'] ?? "",
        salesDate = json['SALES_DATE'] ?? "",
        qty = json['ROW_ID'] ?? 0,
        price = json['TOTAL_QTY'] ?? 0,
        brutoVal = json['BRUTO_VAL'] ?? 0,
        note = json['NOTE'] ?? "",
        supplierId = json['SUPPLIER_ID'] ?? "",
        supplierName = json['SUPPLIER_NAME'] ?? "",
        telp = json['TELP'] ?? "",
        deductionVal = json['DEDUCTION_VAL'] ?? 0,
        deductionPct = json['DEDUCTION_PCT'] ?? 0,
        fullName = json['FULL_NAME'] ?? "",
        empId = json['EMPLOYEE_ID'] ?? "",
        ketAnalisa = json['KET_ANALISA'] ?? "",
        addCostPct = json['ADD_COST_PCT'] ?? 0,
        addCostVal = json['ADD_COST_VAL'] ?? 0,
        discPct = json['DISC_PCT'] ?? 0,
        discVal = json['DISC_VAL'] ?? 0,
        ppnPct = json['PPN_PCT'] ?? 0,
        ppnVal = json['PPN_VAL'] ?? 0,
        totalPrice = json['TOTAL_PRICE'] ?? 0,
        nettoValD = json['NETTO_VAL_D'] ?? 0,
        feeEmpVal = json['FEE_EMPLOYEE_VAL'] ?? 0,
        nettoVal = json['NETTO_VAL'] ?? 0,
        isActive = json['IS_ACTIVE'] ?? false,
        partName = json['PART_NAME'] ?? "",
        pPartId = json['PARENT_PART_ID'] ?? "",
        pPartName = json['PARENT_PART_NAME'] ?? "",
        settlePaymentMethod = json['SETTLE_PAYMENT_METHOD'] ?? "",
        settlePaymentVal = json['SETTLE_PAYMENT_VAL'] ?? 0,
        settleDate = json['SETTLE_DATE'] ?? "",
        settleBy = json['SETTLE_BY'] ?? "",
        settleCardNumber = json['SETTLE_CARD_NUMBER'] ?? "",
        queueNumber = json['QUEUE_NUMBER'] ?? 0,
        isCard = json['IS_CARD'] ?? false,
        shiftId = json['SHIFT_ID'] ?? "",
        totalCash = json['TOTAL_CASH'] ?? 0,
        totalNonCash = json['TOTAL_NON_CASH'] ?? 0,
        totalCompliment = json['TOTAL_COMPLIMENT'] ?? 0,
        totalHutang = json['TOTAL_HUTANG'] ?? 0,
        isCash = json['IS_CASH'] ?? false,
        createDate = json['CREATEDATE'] ?? "";

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'PPH_PCT': pphPct,
      'PPH_VAL': pphVal,
      'CURRENCY_ID': currencyId,
      'SITE_ID': partId,
      'SALES_ID': salesId,
      'SALES_DATE': salesDate,
      'ROW_ID': qty,
      'TOTAL_QTY': price,
      'BRUTO_VAL': brutoVal,
      'NOTE': note,
      'SUPPLIER_ID': supplierId,
      'SUPPLIER_NAME': supplierName,
      'TELP': telp,
      'DEDUCTION_VAL': deductionVal,
      'DEDUCTION_PCT': deductionPct,
      'FULL_NAME': fullName,
      'EMPLOYEE_ID': empId,
      'KET_ANALISA': ketAnalisa,
      'ADD_COST_PCT': addCostPct,
      'ADD_COST_VAL': addCostVal,
      'DISC_PCT': discPct,
      'DISC_VAL': discVal,
      'PPN_PCT': ppnPct,
      'PPN_VAL': ppnVal,
      'TOTAL_PRICE': totalPrice,
      'NETTO_VAL_D': nettoValD,
      'FEE_EMPLOYEE_VAL': feeEmpVal,
      'NETTO_VAL': nettoVal,
      'IS_ACTIVE': isActive,
      'PART_NAME': partName,
      'PARENT_PART_ID': pPartId,
      'PARENT_PART_NAME': pPartName,
      'SETTLE_PAYMENT_METHOD': settlePaymentMethod,
      'SETTLE_PAYMENT_VAL': settlePaymentVal,
      'SETTLE_DATE': settleDate,
      'SETTLE_BY': settleBy,
      'SETTLE_CARD_NUMBER': settleCardNumber,
      'QUEUE_NUMBER': queueNumber,
      'IS_CARD': isCard,
      'SHIFT_ID': shiftId,
      'TOTAL_CASH': totalCash,
      'TOTAL_NON_CASH': totalNonCash,
      'TOTAL_COMPLIMENT': totalCompliment,
      'TOTAL_HUTANG': totalHutang,
      'IS_CASH': isCash,
      'CREATEDATE': createDate,
    };
  }
}
