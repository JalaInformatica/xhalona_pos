class BirthDateDAO {
  final String date;
  final int timezoneType;
  final String timezone;

  const BirthDateDAO({
    this.date = "",
    this.timezoneType = 0,
    this.timezone = "",
  });

  BirthDateDAO.fromJson(Map<String, dynamic> json) :
    date = json['date'] ?? "",
    timezoneType = json['timezone_type'] ?? 0,
    timezone = json['timezone'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'timezone_type': timezoneType,
      'timezone': timezone,
    };
  }
}
