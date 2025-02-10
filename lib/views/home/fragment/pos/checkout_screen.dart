import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dto/paymentTransaction.dart';
import 'package:xhalona_pos/views/home/fragment/pos/checkout_controller.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_controller.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/widgets/app_pdf_viewer.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';

class CheckoutScreen extends StatefulWidget {
  final String salesId;
  final int brutoVal;
  final int discVal;
  final int nettoVal;
  CheckoutScreen(
      {super.key,
      required this.salesId,
      required this.brutoVal,
      required this.discVal,
      required this.nettoVal});

  @override
  State<StatefulWidget> createState() => _CheckoutScreen();
}

class _CheckoutScreen extends State<CheckoutScreen> {
  final CheckoutController _controller = Get.put(CheckoutController());

  final TextEditingController _tunaiController = TextEditingController();
  final TextEditingController _nonTunai1Controller = TextEditingController();
  final TextEditingController _nonTunai2Controller = TextEditingController();
  final TextEditingController _nonTunai3Controller = TextEditingController();
  final TextEditingController _komplimenController = TextEditingController();
  final TextEditingController _hutangController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _kembalianController = TextEditingController();
  final TextEditingController _titipanController = TextEditingController();

  @override
  void initState() {
    _controller.totalPaid.value = widget.nettoVal;
    _controller.tunai.value = widget.nettoVal;
    super.initState();
  }

  bool validateCheckout() {
    return (_controller.totalPaid.value < widget.nettoVal ||
        (_controller.nonTunai1.value > 0 &&
            _controller.metodeNonTunai1.value.isEmpty) ||
        (_controller.nonTunai2.value > 0 &&
            _controller.metodeNonTunai2.value.isEmpty));
  }

