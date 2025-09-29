import 'dart:convert';
import 'package:xhalona_pos/services/app_service.dart';
import 'package:xhalona_pos/services/response_handler.dart';

class AuthenticationService extends XhalonaService {
  Future<String> loginWeb ({
    String companyId = "",
    String userId = "",
    String password = "",
  }) async {
    
    var url = '/SYSMAN/login';
    final userInfo = await fetchUserSessionInfo();
    var body = jsonEncode({
      "rqloginweb": {
        "COMPANY_ID": companyId,
        "USER_ID": userId,
        "PASSWORD": password,
        "IP": userInfo.$1,
        "APP": "WEB"
      }
    });

    var response = await post(
      url,
      body: body,
    );

    return ResponseHandler.handle(response);
  }
}
