import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class AppPDFViewer extends StatefulWidget {
  final String pdfUrl;

  const AppPDFViewer({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _AppPDFViewerState createState() => _AppPDFViewerState();
}

class _AppPDFViewerState extends State<AppPDFViewer> {
  
  // final NetworkPrinter printer = NetworkPrinter(PaperSize.mm80, await CapabilityProfile.load());
  bool isConnected = false;
  Uint8List? pdfBytes;

  @override
  void initState() {
    super.initState();
    _fetchPdfBytes();
  }

  Future<void> _fetchPdfBytes() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      if (response.statusCode == 200) {
        setState(() {
          pdfBytes = Uint8List.fromList(response.bodyBytes);
        });
      } else {
        _showMessage("Failed to load PDF");
      }
    } catch (e) {
      _showMessage("Error fetching PDF: $e");
    }
  }

  Future<void> _connectToPrinter(String ipAddress) async {
    // final result = await printer.connect(ipAddress, port: 9100);
    // setState(() {
    //   isConnected = result == PosPrintResult.success;
    // });
  }

  void _printToThermalPrinter(String ipAddress) async {
    if (pdfBytes == null) {
      _showMessage("PDF not loaded yet. Please wait.");
      return;
    }

    try {
      await _connectToPrinter(ipAddress);

      if (!isConnected) {
        _showMessage("Failed to connect to the printer. Check IP address.");
        return;
      }

      // Use printBytes to send the bytes to the printer
      // printer.ytes(pdfBytes!);  // <-- Correct method for printing raw bytes
      // printer.disconnect();

      _showMessage("PDF sent to the thermal printer successfully!");
    } catch (e) {
      _showMessage("Failed to print PDF: $e");
    } finally {
      setState(() {
        isConnected = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<String?> _showPrinterDialog(BuildContext context) async {
    String? ipAddress;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Printer IP Address"),
          content: TextField(
            onChanged: (value) => ipAddress = value,
            decoration: InputDecoration(hintText: "192.168.x.x"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
    return ipAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () async {
              final ipAddress = await _showPrinterDialog(context);
              if (ipAddress != null && ipAddress.isNotEmpty) {
                _printToThermalPrinter(ipAddress);
              }
            },
            tooltip: "Print to Thermal Printer",
          ),
        ],
      ),
      body: pdfBytes == null
          ? Center(child: CircularProgressIndicator())
          : PDFView(
              pdfData: pdfBytes!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: true,
              onError: (error) => _showMessage("Error displaying PDF: $error"),
            ),
    );
  }
}
