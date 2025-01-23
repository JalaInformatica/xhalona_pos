import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/user.dart';
import 'package:xhalona_pos/models/dao/structure.dart';
import 'package:xhalona_pos/repositories/user/user_repository.dart';
import 'package:xhalona_pos/repositories/structure/structure_repository.dart';

class HomeController extends GetxController {
  final StructureRepository _structureRepository = StructureRepository();
  final UserRepository _userRepository = UserRepository();

  var isMenuLoading = true.obs;
  var menuData = <MenuDAO>[].obs;
  var profileData = UserDAO().obs;
  var selectedMenuName = "pos".obs;
  var isOpenMaster = false.obs;
  var isOpenLaporan = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    menuData.value = await _structureRepository.getMenus();
    profileData.value = await _userRepository.getUserProfile();
    isMenuLoading.value = false;
  }
}
