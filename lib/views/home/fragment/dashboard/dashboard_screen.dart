import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/views/home/fragment/dashboard/summary_controller.dart';

class DashboardScreen extends StatelessWidget {
  final SummaryController controller = Get.put(SummaryController());
  @override
  Widget build(BuildContext context) {
    controller.fetchProducts();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryCard('Pendapatan', 'Rp 2.000.000', Colors.green),
                _buildSummaryCard(
                    'Transaksi', controller.total.value, Colors.blue),
              ],
            ),
          ],
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
