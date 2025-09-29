class ClientKeyResponse {
  String clientKey;
  String clientName;
  String dataDS;

  ClientKeyResponse({
    this.clientKey = "",
    this.clientName = "",
    this.dataDS = "",
  });

  ClientKeyResponse.fromJson(Map<String, dynamic> json) :
    clientKey = json['CLIENT_KEY'] ?? "",
    clientName = json['CLIENT_NAME'] ?? "",
    dataDS = json['DATA_DS'] ?? "";

}