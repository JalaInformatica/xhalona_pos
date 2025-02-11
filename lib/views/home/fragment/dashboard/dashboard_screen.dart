import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:shimmer/shimmer.dart'; // Tambahkan package shimmer
import 'package:xhalona_pos/views/home/fragment/dashboard/summary_controller.dart';
import 'package:xhalona_pos/views/home/fragment/transaction/transaction_controller.dart';

class DashboardScreen extends StatelessWidget {
  final SummaryController controller = Get.put(SummaryController());
  final TransactionController controllerTrx = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    controller.fetchProducts();
    controllerTrx.fetchTransactions();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Hari Ini',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Obx(() {
              if (controller.isLoading.value || controllerTrx.isLoading.value) {
                return _buildShimmerLoading(); // Tampilkan shimmer saat loading
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryCard(
                        'Pendapatan',
                        formatCurrency(controllerTrx.sumTrx.value),
                        Colors.green),
                    _buildSummaryCard('Transaksi',
                        controller.total.value.toString(), Colors.blue),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  // Widget untuk efek shimmer loading
  Widget _buildShimmerLoading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _shimmerCard(),
        _shimmerCard(),
      ],
    );
  }

  // Widget Shimmer Card
  Widget _shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: 150,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 16, width: 100, color: Colors.white), // Title
              SizedBox(height: 5),
              Container(height: 18, width: 80, color: Colors.white), // Value
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 150,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color.withOpacity(0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
