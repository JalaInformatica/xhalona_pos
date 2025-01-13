class RequestGlobalFilters {
  final int? pageNo;
  final int? pageRow;
  final String? filterField;
  final String? filterValue;

  const RequestGlobalFilters({
    this.pageNo = 1,
    this.pageRow = 10,
    this.filterField = "",
    this.filterValue = "",
  });
}


class RequestGlobalSortType {
  static final String ascending = "ASC";
  static final String descending = "DESC";
}