import 'package:intl/intl.dart';

String formatToRupiah(int number) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID', // Locale for Indonesian currency
    symbol: 'Rp', // Rupiah symbol
    decimalDigits: 0, // Number of decimal places
  );
  return formatter.format(number);
}