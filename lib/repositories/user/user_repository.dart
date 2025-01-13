import 'package:xhalona_pos/models/dao/user.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/user/user_service.dart';

class UserRepository extends AppRepository {
  final UserService _userService = UserService();
  Future<UserDAO> getUserProfile() async {
    var result = await _userService.getUserProfile();
    List data = getResponseMemberInfo(result);
    return UserDAO.fromJson(data[0]);
  }
}