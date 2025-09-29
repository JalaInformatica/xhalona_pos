class ServerInfoResponse {
  String serverId;
  String clientId;
  String serverName;
  String clientName;
  String serverKey;
  String serverEndPoint;
  String companyIdDefault;

  ServerInfoResponse({
    this.serverId = "",
    this.clientId = "",
    this.serverName  = "",
    this.clientName  = "",
    this.serverKey  = "",
    this.serverEndPoint  = "",
    this.companyIdDefault  = "",
  });

  ServerInfoResponse.fromJson(Map<String, dynamic> json) :
    serverId = json['SERVER_ID'] ?? "",
    clientId = json['CLIENT_ID'] ?? "",
    serverName = json['SERVER_NAME'] ?? "",
    clientName = json['CLIENT_NAME'] ?? "",
    serverKey = json['SERVER_KEY'] ?? "",
    serverEndPoint = json['SERVER_END_POINT'] ?? "", 
    companyIdDefault = json['COMPANY_ID_DEFAULT'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      'SERVER_ID': serverId,
      'CLIENT_ID': clientId,
      'SERVER_NAME': serverName,
      'CLIENT_NAME': clientName,
      'SERVER_KEY': serverKey,
      'SERVER_END_POINT': serverEndPoint,
      'COMPANY_ID_DEFAULT': companyIdDefault,
    };
  }
}
