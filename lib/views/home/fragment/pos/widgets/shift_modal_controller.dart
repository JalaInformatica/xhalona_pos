import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/shift.dart';
import 'package:xhalona_pos/repositories/shift/shift_repository.dart';

class ShiftModalController extends GetxController{
  final ShiftRepository _shiftRepository = ShiftRepository();
  var shifts = <ShiftDAO>[].obs;

  Future<void> fetchShifts() async {
    try {
      final result = await _shiftRepository.getShifts();
      shifts.value = result;
    }
    finally {
      
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchShifts();
  }
}