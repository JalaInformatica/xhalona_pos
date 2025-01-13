class ServerModel {
  String SERVER_ID;
  String CLIENT_ID;
  String SERVER_NAME;
  String CLIENT_NAME;
  String SERVER_KEY;
  String SERVER_END_POINT;
  String COMPANY_ID_DEFAULT;

  ServerModel({
    this.SERVER_ID = "",
    this.CLIENT_ID = "",
    this.SERVER_NAME = "",
    this.CLIENT_NAME = "",
    this.SERVER_KEY = "",
    this.SERVER_END_POINT = "",
    this.COMPANY_ID_DEFAULT = "",
  });

  ServerModel.fromJson(Map<String, dynamic> json)
      : SERVER_ID = json['SERVER_ID'] ?? "",
        CLIENT_ID = json['CLIENT_ID'] ?? "",
        SERVER_NAME = json['SERVER_NAME'] ?? "",
        CLIENT_NAME = json['CLIENT_NAME'] ?? "",
        SERVER_KEY = json['SERVER_KEY'] ?? "",
        SERVER_END_POINT = json['SERVER_END_POINT'] ?? "",
        COMPANY_ID_DEFAULT = json['COMPANY_ID_DEFAULT'] ?? ""; // Handle null here

  Map<String, dynamic> toJson() {
    return {
      'SERVER_ID': SERVER_ID,
      'CLIENT_ID': CLIENT_ID,
      'SERVER_NAME': SERVER_NAME,
      'CLIENT_NAME': CLIENT_NAME,
      'SERVER_KEY': SERVER_KEY,
      'SERVER_END_POINT': SERVER_END_POINT,
      'COMPANY_ID_DEFAULT': COMPANY_ID_DEFAULT,
    };
  }
}

class GetClientKeyModel {
  String? CLIENT_KEY;
  String? CLIENT_NAME;
  ClientKeyCreateDateModel? CLIENT_KEY_CREATE_DATE;
  String? DATA_DS;

  GetClientKeyModel({
    this.CLIENT_KEY,
    this.CLIENT_NAME,
    this.CLIENT_KEY_CREATE_DATE,
    this.DATA_DS,
  });

  GetClientKeyModel.fromJson(Map<String, dynamic> json) {
    CLIENT_KEY = json['CLIENT_KEY'];
    CLIENT_NAME = json['CLIENT_NAME'];
    CLIENT_KEY_CREATE_DATE =
        ClientKeyCreateDateModel.fromJson(json['CLIENT_KEY_CREATE_DATE']);
    DATA_DS = json['DATA_DS'];
  }

  Map<String, dynamic> toJson() {
    return {
      'CLIENT_KEY': CLIENT_KEY,
      'CLIENT_NAME': CLIENT_NAME,
      'CLIENT_KEY_CREATE_DATE': CLIENT_KEY_CREATE_DATE?.toJson(),
      'DATA_DS': DATA_DS,
    };
  }
}

class ClientKeyCreateDateModel {
  DateTime? date;
  int? timezone_type;
  String? timezone;

  ClientKeyCreateDateModel({
    this.date,
    this.timezone_type,
    this.timezone,
  });

  ClientKeyCreateDateModel.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date']);
    timezone_type = json['timezone_type'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'timezone_type': timezone_type,
      'timezone': timezone,
    };
  }
}

