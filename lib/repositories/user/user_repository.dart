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

  Future<String> changePasswordProfile(
      {String? password1, String? password2}) async {
    var result = await _userService.changePasswordProfile(
      password1: password1,
      password2: password2,
    );
    String data = getResponseData(result);
    return data;
  }

  Future<String> settings({String? nota}) async {
    var result = await _userService.settings(
      nota: nota,
    );
    String data = getResponseData(result);
    return data;
  }

  Future<String> changeUserDetail({
    String? userName,
    String? userEmail,
    String? userPhone,
    String? joinDate,
    String? userPic,
    String? userBirthDate,
    String? userGender,
  }) async {
    var result = await _userService.changeUserDetail(
      userEmail: userEmail,
      userPhone: userPhone,
      joinDate: joinDate,
      userPic: userPic,
      userBirthDate: userBirthDate,
      userGender: userGender,
    );
    String data = getResponseData(result);
    return data;
  }
}
