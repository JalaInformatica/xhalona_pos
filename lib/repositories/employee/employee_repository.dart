import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:xhalona_pos/repositories/app_repository.dart';
import 'package:xhalona_pos/services/employee/employee_service.dart';

class EmployeeRepository extends AppRepository {
  final EmployeeService _employeeService = EmployeeService();

  Future<List<EmployeeDAO>> getEmployees({
    int? pageNo,
    int? pageRow,
    String? filterField,
    String? filterValue,
  }) async {
    var result = await _employeeService.getEmployees(
        pageNo: pageNo,
        pageRow: pageRow,
        filterField: filterField,
        filterValue: filterValue);
    List data = getResponseListData(result);
    return data.map((employee) => EmployeeDAO.fromJson(employee)).toList();
  }
}
