import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/user.dart';
import 'package:xhalona_pos/repositories/user/user_repository.dart';

class ProfileController extends GetxController{
  final UserRepository _userRepository = UserRepository();
  var isProfileLoading = true.obs;
  var profileData = UserDAO().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchProfile();
    super.onInit();
  }

  Future<void> fetchProfile() async {
    profileData.value = await _userRepository.getUserProfile();
    isProfileLoading.value = false;
  }

}