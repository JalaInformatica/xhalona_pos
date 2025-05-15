import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/user.dart';
import 'package:xhalona_pos/models/dao/structure.dart';
import 'package:xhalona_pos/models/dao/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xhalona_pos/core/constant/local_storage.dart';
import 'package:xhalona_pos/repositories/user/user_repository.dart';
import 'package:xhalona_pos/repositories/structure/structure_repository.dart';
import 'package:xhalona_pos/repositories/transaction/transaction_repository.dart';

class HomeController extends GetxController {
  final StructureRepository _structureRepository = StructureRepository();
  final UserRepository _userRepository = UserRepository();
  final TransactionRepository _transactionRepository = TransactionRepository();

  var isMenuLoading = true.obs;
  var menuData = <MenuDAO>[].obs;
  var profileData = UserDAO().obs;
  var todayTrx = 0.obs;
  var selectedMenuName = "pos".obs;
  var isOpenMaster = false.obs;
  var isOpenLaporan = false.obs;

  var subMenuName = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenu();
    fetchTodayTransaction();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _userRepository.logoutProfile();
    await prefs.remove(LocalStorageConst.userId);
    await prefs.remove(LocalStorageConst.sessionLoginId);
    await prefs.remove(LocalStorageConst.userName);
    await prefs.remove(LocalStorageConst.ip);
    await prefs.remove(LocalStorageConst.companyId);
    await prefs.remove(LocalStorageConst.defCompanyId);
  }

  Future<void> fetchMenu() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();  
    menuData.value = [
      ...await _structureRepository.getMenus()
    ];
    profileData.value = await _userRepository.getUserProfile()..companyId=prefs.getString(LocalStorageConst.companyId) ?? "";
    isMenuLoading.value = false;
  }

  Future<void> fetchTodayTransaction() async {
    DateTime now = DateTime.now();
    List<TransactionStatusDAO> statusTransactions =
        await _transactionRepository.statusTransaction(
            filterDay: now.day,
            filterMonth: now.month,
            filterYear: now.year,
            statusCategory: "PROGRESS",
            statusClosed: "OPEN");
    todayTrx.value =
        statusTransactions.fold(0, (sum, item) => sum + item.total);
  }
}
