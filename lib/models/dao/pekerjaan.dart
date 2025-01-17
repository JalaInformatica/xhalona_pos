class PekerjaanDAO {
  final String jobId;
  final String jobDesc;
  final int sortOrder;

  // Constructor with required named parameters
  PekerjaanDAO({
    required this.jobId,
    required this.jobDesc,
    required this.sortOrder,
  });

  // Factory method to parse JSON
  factory PekerjaanDAO.fromJson(Map<String, dynamic> json) {
    return PekerjaanDAO(
      jobId: json['JOB_ID'] ?? "",
      jobDesc: json['JOB_DESC'] ?? "",
      sortOrder: json['SORT_ORDER'] ?? 0,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'JOB_ID': jobId,
      'JOB_DESC': jobDesc,
      'SORT_ORDER': sortOrder,
    };
  }
}
