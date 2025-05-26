import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/transaction.dart';
import 'package:xhalona_pos/widgets/app_dialog2.dart';
import 'package:xhalona_pos/widgets/app_dialog_list.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/widgets/app_month_picker.dart';
import 'package:xhalona_pos/widgets/app_pdf_viewer.dart';
import 'package:xhalona_pos/widgets/app_radio_text.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_calendar.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/core/constant/transaction.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_controller.dart';
import 'package:xhalona_pos/views/home/fragment/transaction/form/trx_form.dart';
import 'package:xhalona_pos/repositories/transaction/transaction_repository.dart';
import 'package:xhalona_pos/views/home/fragment/transaction/form/ubah_terapis.dart';
import 'package:xhalona_pos/views/home/fragment/transaction/transaction_widget.dart';
import 'package:xhalona_pos/views/home/fragment/transaction/transaction_controller.dart';
import 'package:xhalona_pos/widgets/app_table2.dart';
import 'package:xhalona_pos/widgets/app_tile.dart';

// ignore: must_be_immutable
class TransactionScreen extends StatelessWidget {
  TransactionScreen({super.key});

  final TransactionController controller = Get.put(TransactionController());
  TransactionRepository _trxRepository = TransactionRepository();
  bool paidBooking = false;
  bool onWorking = false;
  bool onDestination = false;
  bool reschedule = false;
  bool accBooking = false;
  bool arrivedDestination = false;
  bool finish = false;
  bool cancelByStore = false;
  bool toHome = false;
  bool newOrder = false;

  void actions(BuildContext context, TransactionHeaderDAO transaction) {
    List<AppTile> actionTiles = [
      // 0
      AppDialogList.editAppTile(
        onTap: (){
          
        }
      ),
      // 1
      AppDialogList.deleteAppTile(
        onTap: (){}
      ),
      //2
      AppDialogList.defaultActionAppTile(
        text: "Buka di POS", 
        icon: Icons.open_in_new, 
        onTap: (){
          var controller = Get.find<PosController>();
          var homeController = Get.find<HomeController>();
          controller.reinitTransaction(transaction).then(
              (_) => homeController.selectedMenuName.value =
                  "pos");
          SmartDialog.dismiss();
        }
      ),
      //3
      AppDialogList.defaultActionAppTile(
        text: "Nota", 
        icon: Icons.print, 
        onTap: (){
          controller.printNota(transaction.salesId).then(
            (url) => Get.to(
              ()=>AppPDFViewer(pdfUrl: url,)
            )
          );
          SmartDialog.dismiss();
        }
      ),
      // 4
      AppDialogList.defaultActionAppTile(
        text: "Checkout", 
        icon: Icons.shopping_cart, 
        onTap: (){
          // controller.printNota(transaction.salesId).then(
          //   (url) => Get.to(
          //     ()=>AppPDFViewer(pdfUrl: url,)
          //   )
          // );
          SmartDialog.dismiss();
        }
      ),
      AppDialogList.defaultActionAppTile(
        text: "Nota", 
        icon: Icons.receipt, 
        onTap: (){
          controller.printNota(transaction.salesId).then(
            (url) => Get.to(
              ()=>AppPDFViewer(pdfUrl: url,)
            )
          );
          SmartDialog.dismiss();
        }
      ),
      
    ];
    List<AppTile> activeActionTiles = [];
    print(transaction.statusIdDesc);
    switch(transaction.statusIdDesc){
      case "NEW ORDER":
       activeActionTiles=[
        actionTiles[2],
        actionTiles[0],
        actionTiles[4],
        actionTiles[5],
       ]; 
      break;
    }
    AppDialogList.showListActionsDialog(
      title: transaction.salesId, 
      icon: Icons.shopping_bag,
      actionTiles: activeActionTiles
    );
  }

