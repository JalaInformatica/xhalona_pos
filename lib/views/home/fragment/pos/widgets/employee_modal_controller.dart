import 'package:get/get.dart';
import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:xhalona_pos/repositories/employee/employee_repository.dart';

class EmployeeModalController extends GetxController{
  final EmployeeRepository _employeeRepository = EmployeeRepository();
  var employees = <EmployeeDAO>[].obs;

  Future<void> fetchEmployees({String? filter}) async{
    employees.value = await _employeeRepository.getEmployees(filterValue: filter);
  }

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

}