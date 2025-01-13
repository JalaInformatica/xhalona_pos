import 'dart:convert';
import 'package:xhalona_pos/services/api_service.dart' as api;
import 'package:xhalona_pos/services/response_handler.dart';

class AuthenticationService {
  Future<String> loginWeb ({
    String storeId = "",
    String userId = "",
    String password = "",
  }) async {
    
    var url = '/SYSMAN/login';

    var body = jsonEncode({
      "rqloginweb": {
        "COMPANY_ID": storeId,
        "USER_ID": userId,
        "PASSWORD": password,
        "IP": "121.131.1313",
        "APP": "WEB"
      }
    });

    var response = await api.post(
      url,
      headers: await api.requestHeaders(),
      body: body,
    );

    return ResponseHandler.handle(response);
  }
}
