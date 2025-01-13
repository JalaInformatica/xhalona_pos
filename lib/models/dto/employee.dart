enum EmployeeSortBy { empId }

class EmployeeDTO {
  static const Map<EmployeeSortBy, String> sortBy = {
    EmployeeSortBy.empId: "EMP_ID",
  };
}