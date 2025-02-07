import 'package:xhalona_pos/models/dao/user.dart';
import 'package:xhalona_pos/services/user/user_service.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';

class UserRepository extends AppRepository {
  final UserService _userService = UserService();
  Future<UserDAO> getUserProfile() async {
    var result = await _userService.getUserProfile();
    List data = getResponseMemberInfo(result);
    return UserDAO.fromJson(data[0]);
  }

  Future<String> logoutProfile() async {
    var result = await _userService.logoutProfile();
    String data = getResponseLogoutData(result);
    return data;
  }
}
