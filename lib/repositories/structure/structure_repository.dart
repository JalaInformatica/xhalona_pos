import 'package:xhalona_pos/models/response/structure.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/structure/structure_service.dart';

class StructureRepository extends AppRepository{
  final StructureService _structureService = StructureService();

  Future<List<MenuDAO>> getMenus() async {
    var result = await _structureService.getUserMenu();
    List data = getMenuList(result);
    return data.map((menu)=> MenuDAO.fromJson(menu)).toList();
  }
}