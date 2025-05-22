import 'package:intl/intl.dart';

class DateHelper {
  static String dateToAPIFormat(DateTime date){
    return DateFormat("yyyy-MM-dd").format(date);
  }

  static List<String> listMonthIDN() {
    return [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
  }

}