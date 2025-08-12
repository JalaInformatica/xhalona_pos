import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xhalona_pos/core/helper/date_helper.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:shimmer/shimmer.dart'; // Tambahkan package shimmer
import 'package:xhalona_pos/views/home/fragment/dashboard/dashboard_controller.dart';
import 'package:xhalona_pos/widgets/app_calendar_range.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_dropdown.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_table_xs.dart';

import 'viewmodels/dashboard_viewmodel.dart';

class DashboardScreen extends HookConsumerWidget {
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardViewModelProvider);
    final notifier = ref.read(dashboardViewModelProvider.notifier);

    controller.fetchData();
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Transaksi Terbaru Hari ini (Top 5)", style: AppTextStyle.textBodyStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height*0.25
                ),
                child: AppTableXs(
                isPaginated: false,
                tableSize: TableSize.small,
                isLoading: state.isLoadingTodayTransaction,
                columnDefs: [
                  ColumnDef(
                    field: 'trx', 
                    headerName: 'Trx', 
                    width: 60,
                    textFormatter: (val)=>val.toString().substring(val.toString().length-4)
                  ),
                  ColumnDef(
                    field: 'pelanggan', 
                    headerName: 'Pelanggan', 
                    width: 100, 
                    alignment: ColumAlignment.left
                  ),
                  ColumnDef(field: 'settle_payment_method', headerName: 'Pembayaran', width: 110),
                  ColumnDef(
                    field: 'payment_val', 
                    headerName: 'Total Bayar', 
                    width: 100,
                    alignment: ColumAlignment.right,
                    textFormatter: (val)=>formatThousands(val.toString())
                  ),
                  ColumnDef(field: 'queue', headerName: 'Antrian', width: 90),
                  ColumnDef(field: 'create_by', headerName: 'Kasir', width: 90),
                  ColumnDef(field: 'status', headerName: 'Status', width: 90),
                  ColumnDef(field: 'keterangan', headerName: 'Keterangan', width: 90),
                  ColumnDef(
                    field: 'total', 
                    headerName: 'Total', 
                    width: 90, 
                    alignment: ColumAlignment.right,
                    textFormatter: (val)=>formatThousands(val.toString())
                  ),
                ],
                onRowClicked: (transaction){
                  // AppNavigator.navigatePush(context, TransactionPosScreen(salesId: transaction['trx']));
                },
                rowData: state.todayTransaction.map((item){
                  return 
                    {
                      'trx': item.salesId,
                      'pelanggan': item.supplierName,
                      'settle_payment_method': item.settlePaymentMethod,
                      'payment_val': item.paymentVal,
                      'queue': item.queueNumber,
                      'create_by': item.createBy,
                      'status': item.sourceId,
                      'keterangan': item.statusDesc,
                      'total': item.nettoVal,
                      'aksi': '',
                    };
                  }).toList(),
                  footerDefs: [
                    FooterDef(
                      field: 'trx',
                      value: 'Total', 
                    ),
                    FooterDef(
                      field: 'payment_val',
                      value: formatThousands(state.todayTransaction.fold(0, (sum, c)=>sum+c.paymentVal).toString()),
                      columAlignment: ColumAlignment.right
                    ),
                    FooterDef(
                      field: 'total',
                      value: formatThousands(state.todayTransaction.fold(0, (sum, c)=>sum+c.nettoVal).toString()),
                    ),]
              ),
              ),
              Row(
                spacing: 5.w,
                children: [
                  Expanded(child: _buildSummaryCard(
                    color: AppColor.primaryColor,
                    child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hari ini", style: AppTextStyle.textBodyStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.whiteColor),),
                        Text(formatToRupiahShort(controller.nettoValDToday.value), style: AppTextStyle.textSubtitleStyle(
                          color: AppColor.whiteColor
                        ),),
                        Text(
                          "${controller.totalTrxToday.value.toString()} Transaksi",
                          style: AppTextStyle.textBodyStyle(color: AppColor.whiteColor),
                        ),
                      ],
                    ),
                  ))),
                  Expanded(child: _buildSummaryCard(
                    child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.dashboardType == DashboardType.MONTHLY?
                          "Bulan ${DateHelper.listMonthIDN()[controller.filterMonth.value-1]} ${controller.filterYear.value}":
                          "Tahun ${controller.filterYear.value}"
                          , style: AppTextStyle.textBodyStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor),),
                        Text(formatToRupiahShort(controller.nettoValDThisMonth.value), style: AppTextStyle.textSubtitleStyle(),),
                        Text(
                          "${controller.totalTrxThisMonth.value.toString()} Transaksi",
                          style: AppTextStyle.textBodyStyle(color: AppColor.blackColor),
                        ),
                      ],
                    ),
                  ))),
                ]
              ),
              _buildSummaryCard(child: Row(
                spacing: 5.w,
                children: [
                  Obx(()=> AppTextDropdown<DashboardType>(
                    value: controller.dashboardType.value,
                    items: [
                      DropdownMenuItem<DashboardType>(
                        value: DashboardType.MONTHLY,
                        child: Text("Monthy", style: AppTextStyle.textBodyStyle(),)
                      ),
                      DropdownMenuItem<DashboardType>(
                        value: DashboardType.ANNUAL,
                        child: Text("Annual", style: AppTextStyle.textBodyStyle())
                      ),
                    ], 
                    onChanged: (val){
                      controller.dashboardType.value = val!;
                      controller.fetchData();
                    })
                  ),
                  Obx(()=> Visibility(
                    visible: controller.dashboardType.value == DashboardType.MONTHLY,
                    child: AppTextDropdown<int>(
                    value: controller.filterMonth.value,
                    items: List.generate(12, (index){
                      return DropdownMenuItem<int>(
                        value: index+1,
                        child: Text(DateHelper.listMonthIDN()[index], style: AppTextStyle.textBodyStyle(),)
                      );
                    }), 
                    onChanged: (val){
                      controller.filterMonth.value = val!;
                      controller.fetchData();
                    })
                  )),
                  Obx(()=> AppTextDropdown<int>(
                    value: controller.filterYear.value,
                    items: List.generate(20, (index){
                      int startYear = 2015;
                      return DropdownMenuItem<int>(
                        value: startYear + index,
                        child: Text("${startYear+index}", style: AppTextStyle.textBodyStyle(),)
                      );
                    }), 
                    onChanged: (val){
                      controller.filterYear.value = val!;
                      controller.fetchData();
                    })
                  ),
                ],
              )),
              // AppTextButton(
              //   onPressed: () {
              //     SmartDialog.show(builder: (context) {
              //       return AppDialog(
              //         content: SizedBox(
              //           width: 100,
              //           height: MediaQuery.of(context).size.height*0.5,
              //           child: Column(
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
                            
              //             ])));
              //     });
              //   },
              // child: Obx(()=> Text("${formatToDDMMYYYY(controller.nettoPerDayStartDate.value)} To ${formatToDDMMYYYY(controller.nettoPerDayEndDate.value)}"))),
              _buildSummaryCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 15.h,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                        'Penjualan (Rp)',
                        style: AppTextStyle.textBodyStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor
                          ),
                        ),
                        
                    ]),                      
                    Obx(() => controller.dataNetPerMonthValue.isNotEmpty
                        ? AspectRatio(
                            aspectRatio: 3,
                            child: LineChart(
                              LineChartData(
                                minY: 0,
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipColor: (_) {
                                      return AppColor.primaryColor;
                                    },
                                    getTooltipItems:
                                        (List<LineBarSpot> touchedSpots) {
                                      return touchedSpots.map((spot) {
                                        return LineTooltipItem(
                                          formatToRupiah(spot.y.toInt()),
                                          AppTextStyle.textBodyStyle(
                                              color: AppColor.whiteColor),
                                        );
                                      }).toList();
                                    },
                                  ),
                                  handleBuiltInTouches: true,
                                ),
                                gridData: FlGridData(show: true),
                                titlesData: FlTitlesData(
                                  rightTitles:
                                      AxisTitles(sideTitles: SideTitles()),
                                  topTitles: AxisTitles(sideTitles: SideTitles()),
                                  leftTitles: AxisTitles(
                                    // sideTitles: SideTitles(
                                    //   showTitles: true,
                                    //   reservedSize: 50,
                                    //   getTitlesWidget: (value, meta) => Text(
                                    //     formatToRupiah(value.toInt()),
                                    //     textAlign: TextAlign.center,
                                    //     style: AppTextStyle.textCaptionStyle(),
                                    //   ),
                                    //   maxIncluded: false,
                                    //   minIncluded: false,
                                    // ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return Text(controller
                                            .dataPerMonthLabel[value.toInt()]
                                            .toString(), style: AppTextStyle.textBodyStyle(),);
                                      },
                                      interval: 1,
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border(
                                    // bottom: BorderSide(),
                                    // left: BorderSide(),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: controller.dataNetPerMonthValue,
                                    color: const Color.fromARGB(255, 38, 208, 109),
                                    barWidth: 4,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox.shrink()),
                  ],
                )
              ),
              // )),

              // TERAPIS
              _buildSummaryCard(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 15.h,
                children: [
                  Text(
                    'Terapis (Rp)',
                    style: AppTextStyle.textBodyStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor
                    ),
                  ),
                  Obx(() => controller.dataTrxPerMonthValue.isNotEmpty
                      ? AspectRatio(
                          aspectRatio: 3,
                          child: BarChart(
                            BarChartData(
                              minY: 0,
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (_) {
                                    return AppColor.primaryColor;
                                  },
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      formatToRupiah(rod.toY.toInt()),
                                      AppTextStyle.textBodyStyle(
                                          color: AppColor.whiteColor),
                                    );
                                  },
                                ),
                                handleBuiltInTouches: true,
                              ),
                              gridData: FlGridData(show: true),
                              titlesData: FlTitlesData(
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    // showTitles: true,
                                    // reservedSize: 50,
                                    // getTitlesWidget: (value, meta) => Text(
                                    //   formatToRupiah(value.toInt()),
                                    //   textAlign: TextAlign.center,
                                    //   style: AppTextStyle.textCaptionStyle(),
                                    // ),
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        controller.dataNetPerTerapisLabel[
                                                value.toInt()]
                                            .toString(),
                                        style: AppTextStyle.textCaptionStyle(),
                                      );
                                    },
                                    interval: 1,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  // bottom: BorderSide(),
                                  // left: BorderSide(),
                                ),
                              ),
                              barGroups:
                                  controller.dataNetPerTerapisValue.map((data) {
                                return BarChartGroupData(
                                  x: data.x.toInt(),
                                  barRods: [
                                    BarChartRodData(
                                      toY: data.y,
                                      color: const Color.fromARGB(255, 75, 98, 192),
                                      width: 15, // Adjust bar width
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ))
                      : SizedBox.shrink())
                ],
              )),
              
              _buildSummaryCard(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 15.h,
                children: [
                  Text(
                    'Terapis (Qty)',
                    style: AppTextStyle.textBodyStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor
                    ),
                  ),
                  Obx(() => controller.dataTrxPerMonthValue.isNotEmpty
                      ? AspectRatio(
                          aspectRatio: 3,
                          child: BarChart(
                            BarChartData(
                              minY: 0,
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (_) {
                                    return AppColor.primaryColor;
                                  },
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      rod.toY.toInt().toString(),
                                      AppTextStyle.textBodyStyle(
                                          color: AppColor.whiteColor),
                                    );
                                  },
                                ),
                                handleBuiltInTouches: true,
                              ),
                              gridData: FlGridData(show: true),
                              titlesData: FlTitlesData(
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        controller.dataTrxPerTerapisLabel[
                                                value.toInt()]
                                            .toString(),
                                        style: AppTextStyle.textCaptionStyle(),
                                      );
                                    },
                                    interval: 1,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  // bottom: BorderSide(),
                                  // left: BorderSide(),
                                ),
                              ),
                              barGroups:
                                  controller.dataTrxPerTerapisValue.map((data) {
                                return BarChartGroupData(
                                  x: data.x.toInt(),
                                  barRods: [
                                    BarChartRodData(
                                      toY: data.y,
                                      color: const Color.fromARGB(255, 191, 9, 201),
                                      width: 15, // Adjust bar width
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ))
                      : SizedBox.shrink())
                ],
              )),

              //PRODUK
              _buildSummaryCard(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 15.h,
                children: [
                  Text(
                    'Produk (Rp)',
                    style: AppTextStyle.textBodyStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor
                    ),
                  ),
                  Obx(() => controller.dataTrxPerMonthValue.isNotEmpty
                      ? Column(
                          spacing: 5.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(controller.dataNetPerProdukValue.length, (index) {
                            final label = controller.dataNetPerProdukLabel[index].toString();
                            final value = controller.dataNetPerProdukValue[index].y;

                            final max = controller.dataNetPerProdukValue
                                .map((e) => e.y)
                                .reduce((a, b) => a > b ? a : b);

                            final barWidth = (value / max) * 200;

                            return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      label,
                                      style: AppTextStyle.textCaptionStyle(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          formatToRupiah(value.toInt()),
                                          style: AppTextStyle.textCaptionStyle(),
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        width: barWidth,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 255, 149, 35),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                            );
                          }),
                        )
                      : SizedBox.shrink()),
                    
                ],
              )),
              _buildSummaryCard(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 15.h,
                children: [
                  Text(
                    'Produk (Qty)',
                    style: AppTextStyle.textBodyStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor
                    ),
                  ),
                  Obx(() => controller.dataTrxPerMonthValue.isNotEmpty
                      ? Column(
                          spacing: 5.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(controller.dataQtyPerProdukValue.length, (index) {
                            final label = controller.dataQtyPerProdukLabel[index].toString();
                            final value = controller.dataQtyPerProdukValue[index].y;

                            final max = controller.dataQtyPerProdukValue
                                .map((e) => e.y)
                                .reduce((a, b) => a > b ? a : b);

                            final barWidth = (value / max) * 200;

                            return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      label,
                                      style: AppTextStyle.textCaptionStyle(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          "$value",
                                          style: AppTextStyle.textCaptionStyle(),
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        width: barWidth,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 255, 35, 145),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                            );
                          }),
                        )                        
                      : SizedBox.shrink()
                    )
                ],
              )),
            ]),
      ),
    );
  }

  // Widget Shimmer Card
  Widget _shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(),
      ),
    );
  }

  Widget _buildSummaryCard({Color? color = AppColor.whiteColor, required Widget child}) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            blurRadius: 1, 
            offset: Offset(0, 1),
            color: AppColor.grey500
          )
        ]
      ),
      child: Obx(()=> !controller.isLoading.value? child : Shimmer.fromColors(
        baseColor: Color.fromARGB(94, 193, 193, 193),
        highlightColor: Colors.grey[100]!,
        child:  Container(
          color: AppColor.whiteColor,
          height: 50.h, 
          width: double.maxFinite,
        ), 
      )
    ));
  }
}
