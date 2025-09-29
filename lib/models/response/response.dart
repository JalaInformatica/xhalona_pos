class ResponseDAO<T> {
  String resultCode;
  String resultDesc;
  String resultMessage;
  int totalPage;
  int totalRecord;
  List<T> data;

  ResponseDAO({
    this.resultCode = "",
    this.resultDesc = "",
    this.resultMessage = "",
    this.totalPage = 0,
    this.totalRecord = 0,
    this.data = const []
  });

  ResponseDAO.fromJson(Map<String, dynamic> json): 
    resultCode = json['RESULT_CODE'] ?? "",
    resultDesc = json['RESULT_DESC'] ?? "",
    resultMessage = json['RESULT_MESSAGE'] ?? "",
    totalPage = json['TOTAL_PAGE'] ?? "",
    totalRecord = json['TOTAL_RECORD'] ?? "",
    data = json['TOTAL_DATA'] ?? [];
}