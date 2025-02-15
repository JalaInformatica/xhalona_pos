import 'dart:io';
import 'dart:typed_data';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:image/image.dart' as img;

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

    final pageImage = await page.render(
      width: 1080, // Higher resolution for better quality
      height: (1080 * page.height / page.width).toDouble(), // Maintain aspect ratio
      format: PdfPageImageFormat.png,
    );

    if (pageImage != null) {
      setState(() {
        imageBytes = pageImage.bytes;
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
      final directory =
          await getDownloadsDirectory(); // Automatically get Downloads folder
      final filePath = '${directory!.path}/downloaded.pdf';
      final file = File(filePath);

      await file.writeAsBytes(pdfBytes!);
      _showMessage("PDF saved successfully at: $filePath");
    } catch (e) {
      _showMessage("Error saving PDF: $e");
    }
  }

  // Print the converted image

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    print(message);
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

  void _previewBytes(BuildContext context, List<int> bytes) {
    Uint8List imageData = Uint8List.fromList(bytes);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Print Preview"),
          content: imageData.isNotEmpty
              ? Image.memory(imageData)
              : Text("No image data available"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _print(BuildContext context) async {
    try {
      // bool isBluetoothConnected = await PrintBluetoothThermal.connectionStatus;

      // if (!isBluetoothConnected) {
      //   _showMessage("Scanning for Bluetooth printers...");
      //   await _connectPrinter(context);
      //   isBluetoothConnected = await PrintBluetoothThermal.connectionStatus;

      //   if (!isBluetoothConnected) {
      //     _showMessage("No printer connected.");
      //     return;
      //   }
      // }

      if (imageBytes == null) {
        _showMessage("No image to print.");
        return;
      }

      img.Image? image = img.decodeImage(imageBytes!);
      if (image == null) {
        _showMessage("Error: Decoded image is null.");
        return;
      }

      // ✅ Process Image for Thermal Printing
      img.Image processedImage = img.grayscale(image); // Convert to grayscale
      processedImage = img.copyResize(processedImage, width: 576); // Resize

      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      List<int> bytes = [];

      bytes += generator.image(processedImage);

      // ✅ Debugging
      _showMessage("Printing ${bytes.length} bytes...");

      _previewBytes(context, bytes);

      // final bool result =
      //     await PrintBluetoothThermal.writeBytes(Uint8List.fromList(bytes));

      // if (result) {
      //   _showMessage("Print successful.");
      // } else {
      //   _showMessage("Print failed.");
      // }
    } catch (e) {
      _showMessage("Printing error: $e");
    }
  }

  Future<void> _connectPrinter(BuildContext context) async {
    try {
      List<BluetoothInfo> devices =
          await PrintBluetoothThermal.pairedBluetooths;

      if (devices.isEmpty) {
        _showMessage("No paired Bluetooth devices found.");
        return;
      }

      // Show available devices in a dialog
      BluetoothInfo? selectedDevice = await showDialog<BluetoothInfo>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select a Printer"),
            content: SingleChildScrollView(
              child: Column(
                children: devices.map((device) {
                  return ListTile(
                    title: Text(device.name),
                    subtitle: Text(device.macAdress),
                    onTap: () => Navigator.pop(context, device),
                  );
                }).toList(),
              ),
            ),
          );
        },
      );

      // If user selects a device, connect to it
      if (selectedDevice != null) {
        bool isConnected = await PrintBluetoothThermal.connect(
            macPrinterAddress: selectedDevice.macAdress);

        if (isConnected) {
          _showMessage("Connected to: ${selectedDevice.name}");
        } else {
          _showMessage("Failed to connect to ${selectedDevice.name}");
        }
      }
    } catch (e) {
      _showMessage("Connection error: $e");
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
            onPressed: () => _print(context),
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
                  content: Column(spacing: 10.h, children: [
                    Text(
                      "Tunggu Sebentar",
                      style: AppTextStyle.textSubtitleStyle(
                          color: AppColor.primaryColor),
                    ),
                    CircularProgressIndicator(
                      color: AppColor.primaryColor,
                    )
                  ])))
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
