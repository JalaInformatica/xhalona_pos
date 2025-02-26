import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:shimmer/shimmer.dart'; // Tambahkan package shimmer
import 'package:xhalona_pos/views/home/fragment/dashboard/dashboard_controller.dart';
import 'package:xhalona_pos/widgets/app_calendar_range.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    controller.fetchData();
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ringkasan Hari Ini',
                style: AppTextStyle.textSubtitleStyle(),
              ),
              Row(
                spacing: 5.w,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Expanded(
                      child: _buildSummaryCard(
                          'Pendapatan Bersih',
                          formatToRupiah(controller.nettoValDToday.value),
                          Colors.green))),
                  Obx(() => Expanded(
                      child: _buildSummaryCard(
                          'Transaksi',
                          controller.totalTrxToday.value.toString(),
                          Colors.blue))),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                'Ringkasan Bulan Ini',
                style: AppTextStyle.textSubtitleStyle(),
              ),
              Row(
                spacing: 5.w,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Expanded(
                      child: _buildSummaryCard(
                          'Pendapatan Bersih',
                          formatToRupiah(controller.nettoValDThisMonth.value),
                          Colors.green))),
                  Obx(() => Expanded(
                      child: _buildSummaryCard(
                          'Transaksi',
                          controller.totalTrxThisMonth.value.toString(),
                          Colors.blue))),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 15.h,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Netto',
                        style: AppTextStyle.textBodyStyle(),
                      ),
                      AppTextButton(
                      onPressed: () {
                        SmartDialog.show(builder: (context) {
                          return AppDialog(
                              content: SizedBox(
                                  width: 100,
                                  height: MediaQuery.of(context).size.height*0.5,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Obx(()=> AppCalendarRange(
                                        rangeStart: controller.nettoPerDayStartDate.value,
                                        rangeEnd: controller.nettoPerDayEndDate.value,
                                        focusedDay: DateTime.now(),
                                        onRangeSelected: (DateTime? start, DateTime? end) {
                                          controller.nettoPerDayStartDate.value = start;
                                          controller.nettoPerDayEndDate.value = end;
                                        },
                                      )),
                                    ])));
                        });
                      },
                      child: Text("dd/mm/yyyy"))
                  ],),
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
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 50,
                                    getTitlesWidget: (value, meta) => Text(
                                      formatToRupiah(value.toInt()),
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.textCaptionStyle(),
                                    ),
                                    maxIncluded: false,
                                    minIncluded: false,
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(controller
                                          .dataPerMonthLabel[value.toInt()]
                                          .toString());
                                    },
                                    interval: 1,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  bottom: BorderSide(),
                                  left: BorderSide(),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: controller.dataNetPerMonthValue,
                                  color: const Color(0xFF4BC0C0),
                                  barWidth: 4,
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox.shrink()),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 15.h,
                children: [
                  Text(
                    'Transaksi Bulan Ini',
                    style: AppTextStyle.textBodyStyle(),
                  ),
                  Obx(() => controller.dataTrxPerMonthValue.isNotEmpty
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
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 50,
                                    getTitlesWidget: (value, meta) => Text(
                                      value.toString(),
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.textCaptionStyle(),
                                    ),
                                    maxIncluded: false,
                                    minIncluded: false,
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(controller
                                          .dataPerMonthLabel[value.toInt()]
                                          .toString());
                                    },
                                    interval: 1,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  bottom: BorderSide(),
                                  left: BorderSide(),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: controller.dataTrxPerMonthValue,
                                  color: const Color(0xFF4BC0C0),
                                  barWidth: 4,
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox.shrink())
                ],
              ),

              // TERAPIS
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 15.h,
                children: [
                  Text(
                    'Netto Per Terapis (Bulan)',
                    style: AppTextStyle.textBodyStyle(),
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
                                    showTitles: true,
                                    reservedSize: 50,
                                    getTitlesWidget: (value, meta) => Text(
                                      formatToRupiah(value.toInt()),
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.textCaptionStyle(),
                                    ),
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
                                  bottom: BorderSide(),
                                  left: BorderSide(),
                                ),
                              ),
                              barGroups:
                                  controller.dataNetPerTerapisValue.map((data) {
                                return BarChartGroupData(
                                  x: data.x.toInt(),
                                  barRods: [
                                    BarChartRodData(
                                      toY: data.y,
                                      color: const Color(0xFF4BC0C0),
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
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 15.h,
                children: [
                  Text(
                    'Transaksi Per Terapis (Bulan)',
                    style: AppTextStyle.textBodyStyle(),
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
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 50,
                                    getTitlesWidget: (value, meta) => Text(
                                      value.toInt().toString(),
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.textCaptionStyle(),
                                    ),
                                  ),
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
                                  bottom: BorderSide(),
                                  left: BorderSide(),
                                ),
                              ),
                              barGroups:
                                  controller.dataTrxPerTerapisValue.map((data) {
                                return BarChartGroupData(
                                  x: data.x.toInt(),
                                  barRods: [
                                    BarChartRodData(
                                      toY: data.y,
                                      color: const Color(0xFF4BC0C0),
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
              ),

              //PRODUK
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 15.h,
                children: [
                  Text(
                    'Netto Per Produk (Bulan)',
                    style: AppTextStyle.textBodyStyle(),
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
                                    showTitles: true,
                                    reservedSize: 50,
                                    getTitlesWidget: (value, meta) => Text(
                                      formatToRupiah(value.toInt()),
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.textCaptionStyle(),
                                    ),
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Text(
                                          controller.dataNetPerProdukLabel[
                                                  value.toInt()]
                                              .toString(),
                                          style:
                                              AppTextStyle.textCaptionStyle(),
                                        ),
                                      );
                                    },
                                    interval: 1,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  bottom: BorderSide(),
                                  left: BorderSide(),
                                ),
                              ),
                              barGroups:
                                  controller.dataNetPerProdukValue.map((data) {
                                return BarChartGroupData(
                                  x: data.x.toInt(),
                                  barRods: [
                                    BarChartRodData(
                                      toY: data.y,
                                      color: const Color(0xFF4BC0C0),
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
              ),
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

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                blurRadius: 1, offset: Offset(0, 1), color: AppColor.grey500)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.textBodyStyle(),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: AppTextStyle.textSubtitleStyle(),
          ),
        ],
      ),
    );
  }
}
