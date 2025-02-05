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
  String bookingType;
  String bookingDate;
  String bookingDateBefore;
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
  String statusLastDate;
  String settlePaymentMethod;
  int settlePaymentVal;
  String settleDate;
  String settleBy;
  String settleCardNumber;
  int queueNumber;
  String paymentId;
  int paymentVal;
  int paymentBillVal;
  String orderAddress;
  String orderKelurahanId;
  String orderPoint;
  int orderDistance;
  String sourceId;
  bool storeIsHomeVisit;
  String storeMapLocation;
  String storeOperationalDay;
  String storeOperationalHour;
  String storeKecamatanId;
  String promoDescription;
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
    this.bookingType = "",
    this.bookingDate = "",
    this.bookingDateBefore = "",
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
    this.statusLastDate = "",
    this.settlePaymentMethod = "",
    this.settlePaymentVal = 0,
    this.settleDate = "",
    this.settleBy = "",
    this.settleCardNumber = "",
    this.queueNumber = 0,
    this.paymentId = "",
    this.paymentVal = 0,
    this.paymentBillVal = 0,
    this.orderAddress = "",
    this.orderKelurahanId = "",
    this.orderPoint = "",
    this.orderDistance = 0,
    this.sourceId = "",
    this.storeIsHomeVisit = false,
    this.storeMapLocation = "",
    this.storeOperationalDay = "",
    this.storeOperationalHour = "",
    this.storeKecamatanId = "",
    this.promoDescription = "",
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
        bookingType = json['BOOKING_TYPE'] ?? "",
        bookingDate = json['BOOKING_DATE'] ?? "",
        bookingDateBefore = json['BOOKING_DATE_BEFORE'] ?? "",
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
        statusLastDate = json['STATUS_LAST_DATE'] ?? "",
        settlePaymentMethod = json['SETTLE_PAYMENT_METHOD'] ?? "",
        settlePaymentVal = json['SETTLE_PAYMENT_VAL'] ?? 0,
        settleDate = json['SETTLE_DATE'] ?? "",
        settleBy = json['SETTLE_BY'] ?? "",
        settleCardNumber = json['SETTLE_CARD_NUMBER'] ?? "",
        queueNumber = json['QUEUE_NUMBER'] ?? 0,
        paymentId = json['PAYMENT_ID'] ?? "",
        paymentVal = json['PAYMENT_VAL'] ?? 0,
        paymentBillVal = json['PAYMENT_BILL_VAL'] ?? 0,
        orderAddress = json['ORDER_ADDRESS'] ?? "",
        orderKelurahanId = json['ORDER_KELURAHAN_ID'] ?? "",
        orderPoint = json['ORDER_POINT'] ?? "",
        orderDistance = json['ORDER_DISTANCE'] ?? 0,
        sourceId = json['SOURCE_ID'] ?? "",
        storeIsHomeVisit = json['STORE_IS_HOME_VISIT'] ?? false,
        storeMapLocation = json['STORE_MAP_LOCATION'] ?? "",
        storeOperationalDay = json['STORE_OPERATIONAL_DAY'] ?? "",
        storeOperationalHour = json['STORE_OPERATIONAL_HOUR'] ?? "",
        storeKecamatanId = json['STORE_KECAMATAN_ID'] ?? "",
        promoDescription = json['PROMO_DESCRIPTION'] ?? "",
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

class TransactionDetailDAO {
  String companyId;
  String salesId;
  String rowId;
  String employeeId;
  String? fullName;
  String partId;
  String partName;
  int qty;
  int price;
  String? supplierId;
  String? supplierName;
  String? parentPartId;
  String? parentPartName;
  String analisaId;
  String? ketAnalisa;
  int deductionPct;
  int deductionVal;
  String? addCostId;
  int addCostPct;
  int addCostVal;
  int totalPrice;
  int nettoVal;
  bool isFixQty;
  bool isFixPrice;
  bool isActive;
  int hBrutoVal;
  int hDiscVal;
  int hNettoVal;
  String thumbImage;
  String mainImage;
  bool isFreePick;
  String sourceId;
  bool isPacket;
  String? settleDate;
  String? settlePaymentMethod;
  String? employeeId1;
  String? employeeName1;
  String? employeeId2;
  String? employeeName2;
  String? employeeId3;
  String? employeeName3;
  String? employeeId4;
  String? employeeName4;
  String createDate;
  String createBy;
  String detNote;
  List<BOMDataDAO> bomData;
  List<VarianDataDAO> varianData;

