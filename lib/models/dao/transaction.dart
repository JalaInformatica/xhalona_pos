class TransactionHeaderDAO {
  int rowNumber;
  String companyId;
  String companyName;
  String currencyId;
  String siteId;
  String salesId;
  String salesDate;
  String salesDateFormatted;
  int rowId;
  int totalQty;
  int brutoVal;
  String note;
  String supplierId;
  String supplierName;
  String telp;
  String guestName;
  String guestPhone;
  String? bookingType;
  String? bookingDate;
  String? bookingDateBefore;
  int addCostPct;
  int addCostVal;
  int discPct;
  int discVal;
  int ppnPct;
  int ppnVal;
  int deliveryCostVal;
  int otherCost1Val;
  int otherCost2Val;
  int nettoVal;
  bool isCancel;
  String statusId;
  String statusIdDesc;
  String statusCategory;
  String? statusLastDate;
  String settlePaymentMethod;
  int settlePaymentVal;
  String settleDate;
  String settleBy;
  String settleCardNumber;
  int queueNumber;
  String paymentId;
  int paymentVal;
  int paymentBillVal;
  String? orderAddress;
  String? orderKelurahanId;
  String? orderPoint;
  String? orderDistance;
  String sourceId;
  bool storeIsHomeVisit;
  String storeMapLocation;
  String storeOperationalDay;
  String storeOperationalHour;
  String storeKecamatanId;
  String? promoDescription;
  String shiftId;
  int totalCash;
  int totalNonCash;
  int totalCompliment;
  int totalHutang;
  int kembalian;
  String companyAddress;
  String companyKecamatanId;
  String companyKotaId;
  String companyOfficePhone;
  String cashierBy;
  String statusDesc;
  String statusClosed;
  bool isEditable;
  String createDate;
  String createBy;
  List<Map<String, dynamic>> paymentList;

  TransactionHeaderDAO({
    this.rowNumber = 0,
    this.companyId = "",
    this.companyName = "",
    this.currencyId = "",
    this.siteId = "",
    this.salesId = "",
    this.salesDate = "",
    this.salesDateFormatted = "",
    this.rowId = 0,
    this.totalQty = 0,
    this.brutoVal = 0,
    this.note = "",
    this.supplierId = "",
    this.supplierName = "",
    this.telp = "",
    this.guestName = "",
    this.guestPhone = "",
    this.bookingType,
    this.bookingDate,
    this.bookingDateBefore,
    this.addCostPct = 0,
    this.addCostVal = 0,
    this.discPct = 0,
    this.discVal = 0,
    this.ppnPct = 0,
    this.ppnVal = 0,
    this.deliveryCostVal = 0,
    this.otherCost1Val = 0,
    this.otherCost2Val = 0,
    this.nettoVal = 0,
    this.isCancel = false,
    this.statusId = "",
    this.statusIdDesc = "",
    this.statusCategory = "",
    this.statusLastDate,
    this.settlePaymentMethod = "",
    this.settlePaymentVal = 0,
    this.settleDate = "",
    this.settleBy = "",
    this.settleCardNumber = "",
    this.queueNumber = 0,
    this.paymentId = "",
    this.paymentVal = 0,
    this.paymentBillVal = 0,
    this.orderAddress,
    this.orderKelurahanId,
    this.orderPoint,
    this.orderDistance,
    this.sourceId = "",
    this.storeIsHomeVisit = false,
    this.storeMapLocation = "",
    this.storeOperationalDay = "",
    this.storeOperationalHour = "",
    this.storeKecamatanId = "",
    this.promoDescription,
    this.shiftId = "",
    this.totalCash = 0,
    this.totalNonCash = 0,
    this.totalCompliment = 0,
    this.totalHutang = 0,
    this.kembalian = 0,
    this.companyAddress = "",
    this.companyKecamatanId = "",
    this.companyKotaId = "",
    this.companyOfficePhone = "",
    this.cashierBy = "",
    this.statusDesc = "",
    this.statusClosed = "",
    this.isEditable = false,
    this.createDate = "",
    this.createBy = "",
    this.paymentList = const [],
  });

  // From JSON factory constructor
  TransactionHeaderDAO.fromJson(Map<String, dynamic> json)
      : rowNumber = json['ROW_NUMBER'] ?? 0,
        companyId = json['COMPANY_ID'] ?? "",
        companyName = json['COMPANY_NAME'] ?? "",
        currencyId = json['CURRENCY_ID'] ?? "",
        siteId = json['SITE_ID'] ?? "",
        salesId = json['SALES_ID'] ?? "",
        salesDate = json['SALES_DATE'] ?? "",
        salesDateFormatted = json['SALES_DATE_F'] ?? "",
        rowId = json['ROW_ID'] ?? 0,
        totalQty = json['TOTAL_QTY'] ?? 0,
        brutoVal = json['BRUTO_VAL'] ?? 0,
        note = json['NOTE'] ?? "",
        supplierId = json['SUPPLIER_ID'] ?? "",
        supplierName = json['SUPPLIER_NAME'] ?? "",
        telp = json['TELP'] ?? "",
        guestName = json['GUEST_NAME'] ?? "",
        guestPhone = json['GUEST_PHONE'] ?? "",
        bookingType = json['BOOKING_TYPE'],
        bookingDate = json['BOOKING_DATE'],
        bookingDateBefore = json['BOOKING_DATE_BEFORE'],
        addCostPct = json['ADD_COST_PCT'] ?? 0,
        addCostVal = json['ADD_COST_VAL'] ?? 0,
        discPct = json['DISC_PCT'] ?? 0,
        discVal = json['DISC_VAL'] ?? 0,
        ppnPct = json['PPN_PCT'] ?? 0,
        ppnVal = json['PPN_VAL'] ?? 0,
        deliveryCostVal = json['DELIVERYCOST_VAL'] ?? 0,
        otherCost1Val = json['OTHERCOST1_VAL'] ?? 0,
        otherCost2Val = json['OTHERCOST2_VAL'] ?? 0,
        nettoVal = json['NETTO_VAL'] ?? 0,
        isCancel = json['IS_CANCEL'] ?? false,
        statusId = json['STATUS_ID'] ?? "",
        statusIdDesc = json['STATUS_ID_DESC'] ?? "",
        statusCategory = json['STATUS_CATEGORY'] ?? "",
        statusLastDate = json['STATUS_LAST_DATE'],
        settlePaymentMethod = json['SETTLE_PAYMENT_METHOD'] ?? "",
        settlePaymentVal = json['SETTLE_PAYMENT_VAL'] ?? 0,
        settleDate = json['SETTLE_DATE'] ?? "",
        settleBy = json['SETTLE_BY'] ?? "",
        settleCardNumber = json['SETTLE_CARD_NUMBER'] ?? "",
        queueNumber = json['QUEUE_NUMBER'] ?? 0,
        paymentId = json['PAYMENT_ID'] ?? "",
        paymentVal = json['PAYMENT_VAL'] ?? 0,
        paymentBillVal = json['PAYMENT_BILL_VAL'] ?? 0,
        orderAddress = json['ORDER_ADDRESS'],
        orderKelurahanId = json['ORDER_KELURAHAN_ID'],
        orderPoint = json['ORDER_POINT'],
        orderDistance = json['ORDER_DISTANCE'],
        sourceId = json['SOURCE_ID'] ?? "",
        storeIsHomeVisit = json['STORE_IS_HOME_VISIT'] ?? false,
        storeMapLocation = json['STORE_MAP_LOCATION'] ?? "",
        storeOperationalDay = json['STORE_OPERATIONAL_DAY'] ?? "",
        storeOperationalHour = json['STORE_OPERATIONAL_HOUR'] ?? "",
        storeKecamatanId = json['STORE_KECAMATAN_ID'] ?? "",
        promoDescription = json['PROMO_DESCRIPTION'],
        shiftId = json['SHIFT_ID'] ?? "",
        totalCash = json['TOTAL_CASH'] ?? 0,
        totalNonCash = json['TOTAL_NON_CASH'] ?? 0,
        totalCompliment = json['TOTAL_COMPLIMENT'] ?? 0,
        totalHutang = json['TOTAL_HUTANG'] ?? 0,
        kembalian = json['KEMBALIAN'] ?? 0,
        companyAddress = json['COMPANY_ADDRESS'] ?? "",
        companyKecamatanId = json['COMPANY_KECAMATAN_ID'] ?? "",
        companyKotaId = json['COMPANY_KOTA_ID'] ?? "",
        companyOfficePhone = json['COMPANY_OFFICE_PHONE'] ?? "",
        cashierBy = json['CASHIER_BY'] ?? "",
        statusDesc = json['STATUS_DESC'] ?? "",
        statusClosed = json['STATUS_CLOSED'] ?? "",
        isEditable = json['IS_EDITABLE'] ?? false,
        createDate = json['CREATEDATE'] ?? "",
        createBy = json['CREATEBY'] ?? "",
        paymentList = List<Map<String, dynamic>>.from(json['PAYMENT_LIST'] ?? []);

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'ROW_NUMBER': rowNumber,
      'COMPANY_ID': companyId,
      'COMPANY_NAME': companyName,
      'CURRENCY_ID': currencyId,
      'SITE_ID': siteId,
      'SALES_ID': salesId,
      'SALES_DATE': salesDate,
      'SALES_DATE_F': salesDateFormatted,
      'ROW_ID': rowId,
      'TOTAL_QTY': totalQty,
      'BRUTO_VAL': brutoVal,
      'NOTE': note,
      'SUPPLIER_ID': supplierId,
      'SUPPLIER_NAME': supplierName,
      'TELP': telp,
      'GUEST_NAME': guestName,
      'GUEST_PHONE': guestPhone,
      'BOOKING_TYPE': bookingType,
      'BOOKING_DATE': bookingDate,
      'BOOKING_DATE_BEFORE': bookingDateBefore,
      'ADD_COST_PCT': addCostPct,
      'ADD_COST_VAL': addCostVal,
      'DISC_PCT': discPct,
      'DISC_VAL': discVal,
      'PPN_PCT': ppnPct,
      'PPN_VAL': ppnVal,
      'DELIVERYCOST_VAL': deliveryCostVal,
      'OTHERCOST1_VAL': otherCost1Val,
      'OTHERCOST2_VAL': otherCost2Val,
      'NETTO_VAL': nettoVal,
      'IS_CANCEL': isCancel,
      'STATUS_ID': statusId,
      'STATUS_ID_DESC': statusIdDesc,
      'STATUS_CATEGORY': statusCategory,
      'STATUS_LAST_DATE': statusLastDate,
      'SETTLE_PAYMENT_METHOD': settlePaymentMethod,
      'SETTLE_PAYMENT_VAL': settlePaymentVal,
      'SETTLE_DATE': settleDate,
      'SETTLE_BY': settleBy,
      'SETTLE_CARD_NUMBER': settleCardNumber,
      'QUEUE_NUMBER': queueNumber,
      'PAYMENT_ID': paymentId,
      'PAYMENT_VAL': paymentVal,
      'PAYMENT_BILL_VAL': paymentBillVal,
      'ORDER_ADDRESS': orderAddress,
      'ORDER_KELURAHAN_ID': orderKelurahanId,
      'ORDER_POINT': orderPoint,
      'ORDER_DISTANCE': orderDistance,
      'SOURCE_ID': sourceId,
      'STORE_IS_HOME_VISIT': storeIsHomeVisit,
      'STORE_MAP_LOCATION': storeMapLocation,
      'STORE_OPERATIONAL_DAY': storeOperationalDay,
      'STORE_OPERATIONAL_HOUR': storeOperationalHour,
      'STORE_KECAMATAN_ID': storeKecamatanId,
      'PROMO_DESCRIPTION': promoDescription,
      'SHIFT_ID': shiftId,
      'TOTAL_CASH': totalCash,
      'TOTAL_NON_CASH': totalNonCash,
      'TOTAL_COMPLIMENT': totalCompliment,
      'TOTAL_HUTANG': totalHutang,
      'KEMBALIAN': kembalian,
      'COMPANY_ADDRESS': companyAddress,
      'COMPANY_KECAMATAN_ID': companyKecamatanId,
      'COMPANY_KOTA_ID': companyKotaId,
      'COMPANY_OFFICE_PHONE': companyOfficePhone,
      'CASHIER_BY': cashierBy,
      'STATUS_DESC': statusDesc,
      'STATUS_CLOSED': statusClosed,
      'IS_EDITABLE': isEditable,
      'CREATEDATE': createDate,
      'CREATEBY': createBy,
      'PAYMENT_LIST': paymentList,
    };
  }
}
