import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';

class LapFinanceScreen extends StatefulWidget {
  @override
  _ReportFormPageState createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<LapFinanceScreen> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String? _selectedReportType;
  String _detailOption = 'Detail';
  String _formatOption = 'PDF';

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
    final double screenWidth = MediaQuery.of(context).size.width;

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
            "Lap. Finance",
            style: TextStyle(color: Colors.white),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
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
                    ),
                    SizedBox(height: 16),
                    TextField(
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
                    ),
                    SizedBox(height: 16),
                    Text('Jenis Laporan:'),
                    ListTile(
                      title: Text('Lap. Finance'),
                      leading: Radio(
                        value: 'Lap. Finance',
                        groupValue: _selectedReportType,
                        onChanged: (value) {
                          setState(() {
                            _selectedReportType = value.toString();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('Lap. Piutang Customer'),
                      leading: Radio(
                        value: 'Lap. Piutang Customer',
                        groupValue: _selectedReportType,
                        onChanged: (value) {
                          setState(() {
                            _selectedReportType = value.toString();
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Detail Laporan:'),
                    ListTile(
                      title: Text('Detail'),
                      leading: Radio(
                        value: 'Detail',
                        groupValue: _detailOption,
                        onChanged: (value) {
                          setState(() {
                            _detailOption = value.toString();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('Rekap'),
                      leading: Radio(
                        value: 'Rekap',
                        groupValue: _detailOption,
                        onChanged: (value) {
                          setState(() {
                            _detailOption = value.toString();
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Format:'),
                    ListTile(
                      title: Text('PDF'),
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
                      title: Text('EXCEL'),
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
                    Center(child: masterButton(() {}, "Cetak", Icons.print)),
                  ],
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
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
