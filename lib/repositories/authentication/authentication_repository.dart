import 'package:xhalona_pos/models/dao/authentication.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/api_service.dart';
import 'package:xhalona_pos/services/authentication/authentication_service.dart';

class AuthenticationRepository extends AppRepository{
  final AuthenticationService _authenticationService = AuthenticationService();
  
  Future<LoginDAO> getLoginInfo({
    required String storeId,
    required String userId,
    required String password
  }) async {
    var result = await _authenticationService.loginWeb(
      storeId: storeId,
      userId: userId,
      password: password
    );
    List data = getUserLoginInfo(result);
    return LoginDAO.fromJson(data[0]);
  }
}