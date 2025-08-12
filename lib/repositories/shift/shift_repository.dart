import 'package:xhalona_pos/models/dao/shift.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/shift/shift_service.dart';

class ShiftRepository extends AppRepository {
  final ShiftService _shiftService = ShiftService();

  Future<List<ShiftDAO>> getShifts({
    int? pageNo,
    int? pageRow,
    String? filterValue
  }) async {
    var result = await _shiftService.getShifts(
      pageNo: pageNo,
      pageRow: pageRow,
      filterValue: filterValue
    );
    List data = getResponseListData(result);
    return data.map((shifts)=>ShiftDAO.fromJson(shifts)).toList();
  }
}