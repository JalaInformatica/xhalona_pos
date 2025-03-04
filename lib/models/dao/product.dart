class ProductDAO {
  int rowId;
  String companyId;
  String companyName;
  String partId;
  String partName;
  String spec;
  String analisaId;
  String analisaIdGlobal;
  String ketAnalisa;
  String ketAnalisaGlobal;
  String unit1;
  String unit2;
  int qtyPerUnit1;
  int qtyMax;
  int qtyMin;
  int unitPrice;
  int discountPct;
  int discountVal;
  int unitPriceNet;
  String pathImage;
  String mainImage;
  String thumbImage;
  bool isFixQty;
  bool isFixPrice;
  bool isFree;
  bool isStock;
  bool isActive;
  bool isPacket;
  int totalBom;
  int totalQtySoled;
  int totalRate;
  int totalRatePerson;
  int? employeeFeePct;
  int? employeeFeeVal;
  String createDate;
  String createBy;
  bool isPromo;
  String groupAnalisaName;
  String groupAnalisaId;
  bool isNonSales;
  bool isPublish;

  ProductSortBy productSortBy = ProductSortBy();

  ProductDAO({
    this.rowId = 0,
    this.companyId = "",
    this.companyName = "",
    this.partId = "",
    this.partName = "",
    this.spec = "",
    this.analisaId = "",
    this.analisaIdGlobal = "",
    this.ketAnalisa = "",
    this.ketAnalisaGlobal = "",
    this.unit1 = "",
    this.unit2 = "",
    this.qtyPerUnit1 = 0,
    this.qtyMax = 0,
    this.qtyMin = 0,
    this.unitPrice = 0,
    this.discountPct = 0,
    this.discountVal = 0,
    this.unitPriceNet = 0,
    this.pathImage = "",
    this.mainImage = "",
    this.thumbImage = "",
    this.isFixQty = false,
    this.isFixPrice = true,
    this.isFree = false,
    this.isStock = true,
    this.isActive = true,
    this.isPacket = false,
    this.totalBom = 0,
    this.totalQtySoled = 0,
    this.totalRate = 0,
    this.totalRatePerson = 0,
    this.employeeFeePct,
    this.employeeFeeVal,
    this.createDate = "",
    this.createBy = "",
    this.isPromo = false,
    this.groupAnalisaName = "",
    this.groupAnalisaId = "",
    this.isNonSales = false,
    this.isPublish = false,
  });

  ProductDAO.fromJson(Map<String, dynamic> json)
      : rowId = json['ROW_ID'] ?? 0,
        companyId = json['COMPANY_ID'] ?? "",
        companyName = json['COMPANY_NAME'] ?? "",
        partId = json['PART_ID'] ?? "",
        partName = json['PART_NAME'] ?? "",
        spec = json['SPEC'] ?? "",
        analisaId = json['ANALISA_ID'] ?? "",
        analisaIdGlobal = json['ANALISA_ID_GLOBAL'] ?? "",
        ketAnalisa = json['KET_ANALISA'] ?? "",
        ketAnalisaGlobal = json['KET_ANALISA_GLOBAL'] ?? "",
        unit1 = json['UNIT_1'] ?? "",
        unit2 = json['UNIT_2'] ?? "",
        qtyPerUnit1 = json['QTY_PER_UNIT_1'] ?? 0,
        qtyMax = json['QTY_MAX'] ?? 0,
        qtyMin = json['QTY_MIN'] ?? 0,
        unitPrice = json['UNIT_PRICE'] ?? 0,
        discountPct = json['DISCOUNT_PCT'] ?? 0,
        discountVal = json['DISCOUNT_VAL'] ?? 0,
        unitPriceNet = json['UNIT_PRICE_NET'] ?? 0,
        pathImage = json['PATH_IMAGE'] ?? "",
        mainImage = json['MAIN_IMAGE'] ?? "",
        thumbImage = json['THUMB_IMAGE'] ?? "",
        isFixQty = json['IS_FIX_QTY'] ?? false,
        isFixPrice = json['IS_FIX_PRICE'] ?? true,
        isFree = json['IS_FREE'] ?? false,
        isStock = json['IS_STOCK'] ?? true,
        isActive = json['IS_ACTIVE'] ?? true,
        isPacket = json['IS_PACKET'] ?? false,
        totalBom = json['TOTAL_BOM'] ?? 0,
        totalQtySoled = json['TOTAL_QTY_SOLED'] ?? 0,
        totalRate = json['TOTAL_RATE'] ?? 0,
        totalRatePerson = json['TOTAL_RATE_PERSON'] ?? 0,
        employeeFeePct = json['EMPLOYEE_FEE_PCT'] ?? 0,
        employeeFeeVal = json['EMPLOYEE_FEE_VAL'] ?? 0,
        createDate = json['CREATEDATE'] ?? "",
        createBy = json['CREATEBY'] ?? "",
        isPromo = json['IS_PROMO'] ?? false,
        groupAnalisaName = json['GROUP_ANALISA_NAME'] ?? "",
        groupAnalisaId = json['GROUP_ANALISA_ID'] ?? "",
        isNonSales = json['IS_NON_SALES'] ?? false,
        isPublish = json['IS_PUBLISH'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'ROW_ID': rowId,
      'COMPANY_ID': companyId,
      'COMPANY_NAME': companyName,
      'PART_ID': partId,
      'PART_NAME': partName,
      'SPEC': spec,
      'ANALISA_ID': analisaId,
      'ANALISA_ID_GLOBAL': analisaIdGlobal,
      'KET_ANALISA': ketAnalisa,
      'KET_ANALISA_GLOBAL': ketAnalisaGlobal,
      'UNIT_1': unit1,
      'UNIT_2': unit2,
      'QTY_PER_UNIT_1': qtyPerUnit1,
      'QTY_MAX': qtyMax,
      'QTY_MIN': qtyMin,
      'UNIT_PRICE': unitPrice,
      'DISCOUNT_PCT': discountPct,
      'DISCOUNT_VAL': discountVal,
      'UNIT_PRICE_NET': unitPriceNet,
      'PATH_IMAGE': pathImage,
      'MAIN_IMAGE': mainImage,
      'THUMB_IMAGE': thumbImage,
      'IS_FIX_QTY': isFixQty,
      'IS_FIX_PRICE': isFixPrice,
      'IS_FREE': isFree,
      'IS_STOCK': isStock,
      'IS_ACTIVE': isActive,
      'IS_PACKET': isPacket,
      'TOTAL_BOM': totalBom,
      'TOTAL_QTY_SOLED': totalQtySoled,
      'TOTAL_RATE': totalRate,
      'TOTAL_RATE_PERSON': totalRatePerson,
      'EMPLOYEE_FEE_PCT': employeeFeePct,
      'EMPLOYEE_FEE_VAL': employeeFeeVal,
      'CREATEDATE': createDate,
      'CREATEBY': createBy,
      'IS_PROMO': isPromo,
      'GROUP_ANALISA_NAME': groupAnalisaName,
      'GROUP_ANALISA_ID': groupAnalisaId,
      'IS_NON_SALES': isNonSales,
    };
  }

  static ProductSortBy get sortBy => ProductSortBy();
}

class ProductSortBy {
  String partId = "PART_ID";
  String totalSold = "TOTAL_QTY_SOLED";
  String totalRate = "TOTAL_RATE";
  String isPromo = "IS_PROMO";
}
