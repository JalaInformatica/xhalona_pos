import 'package:xhalona_pos/models/dao/shift.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/shift/shift_service.dart';

class ShiftRepository extends AppRepository {
  final ShiftService _shiftService = ShiftService();

  Future<List<ShiftDAO>> getShifts() async {
    var result = await _shiftService.getShifts();
    List data = getResponseListData(result);
    return data.map((shifts)=>ShiftDAO.fromJson(shifts)).toList();
  }
}