  void adjustPembayaran(int key, String amount) {
    int parsedAmount = unFormatThousands(amount);
    switch (key) {
      case 0:
        if (parsedAmount < widget.nettoVal) {
          _controller.tunai.value = _controller.tunai.value;
          _tunaiController.text = formatThousands(_controller.tunai.value.toString());
        } else {
          _controller.tunai.value = parsedAmount;
        }
        break;
      case 1:
        int diff = parsedAmount - _controller.nonTunai1.value;
        _controller.nonTunai1.value = parsedAmount;

        if (parsedAmount >= widget.nettoVal) {
          _controller.tunai.value = 0;
          _controller.nonTunai2.value = 0;
        } else {
          _controller.tunai.value -= diff; 
        }
        break;

      case 2:
        int diff = parsedAmount - _controller.nonTunai2.value;
        _controller.nonTunai2.value = parsedAmount;

        if (parsedAmount >= widget.nettoVal) {
          _controller.tunai.value = 0;
          _controller.nonTunai1.value = 0;
        } else {
          if (_controller.tunai > 0) {
            _controller.tunai.value -= diff;
          } else {
            if (diff.isNegative) {
              _controller.tunai.value -= diff;
            } else {
              _controller.nonTunai1.value -= diff;
            }
          }
        }
        break;
      case 3:
        break;
      case 4:
        _controller.hutang.value = parsedAmount;
        break;
    }

    _controller.totalPaid.value = _controller.tunai.value +
        _controller.nonTunai1.value +
        _controller.nonTunai2.value +
        _controller.komplimen.value;
    _controller.hutang.value;

    if (_controller.totalPaid.value > widget.nettoVal) {
      _controller.kembalian.value =
          _controller.totalPaid.value - widget.nettoVal;
    }

    else {
      if(_controller.kembalian.value > 0) _controller.kembalian.value = 0;
      if(_controller.titipan.value > 0) _controller.titipan.value = 0;
    }

    // _controller.tunai.value = payments["tunai"]!;
    // _controller.nonTunai1.value = payments["nonTunai1"]!;
    // _controller.nonTunai2.value = payments["nonTunai2"]!;
    // _controller.komplimen.value = payments["compliment"]!;
    // _controller.hutang.value = payments["hutang"]!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColor.whiteColor,
            body: Column(children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 15.h, left: 15.w, right: 5.w, bottom: 15.h),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Checkout",
                        style: AppTextStyle.textTitleStyle(
                            color: AppColor.primaryColor),
                      ),
                      AppIconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            color: AppColor.dangerColor,
                          ))
                    ]),
              ),
              Expanded(
                  child: ListView(
                padding: EdgeInsets.only(bottom: 15.h, left: 15.w, right: 15.w),
                children: [
                  Text(
                    "Ringkasan Tagihan",
                    style: AppTextStyle.textSubtitleStyle(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ",
                        style:
                            AppTextStyle.textBodyStyle(color: AppColor.grey500),
                      ),
                      Text(
                        formatToRupiah(widget.brutoVal),
                        style: AppTextStyle.textBodyStyle(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Diskon: ",
                        style:
                            AppTextStyle.textBodyStyle(color: AppColor.grey500),
                      ),
                      Text(
                        formatToRupiah(widget.discVal),
                        style: AppTextStyle.textBodyStyle(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tagihan: ",
                        style:
                            AppTextStyle.textBodyStyle(color: AppColor.grey500),
                      ),
                      Text(
                        formatToRupiah(widget.nettoVal),
                        style: AppTextStyle.textSubtitleStyle(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Pembayaran",
                    style: AppTextStyle.textSubtitleStyle(),
                  ),
                  Row(
                    spacing: 5.w,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            "Tunai: ",
                            style: AppTextStyle.textBodyStyle(),
                          )),
                      Expanded(
                          flex: 2,
                          child: Obx(() => AppTextField(
                              isThousand: true,
                              unfocusWhenTapOutside: false,
                              textEditingController: _tunaiController
                                ..text = formatThousands(
                                    _controller.tunai.value.toString()),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 8.h),
                              context: context,
                              hintText: "0",
                              textAlign: TextAlign.right,
                              onChanged: (val) {
                                adjustPembayaran(0, val);
                              }))),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    spacing: 5.w,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Obx(() => DropdownButton<String>(
                              dropdownColor: AppColor.whiteColor,
                              value: _controller.metodeNonTunai1.value != ""
                                  ? _controller.metodeNonTunai1.value
                                  : "Non-tunai",
                              items: [
                                DropdownMenuItem(
                                    value: "Non-tunai",
                                    child: Text(
                                      "Non-tunai",
                                      style: AppTextStyle.textBodyStyle(
                                          color: AppColor.grey500),
                                    )),
                                ..._controller.metodeBayar.map(
                                  (item) => DropdownMenuItem(
                                      value: item.payMetodeId,
                                      child: Text(
                                        item.payMetodeName,
                                        style: AppTextStyle.textBodyStyle(),
                                      )),
                                )
                              ],
                              onChanged: (val) {
                                _controller.metodeNonTunai1.value = val!;
                              }))),
                      Expanded(
                          flex: 2,
                          child: Obx(() => AppTextField(
                              isThousand: true,
                              unfocusWhenTapOutside: false,
                              textEditingController: _nonTunai1Controller
                                ..text = formatThousands(
                                    _controller.nonTunai1.value.toString()),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 8.h),
                              context: context,
                              hintText: "0",
                              textAlign: TextAlign.right,
                              onChanged: (val) {
                                adjustPembayaran(1, val);
                              }))),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    spacing: 5.w,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Obx(() => DropdownButton<String>(
                              dropdownColor: AppColor.whiteColor,
                              value: _controller.metodeNonTunai2.value != ""
                                  ? _controller.metodeNonTunai2.value
                                  : "Non-tunai",
                              items: [
                                DropdownMenuItem(
                                    value: "Non-tunai",
                                    child: Text(
                                      "Non-tunai",
                                      style: AppTextStyle.textBodyStyle(
                                          color: AppColor.grey500),
                                    )),
                                ..._controller.metodeBayar.map(
                                  (item) => DropdownMenuItem(
                                      value: item.payMetodeId,
                                      child: Text(
                                        item.payMetodeName,
                                        style: AppTextStyle.textBodyStyle(),
                                      )),
                                )
                              ],
                              onChanged: (val) {
                                _controller.metodeNonTunai2.value = val!;
                              }))),
                      Expanded(
                          flex: 2,
                          child: Obx(() => AppTextField(
                              isThousand: true,
                              unfocusWhenTapOutside: false,
                              textEditingController: _nonTunai2Controller
                                ..text = formatThousands(
                                    _controller.nonTunai2.value.toString()),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 8.h),
                              context: context,
                              hintText: "0",
                              textAlign: TextAlign.right,
                              onChanged: (val) {
                                adjustPembayaran(2, val);
                              }))),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    spacing: 5.w,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            "Komplimen: ",
                            style: AppTextStyle.textBodyStyle(
                                color: AppColor.grey500),
                          )),
                      Expanded(
                          flex: 2,
                          child: Obx(() => AppTextField(
                              disabled: true,
                              isThousand: true,
                              unfocusWhenTapOutside: false,
                              textEditingController: _komplimenController
                                ..text = formatThousands(
                                    _controller.komplimen.value.toString()),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 8.h),
                              context: context,
                              hintText: "0",
                              textAlign: TextAlign.right,
                              onChanged: (val) {
                                adjustPembayaran(3, val);
                              }))),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    spacing: 5.w,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            "Hutang: ",
                            style: AppTextStyle.textBodyStyle(
                                color: AppColor.grey500),
                          )),
                      Expanded(
                          flex: 2,
                          child: Obx(() => AppTextField(
                              disabled: true,
                              isThousand: true,
                              unfocusWhenTapOutside: false,
                              textEditingController: _hutangController
                                ..text = formatThousands(
                                    _controller.hutang.value.toString()),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 8.h),
                              context: context,
                              hintText: "0",
                              textAlign: TextAlign.right,
                              onChanged: (val) {
                                adjustPembayaran(4, val);
                              }))),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    spacing: 5.w,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Text(
                                "Total: ",
                                style: AppTextStyle.textBodyStyle(
                                    fontWeight: FontWeight.bold),
                              ))),
                      Expanded(
                          flex: 2,
                          child: Container(
                              padding: EdgeInsets.only(top: 5.h),
                              decoration: BoxDecoration(
                                  border: Border(top: BorderSide())),
                              child: Obx(() => AppTextField(
                                    textEditingController: _totalController
                                      ..text = formatThousands(_controller
                                          .totalPaid.value
                                          .toString()),
                                    readOnly: true,
                                    isThousand: true,
                                    unfocusWhenTapOutside: false,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 8.h),
                                    context: context,
                                    textAlign: TextAlign.right,
                                  )))),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    spacing: 5.w,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Text(
                                "Kembalian: ",
                                style: AppTextStyle.textBodyStyle(
                                    fontWeight: FontWeight.bold),
                              ))),
                      Expanded(
                          flex: 2,
                          child: Obx(() => AppTextField(
                                isThousand: true,
                                unfocusWhenTapOutside: false,
                                textEditingController: _kembalianController
                                  ..text = formatThousands(
                                      _controller.kembalian.value.toString()),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 8.h),
                                context: context,
                                hintText: "0",
                                textAlign: TextAlign.right,
                                disabled: _controller.totalPaid.value <=
                                    widget.nettoVal,
                                onChanged: (val) {
                                  if (unFormatThousands(val) <
                                      _controller.totalPaid.value) {
                                    if (unFormatThousands(val) >
                                        _controller.totalPaid.value -
                                            widget.nettoVal) {
                                      _controller.kembalian.value =
                                          _controller.totalPaid.value -
                                              widget.nettoVal;
                                      _controller.titipan.value = 0;
                                    } else {
                                      _controller.kembalian.value =
                                          unFormatThousands(val);
                                      _controller.titipan.value =
                                          _controller.totalPaid.value -
                                              widget.nettoVal -
                                              unFormatThousands(val);
                                    }
                                  } else {
                                    _kembalianController.text = formatThousands(
                                        _controller.kembalian.value.toString());
                                  }
                                },
                              ))),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    spacing: 5.w,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Text(
                                "Titipan: ",
                                style: AppTextStyle.textBodyStyle(
                                    fontWeight: FontWeight.bold),
                              ))),
                      Expanded(
                          flex: 2,
                          child: Obx(() => AppTextField(
                                isThousand: true,
                                unfocusWhenTapOutside: false,
                                disabled: _controller.totalPaid.value <=
                                    widget.nettoVal,
                                textEditingController: _titipanController
                                  ..text = formatThousands(
                                      _controller.titipan.value.toString()),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 8.h),
                                context: context,
                                hintText: "0",
                                textAlign: TextAlign.right,
                                onChanged: (val) {
                                  if (unFormatThousands(val) <
                                      _controller.totalPaid.value) {
                                    if (unFormatThousands(val) >
                                        (_controller.totalPaid.value -
                                            widget.nettoVal)) {
                                      _controller.titipan.value =
                                          _controller.totalPaid.value -
                                              widget.nettoVal;
                                      _controller.kembalian.value = 0;
                                    } else {
                                      _controller.titipan.value =
                                          unFormatThousands(val);
                                      _controller.kembalian.value =
                                          _controller.totalPaid.value -
                                              widget.nettoVal -
                                              unFormatThousands(val);
                                    }
                                  } else {
                                    _titipanController.text = formatThousands(
                                        _controller.titipan.value.toString());
                                  }
                                },
                              ))),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () => AppElevatedButton(
                            disabled: validateCheckout(),
                            backgroundColor: AppColor.primaryColor,
                            foregroundColor: AppColor.whiteColor,
                            onPressed: () {
                              _controller
                                  .payment(PaymentTransactionDTO(
                                salesId: widget.salesId,
                                paymentMethod1: "TUNAI",
                                paymentMethod2:
                                    _controller.metodeNonTunai1.value,
                                paymentMethod3:
                                    _controller.metodeNonTunai2.value,
                                paymentMethod4: "",
                                paymentVal1: _controller.tunai.value,
                                paymentVal2: _controller.nonTunai1.value,
                                paymentVal3: _controller.nonTunai2.value,
                                paymentVal4: 0,
                                paymentTotalBill: widget.nettoVal,
                                complimentVal: _controller.komplimen.value,
                                hutangVal: _controller.hutang.value,
                                kembalian: _controller.kembalian.value,
                                titipanVal: _controller.titipan.value,
                              ))
                                  .then((val) {
                                _controller.printNota(widget.salesId)
                                    .then((url) => Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AppPDFViewer(pdfUrl: url),
                                          ),
                                        )
                                            .then((_) {
                                          Get.reload<PosController>();
                                        }));
                              });
                            },
                            child: Text(
                              "Checkout",
                              style: AppTextStyle.textSubtitleStyle(),
                            )),
                      ))
                ],
              ))
            ])));
  }
}