  TransactionDetailDAO({
    this.companyId = "",
    this.salesId = "",
    this.rowId = "",
    this.employeeId = "",
    this.fullName,
    this.partId = "",
    this.partName = "",
    this.qty = 0,
    this.price = 0,
    this.supplierId,
    this.supplierName,
    this.parentPartId,
    this.parentPartName,
    this.analisaId = "",
    this.ketAnalisa,
    this.deductionPct = 0,
    this.deductionVal = 0,
    this.addCostId,
    this.addCostPct = 0,
    this.addCostVal = 0,
    this.totalPrice = 0,
    this.nettoVal = 0,
    this.isFixQty = false,
    this.isFixPrice = false,
    this.isActive = false,
    this.hBrutoVal = 0,
    this.hDiscVal = 0,
    this.hNettoVal = 0,
    this.thumbImage = "",
    this.mainImage = "",
    this.isFreePick = false,
    this.sourceId = "",
    this.isPacket = false,
    this.settleDate,
    this.settlePaymentMethod,
    this.employeeId1,
    this.employeeName1,
    this.employeeId2,
    this.employeeName2,
    this.employeeId3,
    this.employeeName3,
    this.employeeId4,
    this.employeeName4,
    this.createDate = "",
    this.createBy = "",
    this.detNote = "",
    this.bomData = const [],
    this.varianData = const [],
  });

  // From JSON factory constructor
  TransactionDetailDAO.fromJson(Map<String, dynamic> json)
      : companyId = json['COMPANY_ID'] ?? "",
        salesId = json['SALES_ID'] ?? "",
        rowId = json['ROW_ID'] ?? "",
        employeeId = json['EMPLOYEE_ID'],
        fullName = json['FULL_NAME'],
        partId = json['PART_ID'] ?? "",
        partName = json['PART_NAME'] ?? "",
        qty = json['QTY'] ?? 0,
        price = json['PRICE'] ?? 0,
        supplierId = json['SUPPLIER_ID'],
        supplierName = json['SUPPLIER_NAME'],
        parentPartId = json['PARENT_PART_ID'],
        parentPartName = json['PARENT_PART_NAME'],
        analisaId = json['ANALISA_ID'] ?? "",
        ketAnalisa = json['KET_ANALISA'],
        deductionPct = json['DEDUCTION_PCT'] ?? 0,
        deductionVal = json['DEDUCTION_VAL'] ?? 0,
        addCostId = json['ADD_COST_ID'],
        addCostPct = json['ADD_COST_PCT'] ?? 0,
        addCostVal = json['ADD_COST_VAL'] ?? 0,
        totalPrice = json['TOTAL_PRICE'] ?? 0,
        nettoVal = json['NETTO_VAL'] ?? 0,
        isFixQty = json['IS_FIX_QTY'] ?? false,
        isFixPrice = json['IS_FIX_PRICE'] ?? false,
        isActive = json['IS_ACTIVE'] ?? false,
        hBrutoVal = json['H_BRUTO_VAL'] ?? 0,
        hDiscVal = json['H_DISC_VAL'] ?? 0,
        hNettoVal = json['H_NETTO_VAL'] ?? 0,
        thumbImage = json['THUMB_IMAGE'] ?? "",
        mainImage = json['MAIN_IMAGE'] ?? "",
        isFreePick = json['IS_FREE_PICK'] ?? false,
        sourceId = json['SOURCE_ID'] ?? "",
        isPacket = json['IS_PACKET'] ?? false,
        settleDate = json['SETTLE_DATE'],
        settlePaymentMethod = json['SETTLE_PAYMENT_METHOD'],
        employeeId1 = json['EMPLOYEE_ID1'],
        employeeName1 = json['EMPLOYEE_NAME1'],
        employeeId2 = json['EMPLOYEE_ID2'],
        employeeName2 = json['EMPLOYEE_NAME2'],
        employeeId3 = json['EMPLOYEE_ID3'],
        employeeName3 = json['EMPLOYEE_NAME3'],
        employeeId4 = json['EMPLOYEE_ID4'],
        employeeName4 = json['EMPLOYEE_NAME4'],
        createDate = json['CREATEDATE'] ?? "",
        createBy = json['CREATEBY'] ?? "",
        detNote = json['DET_NOTE'] ?? "",
        bomData = (json['BOM_DATA'] as List?)
                ?.map((item) => BOMDataDAO.fromJson(item))
                .toList() ??
            [],
        varianData = (json['VARIAN_DATA'] as List?)
                ?.map((item) => VarianDataDAO.fromJson(item))
                .toList() ??
            [];

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'COMPANY_ID': companyId,
      'SALES_ID': salesId,
      'ROW_ID': rowId,
      'EMPLOYEE_ID': employeeId,
      'FULL_NAME': fullName,
      'PART_ID': partId,
      'PART_NAME': partName,
      'QTY': qty,
      'PRICE': price,
      'SUPPLIER_ID': supplierId,
      'SUPPLIER_NAME': supplierName,
      'PARENT_PART_ID': parentPartId,
      'PARENT_PART_NAME': parentPartName,
      'ANALISA_ID': analisaId,
      'KET_ANALISA': ketAnalisa,
      'DEDUCTION_PCT': deductionPct,
      'DEDUCTION_VAL': deductionVal,
      'ADD_COST_ID': addCostId,
      'ADD_COST_PCT': addCostPct,
      'ADD_COST_VAL': addCostVal,
      'TOTAL_PRICE': totalPrice,
      'NETTO_VAL': nettoVal,
      'IS_FIX_QTY': isFixQty,
      'IS_FIX_PRICE': isFixPrice,
      'IS_ACTIVE': isActive,
      'H_BRUTO_VAL': hBrutoVal,
      'H_DISC_VAL': hDiscVal,
      'H_NETTO_VAL': hNettoVal,
      'THUMB_IMAGE': thumbImage,
      'MAIN_IMAGE': mainImage,
      'IS_FREE_PICK': isFreePick,
      'SOURCE_ID': sourceId,
      'IS_PACKET': isPacket,
      'SETTLE_DATE': settleDate,
      'SETTLE_PAYMENT_METHOD': settlePaymentMethod,
      'EMPLOYEE_ID1': employeeId1,
      'EMPLOYEE_NAME1': employeeName1,
      'EMPLOYEE_ID2': employeeId2,
      'EMPLOYEE_NAME2': employeeName2,
      'EMPLOYEE_ID3': employeeId3,
      'EMPLOYEE_NAME3': employeeName3,
      'EMPLOYEE_ID4': employeeId4,
      'EMPLOYEE_NAME4': employeeName4,
      'CREATEDATE': createDate,
      'CREATEBY': createBy,
      'DET_NOTE': detNote,
      'BOM_DATA': bomData.map((item) => item.toJson()).toList(),
      'VARIAN_DATA': varianData.map((item) => item.toJson()).toList(),
    };
  }
}

