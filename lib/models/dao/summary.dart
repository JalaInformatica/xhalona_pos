class SummaryDAO {
  int total;

  SummaryDAO({
    this.total = 0,
  });

  SummaryDAO.fromJson(Map<String, dynamic> json) : total = json['TOTAL'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'TOTAL': total,
    };
  }
}
