import 'package:intl/intl.dart';

String formatToRupiah(int number) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID', // Locale for Indonesian currency
    symbol: 'Rp', // Rupiah symbol
    decimalDigits: 0, // Number of decimal places
  );
  return formatter.format(number);
}

String formatThousands(String text){
  try {
    int number = int.parse(text);
    return NumberFormat("#,###", "id_ID").format(number);
  } catch (e) {
    return text;
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

String shortenTrxId(String text) {
  return text.replaceAll(RegExp(r'(?<=AM)0+'), '');
}

String shortenTrxIdAndName(String trxId, {String guestName="", String supplierName=""}){
  if(guestName!="" || supplierName!=""){
    return "${shortenTrxId(trxId)}/${guestName!="" ? guestName : supplierName}";
  }
  return shortenTrxId(trxId);
}