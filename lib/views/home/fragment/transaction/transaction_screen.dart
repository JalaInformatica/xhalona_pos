import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/fragment/transaction/transaction_controller.dart';

class TransactionScreen extends StatelessWidget {
  final TransactionController controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
          children: [
            Obx(() => 
  controller.isLoading.value 
    ? Center(child: CircularProgressIndicator()) 
    : controller.transactionHeader.isEmpty 
      ? Center(child: Text('No transactions available'))
      : Expanded(child: HorizontalDataTable(
          leftHandSideColumnWidth: 100,
          rightHandSideColumnWidth: 1200,
          isFixedHeader: true,
          headerWidgets: [
            _getTitle('Transaksi'),
            _getTitle('Tanggal'),
            _getTitle('Kasir'),
            _getTitle('Nama'),
            _getTitle('Antrian'),
            _getTitle('Status'),
            _getTitle('Keterangan'),
            _getTitle('Pemesanan'),
            _getTitle('Total'),
            _getTitle('Pembayaran'),
            _getTitle('Total Bayar'),
            _getTitle('Hutang'),
          ],
          leftSideItemBuilder: (context, index) {
            return _getCell(controller.transactionHeader[index].salesId);
          },
          rightSideItemBuilder: (context, index) {
            return Row(
              children: [
                _getCell(controller.transactionHeader[index].salesDate),
                _getCell(controller.transactionHeader[index].cashierBy),
                _getCell(controller.transactionHeader[index].supplierName),
                _getCell(controller.transactionHeader[index].queueNumber.toString()),
                _getCell(controller.transactionHeader[index].statusDesc),
                _getCell(controller.transactionHeader[index].note),
                _getCell(controller.transactionHeader[index].nettoVal.toString()),
              ],
            );
          },
          itemCount: controller.transactionHeader.length,
        )),
)

          ],
        )
      );
}


  // Helper function to build a title widget
  Widget _getTitle(String title) {
    return Container(
      width: 100,
      height: 56,
      alignment: Alignment.center,
      color: Colors.grey[200],
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper function to build a cell widget
  Widget _getCell(String value) {
    return Container(
      width: 100,
      height: 56,
      alignment: Alignment.center,
      child: Text(value),
    );
  }
}