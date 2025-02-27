import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart' as pf;
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
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;
class AppPDFViewer extends StatefulWidget {
  final String? pdfUrl;
  final pw.Document? pdfDocument;
  
  const AppPDFViewer({Key? key, this.pdfUrl, this.pdfDocument}) : super(key: key);

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
    if(widget.pdfUrl!=null){
      _fetchPdfBytes();
    }
    else if(widget.pdfDocument!=null){
      gene();
    } 
  }

  Future<void> gene()async{
    pdfBytes = await widget.pdfDocument?.save();
    PdfPageImage? pdfPageImage =
    await getImage(); // await _convertPdfToImage();
    if (pdfPageImage != null) {
      imageBytes = pdfPageImage.bytes;
      setState(() {});
    }

  }

  Future<PdfPageImage?> getImage() async {
    final tempDir = await getTemporaryDirectory();
    final pdfFile = File('${tempDir.path}/temp.pdf');
    await pdfFile.writeAsBytes(pdfBytes!);

    final document = await PdfDocument.openFile(pdfFile.path);
    final page = await document.getPage(1);

    print(page.width);
    print(page.height);

    final image = await page.render(
        forPrint: true,
        width: page.width * 2.35,
        height: page.height * 2.35,
        backgroundColor: "#ffffff",
        format: PdfPageImageFormat.png);
    print(image!.width);
    print(image.height);

    return image;
  }

  img.Image cropBottomWhiteSpace(img.Image image) {
    int width = image.width;
    int height = image.height;

    int lastNonWhiteRow = height - 1;

    // Scan from bottom to top to find the first non-white pixel row
    for (int y = height - 1; y >= 0; y--) {
      bool isRowEmpty = true;
      for (int x = 0; x < width; x++) {
        int pixel = image.getPixel(x, y);
        int alpha = img.getAlpha(pixel);
        int red = img.getRed(pixel);
        int green = img.getGreen(pixel);
        int blue = img.getBlue(pixel);

        // Consider a pixel non-white if its color is not close to pure white (255,255,255)
        if (alpha > 0 && (red < 250 || green < 250 || blue < 250)) {
          isRowEmpty = false;
          break;
        }
      }
      if (!isRowEmpty) {
        lastNonWhiteRow = y;
        break;
      }
    }

    // Crop the image to remove white space at the bottom
    return img.copyCrop(image, 0, 0, width, lastNonWhiteRow + 1);
  }

  Future<void> _fetchPdfBytes() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl!));
      if (response.statusCode == 200) {
        pdfBytes = Uint8List.fromList(response.bodyBytes);
        PdfPageImage? pdfPageImage =
            await getImage(); // await _convertPdfToImage();
        if (pdfPageImage != null) {
          imageBytes = pdfPageImage.bytes;
          setState(() {});
        }
      } else {
        _showMessage("Failed to load PDF");
      }
    } catch (e) {
      _showMessage("Error fetching PDF: $e");
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

  void _previewPrinting(BuildContext context, img.Image image) async {
    Uint8List imageBytes = Uint8List.fromList(img.encodePng(image));

    // Show the cropped image in a dialog
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(imageBytes), // Display the cropped image
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
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
      List<int> bytes = [];

      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      img.Image? image = img.decodeImage(imageBytes!);
      if (image != null) {
        img.Image croppedImage = cropBottomWhiteSpace(image);
        bytes += generator.image(croppedImage);
        bytes += generator.cut();
        _previewPrinting(context, croppedImage);
        // final bool result = await PrintBluetoothThermal.writeBytes(bytes);
        // image = null;
        // if (result) {
        //   _showMessage("Print successful.");
        // } else {
        //   _showMessage("Print failed.");
        // }
      }
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
      backgroundColor: AppColor.grey100,
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
      body: !(imageBytes != null)
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
              backgroundColor: AppColor.grey100,
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
