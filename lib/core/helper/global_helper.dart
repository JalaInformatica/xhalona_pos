import 'package:intl/intl.dart';

String formatToRupiah(int number) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID', // Locale for Indonesian currency
    symbol: 'Rp', // Rupiah symbol
    decimalDigits: 0, // Number of decimal places
  );
  return formatter.format(number);
}

String formatToRupiahShort({required int number, int places=2}) {
  if (number >= 1000000000) {
    double result = number / 1000000000;
    return 'Rp${result.toStringAsFixed(places)}M';
  } else if (number >= 1000000) {
    double result = number / 1000000;
    return 'Rp${result.toStringAsFixed(places)}jt';
  } else if (number >= 1000) {
    double result = number / 1000;
    return 'Rp${result.toStringAsFixed(places)}rb';
  } else {
    return 'Rp$number';
  }
}


String formatThousands(String text){
  try {
    int number = int.parse(text);
    return NumberFormat("#,###", "id_ID").format(number);
  } catch (e) {
    return "0";
  }
}

int unFormatThousands(String strNumber){
  try {
    strNumber = strNumber.replaceAll('.','');
    return int.parse(strNumber);
  } catch (e){
    return 0;
  }
}

String formatToDDMMYYYY(DateTime? dateTime){
  if(dateTime==null){
    return '';
  }
  return DateFormat('dd-MM-yyyy').format(dateTime);
}

String getPercentage(int of, int from, {int decimalPoint=2}) {
  if (from == 0) return "0.00%";
  double percentage = (of / from) * 100;
  return "${percentage.toStringAsFixed(decimalPoint)}%";
}

String shortenTrxId(String text) {
  return text.replaceAll(RegExp(r'(?<=AM)0+'), '');
}

String shortenTrxIdAndName(String trxId, {String guestName="", String supplierName=""}){
  if(guestName!="" || supplierName!=""){
    return "${shortenTrxId(trxId)}/${guestName!="" ? guestName : supplierName}";
  }
  return shortenTrxId(trxId);
}