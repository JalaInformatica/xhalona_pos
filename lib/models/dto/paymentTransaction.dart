class PaymentTransactionDTO {
  String salesId;
  int paymentTotalBill;
  String paymentMethod1;
  String paymentMethod2;
  String paymentMethod3;
  String paymentMethod4;
  int paymentVal1;
  int paymentVal2;
  int paymentVal3;
  int paymentVal4;
  String paymentCardNo1;
  String paymentCardNo2;
  String paymentCardNo3;
  String paymentCardNo4;
  int complimentVal;
  int hutangVal;
  int kembalian;
  int titipanVal;

  PaymentTransactionDTO({
    this.salesId = "",
    this.paymentTotalBill = 0,
    this.paymentMethod1 = "",
    this.paymentMethod2 = "",
    this.paymentMethod3 = "",
    this.paymentMethod4 = "",
    this.paymentVal1 = 0,
    this.paymentVal2 = 0,
    this.paymentVal3 = 0,
    this.paymentVal4 = 0,
    this.paymentCardNo1 = "",
    this.paymentCardNo2 = "",
    this.paymentCardNo3 = "",
    this.paymentCardNo4 = "",
    this.complimentVal = 0,
    this.hutangVal = 0,
    this.kembalian = 0,
    this.titipanVal = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      "SALES_ID": salesId,
      "PAYMENT_TOTAL_BILL": paymentTotalBill.toString(),
      "PAYMENT_METHOD_1": paymentMethod1,
      "PAYMENT_METHOD_2": paymentMethod2,
      "PAYMENT_METHOD_3": paymentMethod3,
      "PAYMENT_METHOD_4": paymentMethod4,
      "PAYMENT_VAL_1": paymentVal1.toString(),
      "PAYMENT_VAL_2": paymentVal2.toString(),
      "PAYMENT_VAL_3": paymentVal3.toString(),
      "PAYMENT_VAL_4": paymentVal4.toString(),
      "PAYMENT_CARD_NO_1": paymentCardNo1,
      "PAYMENT_CARD_NO_2": paymentCardNo2,
      "PAYMENT_CARD_NO_3": paymentCardNo3,
      "PAYMENT_CARD_NO_4": paymentCardNo4,
      "COMPLIMENT_VAL": complimentVal.toString(),
      "HUTANG_VAL": hutangVal.toString(),
      "KEMBALIAN": kembalian.toString(),
      "TITIPAN_VAL": titipanVal.toString(),
    };
  }
}
