import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:xhalona_pos/models/dao/transaction.dart';

class TransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
//   final List<Transaction> transactions = [
//     Transaction(
//       transaksi: 'T001',
//       tanggal: '2025-01-13',
//       kasir: 'Kasir 1',
//       nama: 'John Doe',
//       antrian: 'A001',
//       status: 'Selesai',
//       keterangan: 'Transaksi selesai',
//       pemesanan: 'P001',
//       total: 100000,
//       pembayaran: 120000,
//       totalBayar: 120000,
//       hutang: 0,
//     ),
//     Transaction(
//       transaksi: 'T002',
//       tanggal: '2025-01-12',
//       kasir: 'Kasir 2',
//       nama: 'Jane Doe',
//       antrian: 'A002',
//       status: 'Menunggu',
//       keterangan: 'Menunggu pembayaran',
//       pemesanan: 'P002',
//       total: 150000,
//       pembayaran: 0,
//       totalBayar: 0,
//       hutang: 150000,
//     ),
//     // Add more transactions as needed
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return HorizontalDataTable(
//   leftHandSideColumnWidth: 100, // Set width for the left column
//   rightHandSideColumnWidth: 1200, // Set width for the right columns
//   isFixedHeader: true, // Enable fixed header
//   headerWidgets: [
//     _getTitle('Transaksi'),
//     _getTitle('Tanggal'),
//     _getTitle('Kasir'),
//     _getTitle('Nama'),
//     _getTitle('Antrian'),
//     _getTitle('Status'),
//     _getTitle('Keterangan'),
//     _getTitle('Pemesanan'),
//     _getTitle('Total'),
//     _getTitle('Pembayaran'),
//     _getTitle('Total Bayar'),
//     _getTitle('Hutang'),
//   ],
//   isFixedFooter: true, // Enable fixed footer
//   footerWidgets: [
//     _getTitle('Footer1'),
//     _getTitle('Footer2'),
//     _getTitle('Footer3'),
//   ],
//   leftSideItemBuilder: (context, index) {
//     return Row(
//       children: _getRow(
//         transactions[index].transaksi, // Left column data
//         '', // Empty for right-side columns
//         '', // Empty for right-side columns
//         '', // Empty for right-side columns
//         '', // Empty for right-side columns
//         '', // Empty for right-side columns
//         '', // Empty for right-side columns
//         '', // Empty for right-side columns
//         '', // Empty for right-side columns
//         '', // Empty for right-side columns
//         '', // Empty for right-side columns
//         '', // Empty for right-side columns
//       ),
//     );
//   },
//   rightSideItemBuilder: (context, index) {
//     return Row(
//       children: _getRow(
//         null,
//         transactions[index].tanggal,
//         transactions[index].kasir,
//         transactions[index].nama,
//         transactions[index].antrian,
//         transactions[index].status,
//         transactions[index].keterangan,
//         transactions[index].pemesanan,
//         'Rp ${transactions[index].total.toStringAsFixed(0)}',
//         'Rp ${transactions[index].pembayaran.toStringAsFixed(0)}',
//         'Rp ${transactions[index].totalBayar.toStringAsFixed(0)}',
//         'Rp ${transactions[index].hutang.toStringAsFixed(0)}',
//       ),
//     );
//   },
//   itemCount: transactions.length, // The number of items
// );
// }


//   // Helper function to build a title widget
//   Widget _getTitle(String title) {
//     return Container(
//       width: 100,
//       height: 56,
//       alignment: Alignment.center,
//       color: Colors.grey[200],
//       child: Text(
//         title,
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   // Helper function to build a row widget (returns a list of Widgets)
//   List<Widget> _getRow(
//       String? transaksi,
//       String tanggal,
//       String kasir,
//       String nama,
//       String antrian,
//       String status,
//       String keterangan,
//       String pemesanan,
//       String total,
//       String pembayaran,
//       String totalBayar,
//       String hutang) {
//     return [
//       transaksi!=null?_getCell(transaksi):SizedBox.shrink(),
//       _getCell(tanggal),
//       _getCell(kasir),
//       _getCell(nama),
//       _getCell(antrian),
//       _getCell(status),
//       _getCell(keterangan),
//       _getCell(pemesanan),
//       _getCell(total),
//       _getCell(pembayaran),
//       _getCell(totalBayar),
//       _getCell(hutang),
//     ];
//   }

//   // Helper function to build a cell widget
//   Widget _getCell(String value) {
//     return Container(
//       width: 100,
//       height: 56,
//       alignment: Alignment.center,
//       child: Text(value),
//     );
//   }
}