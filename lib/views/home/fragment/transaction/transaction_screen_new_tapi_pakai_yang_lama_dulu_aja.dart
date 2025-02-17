import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/transaction.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_calendar.dart';
import 'package:xhalona_pos/core/constant/transaction.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_controller.dart';
import 'package:xhalona_pos/views/home/fragment/transaction/transaction_widget.dart';
import 'package:xhalona_pos/views/home/fragment/transaction/transaction_controller.dart';
import 'package:xhalona_pos/widgets/app_table2.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({super.key});

  final TransactionController controller = Get.put(TransactionController());

  void actions(TransactionHeaderDAO transaction){
    SmartDialog.show(
      builder: (context){
        return AppDialog(
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width*0.5,
              maxHeight: MediaQuery.of(context).size.height*0.5,
            ),
            child: SingleChildScrollView(child: Column(
              spacing: 5.h,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Transaksi ${transaction.salesId}", style: AppTextStyle.textSubtitleStyle(),)),
                Row(
                  spacing: 5.w,
                  children: [
                    Expanded(
                      child: AspectRatio(aspectRatio: 1, child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.blueColor,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Column(
                          spacing: 5.h,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit, color: AppColor.whiteColor,),
                            Text("Edit", style: AppTextStyle.textSubtitleStyle(color: AppColor.whiteColor),)
                          ],
                        ),
                      )
                    )),
                    Expanded(
                      child: AspectRatio(aspectRatio: 1, child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.dangerColor,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Column(
                          spacing: 5.h,
                          mainAxisAlignment: MainAxisAlignment.center,                                              children: [
                            Icon(Icons.delete, color: AppColor.whiteColor,),
                            Text("Batal", style: AppTextStyle.textSubtitleStyle(color: AppColor.whiteColor,),)                                              ],
                        ),
                      )
                    )),
                  ],
                ),
                Row(
                  spacing: 5.w,
                  children: [
                    Expanded(
                      child: AspectRatio(aspectRatio: 1, child: AppElevatedButton(
                        onPressed: (){
                          var controller = Get.find<PosController>();
                          var homeController = Get.find<HomeController>();
                          controller.reinitTransaction(transaction).then(
                            (_)=>homeController.selectedMenuName.value="pos"
                          );
                          SmartDialog.dismiss();
                        },
                        borderColor: AppColor.doneColor,
                        backgroundColor: AppColor.doneColor,
                        child: Column(
                          spacing: 5.h,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,                                              children: [
                            Icon(Icons.open_in_new, color: AppColor.whiteColor,),
                            Text("Buka di POS", 
                            textAlign: TextAlign.center,
                              style: AppTextStyle.textSubtitleStyle(
                              color: AppColor.whiteColor, overflow: TextOverflow.visible),)                                              ],
                        ),
                      )
                    )),
                    Expanded(
                      child: AspectRatio(aspectRatio: 1, child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.purpleColor,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Column(
                          spacing: 5.h,
                          mainAxisAlignment: MainAxisAlignment.center,                                              children: [
                            Icon(Icons.print, color: AppColor.whiteColor,),
                            Text("Nota", style: AppTextStyle.textSubtitleStyle(color: AppColor.whiteColor,),)                                              ],
                        ),
                      )
                    )),
                  ],
                ),
              ],
            ),
          )
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                                "${controller.filterDay}/${controller.filterMonth}/${controller.filterYear}",
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
                        child: AppTable2(
                      onSearch: (filterValue) =>
                          controller.updateFilterValue(filterValue),
                      onChangePageNo: (pageNo) =>
                          controller.updatePageNo(pageNo),
                      onChangePageRow: (pageRow) =>
                          controller.updatePageRow(pageRow),
                      pageNo: controller.pageNo.value,
                      pageRow: controller.pageRow.value,
                      titles: [
                        AppTableTitle2(value: "Trx"),
                        AppTableTitle2(value: "Tanggal"),
                        AppTableTitle2(value: "Kasir"),
                        AppTableTitle2(value: "Nama"),
                        AppTableTitle2(value: "Antrian"),
                        AppTableTitle2(value: "Status"),
                        AppTableTitle2(value: "Keterangan"),
                        AppTableTitle2(value: "Pemesanan"),
                        AppTableTitle2(
                          textAlign: TextAlign.end,
                          value: "Total"),
                        AppTableTitle2(value: "Pembayaran"),
                        AppTableTitle2(
                          textAlign: TextAlign.end,
                          value: "Total Bayar"
                        ),
                        AppTableTitle2(
                          textAlign: TextAlign.end,
                          value: "Hutang"),
                        AppTableTitle2(
                          width: 200,
                          value: "Aksi")
                      ],
                      data: List.generate(controller.transactionHeader.length,
                          (int i) {
                        var transaction = controller.transactionHeader[i];
                        return [
                          AppTableCell2(
                            action: () => actions(transaction),
                            value: transaction.salesId
                                .substring(transaction.salesId.length - 4),
                          ),
                          AppTableCell2(
                            action: () => actions(transaction),
                            value: transaction.salesDate.split("T")[0],
                          ),
                          AppTableCell2(
                            action: () => actions(transaction),
                            value: transaction.cashierBy,
                          ),
                          AppTableCell2(
                            action: () => actions(transaction),
                            value: transaction.supplierName,
                          ),
                          AppTableCell2(
                            action: () => actions(transaction),
                            value: transaction.queueNumber.toString(),
                          ),
                          AppTableCell2(
                            action: () => actions(transaction),
                            value: transaction.sourceId,
                          ),
                          AppTableCell2(
                            action: () => actions(transaction),
                            value: transaction.statusDesc,
                          ),
                          AppTableCell2(
                            action: () => actions(transaction),
                            value: transaction.bookingType,
                          ),
                          AppTableCell2(
                            action: () => actions(transaction),
                            textAlign: TextAlign.end,
                            value: formatThousands(transaction.nettoVal.toString()),
                          ),
                          AppTableCell2(
                            action: () => actions(transaction),
                            value: transaction.settlePaymentMethod,
                          ),
                          AppTableCell2(
                            action: () => actions(transaction),
                            textAlign: TextAlign.end,
                            value: formatThousands(transaction.paymentVal.toString()),
                          ),
                          AppTableCell2(
                            action: () => actions(transaction),
                            textAlign: TextAlign.end,
                            value: formatThousands(transaction.totalHutang.toString()),
                          ),
                          AppTableCell2(
                            width: 200,
                            customWidget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                AppIconButton(
                                  onPressed: (){
                                    print("b");
                                  }, 
                                  icon: Icon(
                                    Icons.edit,
                                  )
                                ),
                                AppIconButton(
                                  onPressed: (){
                                    print("b");
                                  }, 
                                  icon: Icon(Icons.delete)
                                ),
                                AppIconButton(
                                  onPressed: (){
                                    var controller = Get.find<PosController>();
                                    var homeController = Get.find<HomeController>();
                                    controller.reinitTransaction(transaction).then(
                                      (_)=>homeController.selectedMenuName.value="pos"
                                    );
                                  }, 
                                  icon: Icon(Icons.open_in_new)
                                ),
                                AppIconButton(
                                  onPressed: (){
                                  }, 
                                  icon: Icon(Icons.print)
                                )
                              ],
                            ),
                          ),
                        ];
                      }),
                      onRefresh: () => controller.fetchTransactions(),
                      isRefreshing: controller.isLoading.value,
                    )))
              ],
            )));
  }
}