class BOMDataDAO {
  int rowId;
  String bomPartId;
  String unitId;
  int qty;
  String bomPartName;
  String? brandId;

  BOMDataDAO({
    this.rowId = 0,
    this.bomPartId = "",
    this.unitId = "",
    this.qty = 0,
    this.bomPartName = "",
    this.brandId,
  });

  BOMDataDAO.fromJson(Map<String, dynamic> json)
      : rowId = json['ROW_ID'] ?? "",
        bomPartId = json['BOM_PART_ID'] ?? "",
        unitId = json['UNIT_ID'] ?? "",
        qty = json['QTY'] ?? 0,
        bomPartName = json['BOM_PART_NAME'] ?? "",
        brandId = json['BRAND_ID'];

  Map<String, dynamic> toJson() {
    return {
      'ROW_ID': rowId,
      'BOM_PART_ID': bomPartId,
      'UNIT_ID': unitId,
      'QTY': qty,
      'BOM_PART_NAME': bomPartName,
      'BRAND_ID': brandId,
    };
  }
}

class VarianDataDAO {
  int rowId;
  String varianGroupId;
  String varianGroupName;
  String? varianIdVal;
  String? varianName;
  String? varianNote;
  List<VarianOptionDAO> varianOption;

  VarianDataDAO({
    this.rowId = 0,
    this.varianGroupId = "",
    this.varianGroupName = "",
    this.varianIdVal,
    this.varianName,
    this.varianNote,
    this.varianOption = const [],
  });

  VarianDataDAO.fromJson(Map<String, dynamic> json)
      : rowId = json['ROW_ID'] ?? "",
        varianGroupId = json['VARIAN_GROUP_ID'] ?? "",
        varianGroupName = json['VARIAN_GROUP_NAME'] ?? "",
        varianIdVal = json['VARIAN_ID_VAL'],
        varianName = json['VARIAN_NAME'],
        varianNote = json['VARIAN_NOTE'],
        varianOption = (json['VARIAN_OPTION'] as List?)
                ?.map((item) => VarianOptionDAO.fromJson(item))
                .toList() ??
            [];

  Map<String, dynamic> toJson() {
    return {
      'ROW_ID': rowId,
      'VARIAN_GROUP_ID': varianGroupId,
      'VARIAN_GROUP_NAME': varianGroupName,
      'VARIAN_ID_VAL': varianIdVal,
      'VARIAN_NAME': varianName,
      'VARIAN_NOTE': varianNote,
      'VARIAN_OPTION': varianOption.map((item) => item.toJson()).toList(),
    };
  }
}

class VarianOptionDAO {
  String varianId;
  String varianName;

  VarianOptionDAO({this.varianId = "", this.varianName = ""});

  VarianOptionDAO.fromJson(Map<String, dynamic> json)
      : varianId = json['VARIAN_ID'] ?? "",
        varianName = json['VARIAN_NAME'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      'VARIAN_ID': varianId,
      'VARIAN_NAME': varianName,
    };
  }
}
