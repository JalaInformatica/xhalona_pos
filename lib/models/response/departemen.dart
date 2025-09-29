class DepartemenDAO {
  final String kdDept;
  final String namaDept;
  final int sortOrder;

  // Constructor with required named parameters
  DepartemenDAO({
    required this.kdDept,
    required this.namaDept,
    required this.sortOrder,
  });

  // Factory method to parse JSON
  factory DepartemenDAO.fromJson(Map<String, dynamic> json) {
    return DepartemenDAO(
      kdDept: json['KD_DEPT'] ?? "",
      namaDept: json['NAMADEPARTMENT'] ?? "",
      sortOrder: json['SORT_ORDER'] ?? 0,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'KD_DEPT': kdDept,
      'NAMADEPARTMENT': namaDept,
      'SORT_ORDER': sortOrder,
    };
  }
}
