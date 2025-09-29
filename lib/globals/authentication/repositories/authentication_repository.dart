import 'dart:convert';

import 'package:flutter_widgets/core/models/response/response_code.dart';
import 'package:flutter_widgets/core/models/response/response_model.dart';
import 'package:xhalona_pos/globals/authentication/models/authentication_response.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/globals/authentication/services/authentication_service.dart';

class AuthenticationRepository extends AppRepository {
  final AuthenticationService _authenticationService = AuthenticationService();

  ResponseModel<T> getRsLoginData<T>(String response, {required T Function(dynamic) formatter}) {
    var result = jsonDecode(response)["rsLogin"] ?? {};
    try {
      if (result['RESULT_CODE'].toString().contains(ResponseCode.success)) {
        return ResponseModel(
          data: formatter(result), 
          resultCode: result['RESULT_CODE'] ?? ResponseCode.success,
          resultDesc: result['RESULT_DESC'] ?? '',
          resultMessage: result['MESSAGE'] ?? ''
        );
      } else {
        return ResponseModel(
          data: null, 
          resultCode: ResponseCode.error, 
          resultDesc: result['RESULT_CODE'] ?? 'GAGAL', 
          resultMessage: result['MESSAGE'] ?? ''
        );
      }
    }
    catch(e){
      return ResponseModel(
        data: null, 
        resultCode: ResponseCode.error, 
        resultDesc: result['RESULT_CODE'] ?? 'GAGAL', 
        resultMessage: result['MESSAGE'] ?? e);
    }
  }

  Future<ResponseModel<LoginResponse>> loginWeb({
    required String companyId,
    required String userId,
    required String password
  }) async {
    var result = await _authenticationService.loginWeb(
      companyId: companyId, 
      userId: userId, 
      password: password
    );
    return getRsLoginData<LoginResponse>(result, formatter: (data)=>LoginResponse.fromJson(data));
  }
}
