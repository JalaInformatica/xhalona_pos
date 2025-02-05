class ShiftDAO {
  String companyId;
  String shiftId;
  String shiftName;
  bool isActive;
  String timeStart;
  String timeEnd;
  int shiftIdActive;
  int rowNumber;
  int totalPage;
  int totalRecord;

  ShiftDAO({
    this.companyId = "",
    this.shiftId = "",
    this.shiftName = "",
    this.isActive = false,
    required this.timeStart,
    required this.timeEnd,
    this.shiftIdActive = 0,
    this.rowNumber = 0,
    this.totalPage = 0,
    this.totalRecord = 0,
  });

  ShiftDAO.fromJson(Map<String, dynamic> json)
      : companyId = json['COMPANY_ID'] ?? "",
        shiftId = json['SHIFT_ID'] ?? "",
        shiftName = json['SHIFT_NAME'] ?? "",
        isActive = json['IS_ACTIVE'] ?? false,
        timeStart = json['TIME_START'] ?? "",
        timeEnd = json['TIME_END'] ?? "",
        shiftIdActive = json['SHIFT_ID_ACTIVE'] ?? 0,
        rowNumber = json['ROW_NUMBER'] ?? 0,
        totalPage = json['TOTAL_PAGE'] ?? 0,
        totalRecord = json['TOTAL_RECORD'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'COMPANY_ID': companyId,
      'SHIFT_ID': shiftId,
      'SHIFT_NAME': shiftName,
      'IS_ACTIVE': isActive,
      'TIME_START': timeStart,
      'TIME_END': timeEnd,
      'SHIFT_ID_ACTIVE': shiftIdActive,
      'ROW_NUMBER': rowNumber,
      'TOTAL_PAGE': totalPage,
      'TOTAL_RECORD': totalRecord,
    };
  }
}
