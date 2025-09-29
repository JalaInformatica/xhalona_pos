import 'package:flutter/material.dart';
import 'package:xhalona_pos/models/response/structure.dart';
import 'package:xhalona_pos/models/response/user.dart';
import 'package:xhalona_pos/repositories/structure/structure_repository.dart';
import 'package:xhalona_pos/repositories/user/user_repository.dart';

class HomeProvider extends ChangeNotifier{
  final StructureRepository _structureRepository = StructureRepository();
  final UserRepository _userRepository = UserRepository();

  bool isMenuLoading = true;
  List<MenuDAO> menuData = [];
  UserDAO profileData = UserDAO();

  Future<void> fetchMenu() async {
    menuData = await _structureRepository.getMenus();
    profileData = await _userRepository.getUserProfile();
    isMenuLoading = false;
    notifyListeners();
  }
}