  @override
  Widget build(BuildContext context) {
    // handleOnTrx({String? actionId, String? salesId, String? statusDesc}) async {
    //   String result = await _trxRepository.onTransactionHeader(
    //     actionId: actionId,
    //     salesId: salesId,
    //     statusDesc: statusDesc,
    //   );

    //   bool isSuccess = result == "1";
    //   if (isSuccess) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Data gagal disimpan!')),
    //     );
    //   } else {
    //     Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(builder: (context) => HomeScreen()),
    //       (route) => false,
    //     );
    //     controller.fetchTransactions();
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Data berhasil disimpan!')),
    //     );
    //   }
    // }

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
                              final dateType = controller.filterDateType.value.obs;
                              final day = controller.filterDay.value.obs;
                              final month = controller.filterMonth.value.obs;
                              final year = controller.filterYear.value.obs;
                              SmartDialog.show(builder: (context) {
                                return AppDialog2(
                                  actions: [
                                    AppTextButton(
                                      borderColor: AppColor.transparentColor,
                                      backgroundColor: AppColor.grey500,
                                      foregroundColor: AppColor.whiteColor,
                                      onPressed: () {
                                        SmartDialog.dismiss();
                                      },
                                      child: Text("Batal")
                                    ),
                                    AppDialogList.confirmDialogButton(
                                      onPressed: () {
                                        SmartDialog.dismiss();
                                        controller.updateFilterTrxDate(
                                          dateType: dateType.value,
                                          day: dateType.value == DateType.DATE? day.value : null,
                                          month: month.value,
                                          year: year.value
                                        );
                                      },
                                      confirmText: "Terapkan"
                                    )
                                  ],
                                  child: Obx(
                                    () => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          spacing: 5.w,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppRadioText(
                                                text: "Tanggal",
                                                value: DateType.DATE,
                                                groupValue: dateType.value,
                                                onChanged: (val) {
                                                  dateType.value = val!;
                                                }),
                                            AppRadioText(
                                                text: "Bulan",
                                                value: DateType.MONTH,
                                                groupValue: dateType.value,
                                                onChanged: (val) {
                                                  dateType.value = val!;
                                                }),
                                            AppRadioText(
                                                text: "-",
                                                value: DateType.NONE,
                                                groupValue: dateType.value,
                                                onChanged: (val) {
                                                  dateType.value = val!;
                                                }),
                                          ],
                                        ),
                                        if (dateType.value == DateType.MONTH)
                                          AppMonthPicker(
                                              year: year.value ??
                                                  controller.dateNow.year,
                                              selectedMonth: month.value ??
                                                  controller.dateNow.month,
                                              onMonthSelected: (val) {
                                                day.value = null;
                                                month.value = val.month;
                                                year.value = val.year;
                                              }),
                                        if (dateType.value == DateType.DATE)
                                          AppCalendar(
                                            focusedDay: DateTime(
                                                year.value ??
                                                    controller.dateNow.year,
                                                month.value ??
                                                    controller.dateNow.month,
                                                day.value ??
                                                    controller.dateNow.day),
                                            onDaySelected: (selectedDay, _) {
                                              day.value = selectedDay.day;
                                              month.value = selectedDay.month;
                                              year.value = selectedDay.year;
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                            borderColor: AppColor.grey300,
                            foregroundColor: AppColor.blackColor,
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Obx(() => Text(
                                    controller.filterDateType.value == DateType.DATE
                                        ? "${controller.filterDay.value}/${controller.filterMonth}/${controller.filterYear}"
                                        : controller.filterDateType.value ==
                                                DateType.MONTH
                                            ? "${controller.filterMonth}/${controller.filterYear}"
                                            : "-",
                                    style: AppTextStyle.textBodyStyle(),
                                  )),
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
                            textAlign: TextAlign.end, value: "Total"),
                        AppTableTitle2(value: "Pembayaran"),
                        AppTableTitle2(
                            textAlign: TextAlign.end, value: "Total Bayar"),
                        AppTableTitle2(
                            textAlign: TextAlign.end, value: "Hutang"),
                        AppTableTitle2(width: 200, value: "Aksi")
                      ],
                      data: List.generate(controller.transactionHeader.length,
                          (int i) {
                        var transaction = controller.transactionHeader[i];
                        return [
                          AppTableCell2(
                            action: () => actions(context, transaction),
                            value: transaction.salesId
                                .substring(transaction.salesId.length - 4),
                          ),
                          AppTableCell2(
                            action: () => actions(context, transaction),
                            value: transaction.salesDate.split("T")[0],
                          ),
                          AppTableCell2(
                            action: () => actions(context,transaction),
                            value: transaction.cashierBy,
                          ),
                          AppTableCell2(
                            action: () => actions(context,transaction),
                            value: transaction.supplierName,
                          ),
                          AppTableCell2(
                            action: () => actions(context,transaction),
                            value: transaction.queueNumber.toString(),
                          ),
                          AppTableCell2(
                            action: () => actions(context,transaction),
                            value: transaction.sourceId,
                          ),
                          AppTableCell2(
                            action: () => actions(context,transaction),
                            value: transaction.statusDesc,
                          ),
                          AppTableCell2(
                            action: () => actions(context,transaction),
                            value: transaction.bookingType,
                          ),
                          AppTableCell2(
                            action: () => actions(context,transaction),
                            textAlign: TextAlign.end,
                            value: formatThousands(
                                transaction.nettoVal.toString()),
                          ),
                          AppTableCell2(
                            action: () => actions(context,transaction),
                            value: transaction.settlePaymentMethod,
                          ),
                          AppTableCell2(
                            action: () => actions(context,transaction),
                            textAlign: TextAlign.end,
                            value: formatThousands(
                                transaction.paymentVal.toString()),
                          ),
                          AppTableCell2(
                            action: () => actions(context,transaction),
                            textAlign: TextAlign.end,
                            value: formatThousands(
                                transaction.totalHutang.toString()),
                          ),
                          AppTableCell2(
                            width: 200,
                            customWidget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                AppIconButton(
                                    onPressed: () {
                                      print("b");
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                    )),
                                AppIconButton(
                                    onPressed: () {
                                      print("b");
                                    },
                                    icon: Icon(Icons.delete)),
                                AppIconButton(
                                    onPressed: () {
                                      var controller =
                                          Get.find<PosController>();
                                      var homeController =
                                          Get.find<HomeController>();
                                      controller
                                          .reinitTransaction(transaction)
                                          .then((_) => homeController
                                              .selectedMenuName.value = "pos");
                                    },
                                    icon: Icon(Icons.open_in_new)),
                                AppIconButton(
                                    onPressed: () {}, icon: Icon(Icons.print))
                              ],
                            ),
                          ),
                        ];
                      }),
                      footer: [
                        AppTableCell2(
                          value: "Total",
                        ),
                        AppTableCell2(
                          customWidget: SizedBox.shrink(),
                        ),
                        AppTableCell2(
                          customWidget: SizedBox.shrink(),
                        ),
                        AppTableCell2(
                          customWidget: SizedBox.shrink(),
                        ),
                        AppTableCell2(
                          customWidget: SizedBox.shrink(),
                        ),
                        AppTableCell2(
                          customWidget: SizedBox.shrink(),
                        ),
                        AppTableCell2(
                          customWidget: SizedBox.shrink(),
                        ),
                        AppTableCell2(
                          customWidget: SizedBox.shrink(),
                        ),
                        AppTableCell2(
                            value: formatThousands(
                                controller.sumNetto.value.toString()),
                            textAlign: TextAlign.right),
                        AppTableCell2(
                          customWidget: SizedBox.shrink(),
                        ),
                        AppTableCell2(
                            value: formatThousands(
                                controller.sumPayment.value.toString()),
                            textAlign: TextAlign.right),
                        AppTableCell2(
                            value: formatThousands(
                                controller.sumDebt.value.toString()),
                            textAlign: TextAlign.right),
                        AppTableCell2(
                          width: 200,
                          customWidget: SizedBox.shrink(),
                        ),
                      ],
                      onRefresh: () => controller.fetchTransactions(),
                      isRefreshing: controller.isLoading.value,
                    ))),
                // Obx(() => Expanded(
                //         child: AppTable(
                //       onSearch: (filterValue) =>
                //           controller.updateFilterValue(filterValue),
                //       onChangePageNo: (pageNo) =>
                //           controller.updatePageNo(pageNo),
                //       onChangePageRow: (pageRow) =>
                //           controller.updatePageRow(pageRow),
                //       pageNo: controller.pageNo.value,
                //       pageRow: controller.pageRow.value,
                //       titles: [
                //         AppTableTitle(value: "Trx"),
                //         AppTableTitle(value: "Tanggal"),
                //         AppTableTitle(value: "Kasir"),
                //         AppTableTitle(value: "Nama"),
                //         AppTableTitle(value: "Antrian"),
                //         AppTableTitle(value: "Status"),
                //         AppTableTitle(value: "Keterangan"),
                //         AppTableTitle(value: "Pemesanan"),
                //         AppTableTitle(value: "Total"),
                //         AppTableTitle(value: "Pembayaran"),
                //         AppTableTitle(value: "Total Bayar"),
                //         AppTableTitle(value: "Hutang"),
                //         AppTableTitle(value: ""),
                //         AppTableTitle(value: ""),
                //         AppTableTitle(value: ""),
                //         AppTableTitle(value: ""),
                //         AppTableTitle(value: ""),
                //         AppTableTitle(value: ""),
                //       ],
                //       data: List.generate(controller.transactionHeader.length,
                //           (int i) {
                //         var transaction = controller.transactionHeader[i];
                //         paidBooking =
                //             transaction.statusCategory == 'PROGRESS' &&
                //                 transaction.statusIdDesc == 'PAID BOOKING';
                //         onWorking = transaction.statusCategory == 'PROGRESS' &&
                //             transaction.statusIdDesc == 'ON WORKING';
                //         onDestination =
                //             transaction.statusCategory == 'PROGRESS' &&
                //                 transaction.statusIdDesc == 'ON DESTINATION';
                //         reschedule = transaction.statusCategory == 'PROGRESS' &&
                //             transaction.statusIdDesc == 'RESCHEDULE';
                //         newOrder = transaction.statusCategory == 'PROGRESS' &&
                //             transaction.statusIdDesc == 'NEW ORDER';
                //         accBooking = transaction.statusCategory == 'PROGRESS' &&
                //             transaction.statusIdDesc == 'ACCEPT BOOKING';
                //         arrivedDestination =
                //             transaction.statusCategory == 'PROGRESS' &&
                //                 transaction.statusIdDesc ==
                //                     'ARRIVED AT DESTINATION';
                //         finish = transaction.statusCategory == 'PROGRESS' &&
                //             transaction.statusIdDesc == 'FINISH';
                //         cancelByStore = transaction.statusCategory ==
                //                 'PROGRESS' &&
                //             transaction.statusIdDesc == 'CANCEL BY STORE (OFF)';
                //         toHome = transaction.bookingType == 'TO HOME';

                //         return [
                //           AppTableCell(
                //             onPOS: () {
                //               var controller = Get.find<PosController>();
                //               var homeController = Get.find<HomeController>();
                //               controller
                //                   .reinitTransaction(transaction)
                //                   .then((value) {
                //                 controller.isOpenTransaksi.value = true;
                //                 homeController.selectedMenuName.value = "pos";
                //               });
                //             },
                //             value: transaction.salesId
                //                 .substring(transaction.salesId.length - 4),
                //             index: i,
                //             onEdit: () {
                //               showDialog(
                //                 context: context,
                //                 barrierDismissible: false,
                //                 builder: (context) => const Center(
                //                   child: CircularProgressIndicator(color: AppColor.primaryColor),
                //                 ),
                //               );

                //               _trxRepository
                //                   .getTransactionDetail(
                //                       transactionId: transaction.salesId)
                //                   .then((detail) async {
                //                 Navigator.of(context)
                //                     .pop(); // Tutup progress indicator
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                     builder: (context) => UbahTerapis(
                //                       trxDetail: detail,
                //                     ),
                //                   ),
                //                   (route) => false,
                //                 );
                //               }).catchError((error) {
                //                 Navigator.of(context)
                //                     .pop(); // Tutup progress indicator jika ada error
                //                 ScaffoldMessenger.of(context).showSnackBar(
                //                   SnackBar(
                //                       content:
                //                           Text('Terjadi kesalahan: $error')),
                //                 );
                //               });
                //             },
                //             isModalCheckout: newOrder || finish,
                //             isModalPrint: cancelByStore,
                //             isModalRejectReschedule: reschedule,
                //             isModalAccReschedule:
                //                 reschedule || toHome && accBooking,
                //             isModalStatusOnline: paidBooking,
                //             isModalOnFinishStore: finish,
                //             isModalOnWorkingStore: accBooking,
                //             isModalCancelTrx: cancelByStore,
                //             isModalOnDestination: onDestination,
                //             isModalOnArrived: arrivedDestination,
                //             isTrxMenu: true,
                //             onCheckout: () {},
                //             onPrint: () {},
                //             onRejectReschedule: () {
                //               Navigator.of(context).pushAndRemoveUntil(
                //                 MaterialPageRoute(
                //                     builder: (context) => TrxFormScreen(
                //                           actionId: 'RESCHEDULE_REJECTED',
                //                           salesId: transaction.salesId,
                //                         )),
                //                 (route) => false,
                //               );
                //             },
                //             onAccReschedule: () {
                //               Navigator.of(context).pushAndRemoveUntil(
                //                 MaterialPageRoute(
                //                     builder: (context) => TrxFormScreen(
                //                           actionId: 'RESCHEDULE_APPROVED',
                //                           salesId: transaction.salesId,
                //                         )),
                //                 (route) => false,
                //               );
                //             },
                //             onStatusOnline: () => handleOnTrx(
                //               actionId: 'ONWORKING',
                //               salesId: transaction.salesId,
                //             ),
                //             onFinishStore: () => handleOnTrx(
                //               actionId: 'ONFINISH_STORE',
                //               salesId: transaction.salesId,
                //             ),
                //             onWorkingStore: () => handleOnTrx(
                //               actionId: 'ONWORKING',
                //               salesId: transaction.salesId,
                //             ),
                //             onCancelTrx: () {},
                //             onDestination: () {
                //               Navigator.of(context).pushAndRemoveUntil(
                //                 MaterialPageRoute(
                //                     builder: (context) => TrxFormScreen(
                //                           actionId: 'ONDESTINATION',
                //                           salesId: transaction.salesId,
                //                         )),
                //                 (route) => false,
                //               );
                //             },
                //             onArrived: () {
                //               Navigator.of(context).pushAndRemoveUntil(
                //                 MaterialPageRoute(
                //                     builder: (context) => TrxFormScreen(
                //                           actionId: 'ONARRIVED',
                //                           salesId: transaction.salesId,
                //                         )),
                //                 (route) => false,
                //               );
                //             },
                //             showOptionsOnTap: true,
                //             isOpenPOS: true,
                //           ),
                //           AppTableCell(
                //               onPOS: () {
                //                 var controller = Get.find<PosController>();
                //                 controller.reinitTransaction(transaction);
                //               },
                //               value: transaction.salesDate.split("T")[0],
                //               index: i,
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isModalCheckout: newOrder || finish,
                //               isModalPrint: cancelByStore,
                //               isModalRejectReschedule: reschedule,
                //               isModalAccReschedule:
                //                   reschedule || toHome && accBooking,
                //               isModalStatusOnline: paidBooking,
                //               isModalOnFinishStore: finish,
                //               isModalOnWorkingStore: accBooking,
                //               isModalCancelTrx: cancelByStore,
                //               isModalOnDestination: onDestination,
                //               isModalOnArrived: arrivedDestination,
                //               isTrxMenu: true,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONCONFIRM',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               isOpenPOS: true,
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               onPOS: () {
                //                 var controller = Get.find<PosController>();
                //                 controller.reinitTransaction(transaction);
                //               },
                //               value: transaction.cashierBy,
                //               isOpenPOS: true,
                //               index: i,
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isModalCheckout: newOrder || finish,
                //               isModalPrint: cancelByStore,
                //               isModalRejectReschedule: reschedule,
                //               isModalAccReschedule:
                //                   reschedule || toHome && accBooking,
                //               isModalStatusOnline: paidBooking,
                //               isModalOnFinishStore: finish,
                //               isModalOnWorkingStore: accBooking,
                //               isModalCancelTrx: cancelByStore,
                //               isModalOnDestination: onDestination,
                //               isModalOnArrived: arrivedDestination,
                //               isTrxMenu: true,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               isOpenPOS: true,
                //               onPOS: () {
                //                 var controller = Get.find<PosController>();
                //                 controller.reinitTransaction(transaction);
                //               },
                //               value: transaction.supplierName,
                //               index: i,
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isModalCheckout: newOrder || finish,
                //               isModalPrint: cancelByStore,
                //               isModalRejectReschedule: reschedule,
                //               isModalAccReschedule:
                //                   reschedule || toHome && accBooking,
                //               isModalStatusOnline: paidBooking,
                //               isModalOnFinishStore: finish,
                //               isModalOnWorkingStore: accBooking,
                //               isModalCancelTrx: cancelByStore,
                //               isModalOnDestination: onDestination,
                //               isModalOnArrived: arrivedDestination,
                //               isTrxMenu: true,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               isOpenPOS: true,
                //               onPOS: () {
                //                 var controller = Get.find<PosController>();
                //                 controller.reinitTransaction(transaction);
                //               },
                //               value: transaction.queueNumber.toString(),
                //               index: i,
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isModalCheckout: newOrder || finish,
                //               isModalPrint: cancelByStore,
                //               isModalRejectReschedule: reschedule,
                //               isModalAccReschedule:
                //                   reschedule || toHome && accBooking,
                //               isModalStatusOnline: paidBooking,
                //               isModalOnFinishStore: finish,
                //               isModalOnWorkingStore: accBooking,
                //               isModalCancelTrx: cancelByStore,
                //               isModalOnDestination: onDestination,
                //               isModalOnArrived: arrivedDestination,
                //               isTrxMenu: true,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               isOpenPOS: true,
                //               onPOS: () {
                //                 var controller = Get.find<PosController>();
                //                 controller.reinitTransaction(transaction);
                //               },
                //               value: transaction.sourceId,
                //               index: i,
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isModalCheckout: newOrder || finish,
                //               isModalPrint: cancelByStore,
                //               isModalRejectReschedule: reschedule,
                //               isModalAccReschedule:
                //                   reschedule || toHome && accBooking,
                //               isModalStatusOnline: paidBooking,
                //               isModalOnFinishStore: finish,
                //               isModalOnWorkingStore: accBooking,
                //               isModalCancelTrx: cancelByStore,
                //               isModalOnDestination: onDestination,
                //               isModalOnArrived: arrivedDestination,
                //               isTrxMenu: true,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               isOpenPOS: true,
                //               onPOS: () {
                //                 var controller = Get.find<PosController>();
                //                 controller.reinitTransaction(transaction);
                //               },
                //               value: transaction.statusDesc,
                //               index: i,
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isModalCheckout: newOrder || finish,
                //               isModalPrint: cancelByStore,
                //               isModalRejectReschedule: reschedule,
                //               isModalAccReschedule:
                //                   reschedule || toHome && accBooking,
                //               isModalStatusOnline: paidBooking,
                //               isModalOnFinishStore: finish,
                //               isModalOnWorkingStore: accBooking,
                //               isModalCancelTrx: cancelByStore,
                //               isModalOnDestination: onDestination,
                //               isModalOnArrived: arrivedDestination,
                //               isTrxMenu: true,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               isOpenPOS: true,
                //               onPOS: () {
                //                 var controller = Get.find<PosController>();
                //                 controller.reinitTransaction(transaction);
                //               },
                //               value: transaction.bookingType,
                //               index: i,
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isModalCheckout: newOrder || finish,
                //               isModalPrint: cancelByStore,
                //               isModalRejectReschedule: reschedule,
                //               isModalAccReschedule:
                //                   reschedule || toHome && accBooking,
                //               isModalStatusOnline: paidBooking,
                //               isModalOnFinishStore: finish,
                //               isModalOnWorkingStore: accBooking,
                //               isModalCancelTrx: cancelByStore,
                //               isModalOnDestination: onDestination,
                //               isModalOnArrived: arrivedDestination,
                //               isTrxMenu: true,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               isOpenPOS: true,
                //               onPOS: () {
                //                 var controller = Get.find<PosController>();
                //                 controller.reinitTransaction(transaction);
                //               },
                //               value: transaction.nettoVal.toString(),
                //               index: i,
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isModalCheckout: newOrder || finish,
                //               isModalPrint: cancelByStore,
                //               isModalRejectReschedule: reschedule,
                //               isModalAccReschedule:
                //                   reschedule || toHome && accBooking,
                //               isModalStatusOnline: paidBooking,
                //               isModalOnFinishStore: finish,
                //               isModalOnWorkingStore: accBooking,
                //               isModalCancelTrx: cancelByStore,
                //               isModalOnDestination: onDestination,
                //               isModalOnArrived: arrivedDestination,
                //               isTrxMenu: true,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               isOpenPOS: true,
                //               onPOS: () {
                //                 var controller = Get.find<PosController>();
                //                 controller.reinitTransaction(transaction);
                //               },
                //               value: transaction.settlePaymentMethod,
                //               index: i,
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isModalCheckout: newOrder || finish,
                //               isModalPrint: cancelByStore,
                //               isModalRejectReschedule: reschedule,
                //               isModalAccReschedule:
                //                   reschedule || toHome && accBooking,
                //               isModalStatusOnline: paidBooking,
                //               isModalOnFinishStore: finish,
                //               isModalOnWorkingStore: accBooking,
                //               isModalCancelTrx: cancelByStore,
                //               isModalOnDestination: onDestination,
                //               isModalOnArrived: arrivedDestination,
                //               isTrxMenu: true,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               isOpenPOS: true,
                //               onPOS: () {
                //                 var controller = Get.find<PosController>();
                //                 controller.reinitTransaction(transaction);
                //               },
                //               value: transaction.paymentVal.toString(),
                //               index: i,
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isModalCheckout: newOrder || finish,
                //               isModalPrint: cancelByStore,
                //               isModalRejectReschedule: reschedule,
                //               isModalAccReschedule:
                //                   reschedule || toHome && accBooking,
                //               isModalStatusOnline: paidBooking,
                //               isModalOnFinishStore: finish,
                //               isModalOnWorkingStore: accBooking,
                //               isModalCancelTrx: cancelByStore,
                //               isModalOnDestination: onDestination,
                //               isModalOnArrived: arrivedDestination,
                //               isTrxMenu: true,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               onPOS: () {
                //                 var controller = Get.find<PosController>();
                //                 controller.reinitTransaction(transaction);
                //               },
                //               isOpenPOS: true,
                //               value: transaction.totalHutang.toString(),
                //               index: i,
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isModalCheckout: newOrder || finish,
                //               isModalPrint: cancelByStore,
                //               isModalRejectReschedule: reschedule,
                //               isModalAccReschedule:
                //                   reschedule || toHome && accBooking,
                //               isModalStatusOnline: paidBooking,
                //               isModalOnFinishStore: finish,
                //               isModalOnWorkingStore: accBooking,
                //               isModalCancelTrx: cancelByStore,
                //               isModalOnDestination: onDestination,
                //               isModalOnArrived: arrivedDestination,
                //               isTrxMenu: true,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               value: "",
                //               index: i,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isStatusOnline: paidBooking,
                //               isOnWorkingStore: accBooking,
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               value: "",
                //               index: i,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isAccReschedule:
                //                   reschedule || toHome && accBooking,
                //               isOnDestination: onDestination,
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               onPOS: () {
                //                 var controller = Get.find<PosController>();
                //                 controller.reinitTransaction(transaction);
                //               },
                //               isOpenPOS: true,
                //               value: "",
                //               index: i,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isAccReschedule:
                //                   reschedule || toHome && accBooking,
                //               isOnArrived: arrivedDestination,
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               value: "",
                //               index: i,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan : $error')),
                //                   );
                //                 });
                //               },
                //               isRejectReschedule: reschedule,
                //               isAccReschedule:
                //                   reschedule || toHome && accBooking,
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               value: "",
                //               index: i,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onRejectReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_REJECTED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onAccReschedule: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'RESCHEDULE_APPROVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onStatusOnline: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onWorkingStore: () => handleOnTrx(
                //                     actionId: 'ONWORKING',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               onDestination: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONDESTINATION',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onArrived: () {
                //                 Navigator.of(context).pushAndRemoveUntil(
                //                   MaterialPageRoute(
                //                       builder: (context) => TrxFormScreen(
                //                             actionId: 'ONARRIVED',
                //                             salesId: transaction.salesId,
                //                           )),
                //                   (route) => false,
                //                 );
                //               },
                //               onEdit: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (context) => const Center(
                //                     child: CircularProgressIndicator(
                //                         color: AppColor.primaryColor),
                //                   ),
                //                 );

                //                 _trxRepository
                //                     .getTransactionDetail(
                //                         transactionId: transaction.salesId)
                //                     .then((detail) async {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator
                //                   Navigator.of(context).pushAndRemoveUntil(
                //                     MaterialPageRoute(
                //                       builder: (context) => UbahTerapis(
                //                         trxDetail: detail,
                //                       ),
                //                     ),
                //                     (route) => false,
                //                   );
                //                 }).catchError((error) {
                //                   Navigator.of(context)
                //                       .pop(); // Tutup progress indicator jika ada error
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                         content:
                //                             Text('Terjadi kesalahan: $error')),
                //                   );
                //                 });
                //               },
                //               isEdit: newOrder || finish,
                //               isCheckout: newOrder || finish,
                //               showOptionsOnTap: true),
                //           AppTableCell(
                //               value: "",
                //               index: i,
                //               onCheckout: () {},
                //               onPrint: () {},
                //               onFinishStore: () => handleOnTrx(
                //                     actionId: 'ONFINISH_STORE',
                //                     salesId: transaction.salesId,
                //                   ),
                //               onCancelTrx: () {},
                //               isOnFinishStore: finish,
                //               isCancelTrx: cancelByStore,
                //               showOptionsOnTap: true),
                //         ];
                //       }),
                //       onRefresh: () => controller.fetchTransactions(),
                //       isRefreshing: controller.isLoading.value,
                //     ))),
                //     Text(controller.sumTrx.value.toString())
              ],
            )));
  }
}
