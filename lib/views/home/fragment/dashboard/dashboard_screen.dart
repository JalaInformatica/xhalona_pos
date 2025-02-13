import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:shimmer/shimmer.dart'; // Tambahkan package shimmer
import 'package:xhalona_pos/views/home/fragment/dashboard/summary_controller.dart';
import 'package:xhalona_pos/views/home/fragment/transaction/transaction_controller.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    controller.fetchProducts();

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                        formatToRupiah(int.parse(controller.total.value)),
                        Colors.green))),
                Obx(()=> Expanded(
                    child: _buildSummaryCard('Transaksi',
                        controller.total.value.toString(), Colors.blue))),
              ],
            ),
            SizedBox(height: 5.h,),
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
                        formatToRupiah(int.parse(controller.total.value)),
                        Colors.green))),
                Obx(()=> Expanded(
                    child: _buildSummaryCard('Transaksi',
                        controller.total.value.toString(), Colors.blue))),
              ],
            ),
          ],
        ),
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
