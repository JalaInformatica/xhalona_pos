import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/penjualan/lap_penjualan_controller.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/penjualan/lap_penjualan_viewer_screen.dart';

class LapPenjualanScreen extends StatefulWidget {
  @override
  _ReportFormPageState createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<LapPenjualanScreen> {
  final LapPenjualanController controller = Get.put(LapPenjualanController());
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String? _selectedReportType = 'Lap_Penjualan';
  String _detailOption = '1';
  String _formatOption = 'PDF';
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void handleLapPenjualan() async {
      if (_formKey.currentState!.validate()) {
        controller
            .printLapPenjualan(_selectedReportType, _startDateController.text,
                _endDateController.text, _formatOption, _detailOption)
            .then((url) async {
          if (_formatOption == 'EXCEL') {
            // Jika format EXCEL, unduh file
            await launchUrl(Uri.parse(url));
          } else {
            // Jika format PDF, tampilkan di PDF viewer
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      LapPenjualanViewerScreen(url, _selectedReportType!)),
              (route) => false,
            );
          }
        });
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Lap. Penjualan",
            style: AppTextStyle.textTitleStyle(color: Colors.white),
          ),
          backgroundColor: AppColor.secondaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false); // Jika tidak, gunakan navigator default
            }, // Navigasi kembali ke halaman sebelumnya
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _startDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Tanggal Dari',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () =>
                                _selectDate(context, _startDateController),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal dari tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _endDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Tanggal Sampai',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () =>
                                _selectDate(context, _endDateController),
                          ),
                          errorText: _endDateController.text.isEmpty
                              ? 'Tanggal harus diisi.'
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal Sampai tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Text('Jenis Laporan:',
                          style: AppTextStyle.textTitleStyle()),
                      ListTile(
                        title: Text(
                          'Lap. Penjualan',
                          style: AppTextStyle.textTitleStyle(),
                        ),
                        leading: Radio(
                          value: 'Lap_Penjualan',
                          groupValue: _selectedReportType,
                          onChanged: (value) {
                            setState(() {
                              _selectedReportType = value.toString();
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('Lap. Terapis',
                            style: AppTextStyle.textTitleStyle()),
                        leading: Radio(
                          value: 'Lap_Penjualan_By_Terapis',
                          groupValue: _selectedReportType,
                          onChanged: (value) {
                            setState(() {
                              _selectedReportType = value.toString();
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('Lap. Kasir',
                            style: AppTextStyle.textTitleStyle()),
                        leading: Radio(
                          value: 'Lap_Penjualan_Kasir',
                          groupValue: _selectedReportType,
                          onChanged: (value) {
                            setState(() {
                              _selectedReportType = value.toString();
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Detail Laporan:',
                          style: AppTextStyle.textTitleStyle()),
                      ListTile(
                        title: Text('Detail',
                            style: AppTextStyle.textTitleStyle()),
                        leading: Radio(
                          value: '1',
                          groupValue: _detailOption,
                          onChanged: (value) {
                            setState(() {
                              _detailOption = value.toString();
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title:
                            Text('Rekap', style: AppTextStyle.textTitleStyle()),
                        leading: Radio(
                          value: '0',
                          groupValue: _detailOption,
                          onChanged: (value) {
                            setState(() {
                              _detailOption = value.toString();
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Format:', style: AppTextStyle.textTitleStyle()),
                      ListTile(
                        title:
                            Text('PDF', style: AppTextStyle.textTitleStyle()),
                        leading: Radio(
                          value: 'PDF',
                          groupValue: _formatOption,
                          onChanged: (value) {
                            setState(() {
                              _formatOption = value.toString();
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title:
                            Text('EXCEL', style: AppTextStyle.textTitleStyle()),
                        leading: Radio(
                          value: 'EXCEL',
                          groupValue: _formatOption,
                          onChanged: (value) {
                            setState(() {
                              _formatOption = value.toString();
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 24),
                      Center(
                          child: masterButton(
                              handleLapPenjualan, "Cetak", Icons.print)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget masterButton(VoidCallback onPressed, String label, IconData icon) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.secondaryColor, // Background color
          borderRadius: BorderRadius.circular(8), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(label,
                style: AppTextStyle.textTitleStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
