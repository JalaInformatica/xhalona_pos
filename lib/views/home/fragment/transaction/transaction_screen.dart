import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_calendar.dart';
import 'package:xhalona_pos/core/constant/transaction.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/views/home/fragment/transaction/transaction_widget.dart';
import 'package:xhalona_pos/views/home/fragment/transaction/transaction_controller.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({super.key});

  final TransactionController controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => Row(
                      children: [
                        Checkbox(
                          value: controller.isOnline.value,
                          onChanged: (_) => controller.updateFilterTrxOnline(),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        Text(
                          "Online",
                          style: AppTextStyle.textBodyStyle(),
                        ),
                        Spacer(),
                        AppTextButton(
                            onPressed: () {
                              SmartDialog.show(builder: (context) {
                                return AppDialog(
                                    content: SizedBox(
                                        width: double.maxFinite,
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              AppCalendar(
                                                focusedDay: DateTime(
                                                    controller.filterYear.value,
                                                    controller
                                                        .filterMonth.value,
                                                    controller.filterDay.value),
                                                onDaySelected:
                                                    (selectedDay, _) {
                                                  controller
                                                      .updateFilterTrxDate(
                                                          selectedDay);
                                                  SmartDialog.dismiss();
                                                },
                                              ),
                                            ])));
                              });
                            },
                            borderColor: AppColor.grey300,
                            foregroundColor: AppColor.blackColor,
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Text(
                                "${controller.filterDay ?? "--"}/${controller.filterMonth ?? "--"}/${controller.filterYear ?? "--"}",
                                style: AppTextStyle.textBodyStyle(),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Icon(
                                Icons.calendar_month,
                                color: AppColor.grey500,
                              )
                            ]))
                      ],
                    )),
                SizedBox(
                  height: 5.h,
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(
                      () => Wrap(
                        spacing: 5.w,
                        children: [
                          transactionFilterButton(
                            text: "Berjalan",
                            onPressed: () =>
                                controller.updateFilterTrxStatusCategory(
                                    TransactionStatusCategory.progress),
                            isSelected: controller.trxStatusCategory.value ==
                                TransactionStatusCategory.progress,
                          ),
                          transactionFilterButton(
                              text: "Berhasil",
                              onPressed: () =>
                                  controller.updateFilterTrxStatusCategory(
                                      TransactionStatusCategory.done),
                              isSelected: controller.trxStatusCategory.value ==
                                  TransactionStatusCategory.done),
                          transactionFilterButton(
                              text: "Tertunda",
                              onPressed: () =>
                                  controller.updateFilterTrxStatusCategory(
                                      TransactionStatusCategory.late),
                              isSelected: controller.trxStatusCategory.value ==
                                  TransactionStatusCategory.late),
                          transactionFilterButton(
                              text: "Batal",
                              onPressed: () =>
                                  controller.updateFilterTrxStatusCategory(
                                      TransactionStatusCategory.cancel),
                              isSelected: controller.trxStatusCategory.value ==
                                  TransactionStatusCategory.cancel),
                          transactionFilterButton(
                              text: "Semua",
                              onPressed: () =>
                                  controller.updateFilterTrxStatusCategory(
                                      TransactionStatusCategory.all),
                              isSelected: controller.trxStatusCategory.value ==
                                  TransactionStatusCategory.all),
                          transactionFilterButton(
                              text: "Penjadwalan Ulang",
                              onPressed: () =>
                                  controller.updateFilterTrxStatusCategory(
                                      TransactionStatusCategory.reschedule),
                              isSelected: controller.trxStatusCategory.value ==
                                  TransactionStatusCategory.reschedule),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 5.h,
                ),
                Obx(() => Expanded(
                        child: AppTable(
                      onSearch: (filterValue) =>
                          controller.updateFilterValue(filterValue),
                      onChangePageNo: (pageNo) =>
                          controller.updatePageNo(pageNo),
                      onChangePageRow: (pageRow) =>
                          controller.updatePageRow(pageRow),
                      pageNo: controller.pageNo.value,
                      pageRow: controller.pageRow.value,
                      titles: [
                        AppTableTitle(value: "Trx"),
                        AppTableTitle(value: "Tanggal"),
                        AppTableTitle(value: "Kasir"),
                        AppTableTitle(value: "Nama"),
                        AppTableTitle(value: "Antrian"),
                        AppTableTitle(value: "Status"),
                        AppTableTitle(value: "Keterangan"),
                        AppTableTitle(value: "Pemesanan"),
                        AppTableTitle(value: "Total"),
                        AppTableTitle(value: "Pembayaran"),
                        AppTableTitle(value: "Total Bayar"),
                        AppTableTitle(value: "Hutang")
                      ],
                      data: List.generate(controller.transactionHeader.length,
                          (int i) {
                        var transaction = controller.transactionHeader[i];
                        return [
                          AppTableCell(
                              value: transaction.salesId
                                  .substring(transaction.salesId.length - 4),
                              index: i),
                          AppTableCell(
                              value: transaction.salesDate.split("T")[0],
                              index: i),
                          AppTableCell(value: transaction.cashierBy, index: i),
                          AppTableCell(
                              value: transaction.supplierName, index: i),
                          AppTableCell(
                              value: transaction.queueNumber.toString(),
                              index: i),
                          AppTableCell(value: transaction.sourceId, index: i),
                          AppTableCell(value: transaction.statusDesc, index: i),
                          AppTableCell(
                              value: transaction.bookingType, index: i),
                          AppTableCell(
                              value: transaction.nettoVal.toString(), index: i),
                          AppTableCell(
                              value: transaction.settlePaymentMethod, index: i),
                          AppTableCell(
                              value: transaction.paymentVal.toString(),
                              index: i),
                          AppTableCell(
                              value: transaction.totalHutang.toString(),
                              index: i),
                        ];
                      }),
                      onRefresh: () => controller.fetchTransactions(),
                      isRefreshing: controller.isLoading.value,
                    )))
              ],
            )));
  }
}
