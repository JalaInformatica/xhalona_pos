import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:pdfx/pdfx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:open_filex/open_filex.dart';
import 'package:file_picker/file_picker.dart';

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

  Future<void> _savePdfToDevice() async {
    if (pdfBytes == null) {
    _showMessage("PDF is not loaded yet.");
    return;
  }

  try {
    // Let user select a directory
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    
    if (selectedDirectory == null) {
      _showMessage("No directory selected.");
      return;
    }

    // Define the file path
    final filePath = '$selectedDirectory/downloaded.pdf';
    final file = File(filePath);

    // Save the file
    await file.writeAsBytes(pdfBytes!);
    
    _showMessage("PDF saved successfully at: $filePath");
  } catch (e) {
    _showMessage("Error saving PDF: $e");
  }
  }

  // Print the converted image
  Future<void> _print() async {
    final device = await FlutterBluetoothPrinter.selectDevice(context);
    if (device != null && imageBytes != null) {
      bool success = await FlutterBluetoothPrinter.printImageSingle(
        address: device.address,
        imageWidth: pageWidth,
        imageHeight: pageHeight,
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

  Future<void> _openPdfExternally() async {
    if (pdfBytes != null) {
      try {
        final tempDir = await getTemporaryDirectory();
        final pdfFile = File('${tempDir.path}/temp.pdf');
        await pdfFile.writeAsBytes(pdfBytes!);

        // Open the PDF with an external app
        await OpenFilex.open(pdfFile.path);
      } catch (e) {
        _showMessage("Error opening PDF: $e");
      }
    } else {
      _showMessage("PDF not loaded yet");
    }
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
          IconButton(
            icon: Icon(Icons.open_in_new),
            onPressed: _openPdfExternally,
            tooltip: "Open with External PDF Viewer",
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _savePdfToDevice,
            tooltip: "Save PDF",
          ),
        ],
      ),
      body: pdfBytes == null
          ? Center(
              child: AppDialog(
                shadowColor: AppColor.blackColor,
                content: Column(
                  spacing: 10.h, 
                  children: [
                    Text(
                      "Tunggu Sebentar",
                      style: AppTextStyle.textSubtitleStyle(
                          color: AppColor.primaryColor),
                    ),
                    CircularProgressIndicator(
                      color: AppColor.primaryColor,
                    )
                  ]
                )
              )
            )
          : PDFView(
              pdfData: pdfBytes,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: true,
              onError: (error) => _showMessage("Error: $error"),
            ),
    );
  }
}
