import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/penjualan/lap_penjualan_screen.dart';

class LapPenjualanViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String label;

  const LapPenjualanViewerScreen(this.pdfUrl, this.label, {Key? key})
      : super(key: key);

  @override
  _LapPenjualanViewerScreenState createState() =>
      _LapPenjualanViewerScreenState();
}

class _LapPenjualanViewerScreenState extends State<LapPenjualanViewerScreen> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    downloadPDF();
  }

  Future<void> downloadPDF() async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/lap_penjualan.pdf");

      final response = await Dio().download(
        widget.pdfUrl,
        file.path,
        options: Options(
          receiveTimeout:
              const Duration(seconds: 10), // Timeout untuk menerima data
          validateStatus: (status) {
            return status! < 500; // Jangan lempar exception jika status < 500
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          localFilePath = file.path;
        });
      } else {
        print(
            "Gagal mengunduh PDF. Status Code: ${response.statusCode} ${widget.pdfUrl}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Gagal mengunduh PDF. Status Code: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Error saat mengunduh PDF: $e ${widget.pdfUrl}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan saat mengunduh PDF")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LapPenjualanScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(title: Text("${widget.label} Viewer")),
        body: localFilePath == null
            ? const Center(child: CircularProgressIndicator())
            : PDFView(
                filePath: localFilePath!,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: true,
                pageFling: true,
              ),
      ),
    );
  }
}
