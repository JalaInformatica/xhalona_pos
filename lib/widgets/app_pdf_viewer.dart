import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:pdfx/pdfx.dart'; 
import 'package:path_provider/path_provider.dart'; 

class AppPDFViewer extends StatefulWidget {
  final String pdfUrl;

  const AppPDFViewer({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _AppPDFViewerState createState() => _AppPDFViewerState();
}

class _AppPDFViewerState extends State<AppPDFViewer> {
  Uint8List? pdfBytes;
  Uint8List? imageBytes; // Store extracted image
  late int pageWidth; // Extracted width
  late int pageHeight; // Extracted height

  @override
  void initState() {
    super.initState();
    _fetchPdfBytes();
  }

  Future<void> _fetchPdfBytes() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      if (response.statusCode == 200) {
        pdfBytes = Uint8List.fromList(response.bodyBytes);
        await _convertPdfToImage();
        setState(() {});
      } else {
        _showMessage("Failed to load PDF");
      }
    } catch (e) {
      _showMessage("Error fetching PDF: $e");
    }
  }

  // Convert PDF to Image with Dynamic Page Size
  // Convert PDF to Image with Dynamic Page Size
  Future<void> _convertPdfToImage() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final pdfFile = File('${tempDir.path}/temp.pdf');
      await pdfFile.writeAsBytes(pdfBytes!);

      final document = await PdfDocument.openFile(pdfFile.path);
      final page = await document.getPage(1); // Get the first page

      // ✅ Get actual page dimensions
      pageWidth = page.width.toInt();
      pageHeight = page.height.toInt();

      final pageImage = await page.render(
        width: pageWidth.toDouble(), // Use extracted width
        height: pageHeight.toDouble(), // Use extracted height
        format: PdfPageImageFormat.png,
      );

      if (pageImage != null) {
        setState(() {
          imageBytes = pageImage.bytes; // Store converted image
        });
      }

      await page.close();
      await document.close();
    } catch (e) {
      _showMessage("Error converting PDF to image: $e");
    }
  }

  // Print the converted image
  Future<void> _print() async {
    final device = await FlutterBluetoothPrinter.selectDevice(context);
    if (device != null && imageBytes != null) {
      bool success = await FlutterBluetoothPrinter.printImageSingle(
        address: device.address,
        imageWidth: pageWidth!, // Use extracted width
        imageHeight: pageHeight!, // Use extracted height
        imageBytes: imageBytes!,
        keepConnected: true,
      );

      if (success) {
        _showMessage("Printing started...");
      } else {
        _showMessage("Failed to start printing");
      }
    } else {
      _showMessage("No image data to print");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: _print,
            tooltip: "Print to Bluetooth Thermal Printer",
          ),
        ],
      ),
      body: imageBytes == null
          ? Center(child: CircularProgressIndicator())
          : Image.memory(imageBytes!),
    );
  }
}
