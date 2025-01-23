import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/karyawan.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/karyawan_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/supplier/supplier_kustomer_controller.dart';

class MonitorScreen extends StatefulWidget {
  @override
  _MonitorScreenState createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  final KaryawanController controllerKar = Get.put(KaryawanController());
  final KustomerController controllerKus = Get.put(KustomerController());
  final ProductController controllerProduct = Get.put(ProductController());

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String? _selectedTherapist;
  String? _selectedCustomer;
  String? _selectedProduct;
  String? _selectedCategory;
  String _reportType = 'Detail';
  String _shift = 'Semua';
  String _salesFormat = 'Harian';

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
        controller.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            "Monitor Penjualan",
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: '20-01-2025',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () =>
                              _selectDate(context, _startDateController),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: _endDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () =>
                              _selectDate(context, _endDateController),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Filter Terapis'),
                items: controllerKar.karyawanHeader
                    .map((therapist) => DropdownMenuItem(
                          value: therapist.fullName,
                          child: Text(therapist.fullName),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTherapist = value;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Filter Customer'),
                items: controllerKus.kustomerHeader
                    .map((customer) => DropdownMenuItem(
                          value: customer.suplierId,
                          child: Text(customer.suplierName),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCustomer = value;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Filter Produk'),
                items: controllerProduct.productHeader
                    .map((product) => DropdownMenuItem(
                          value: product.partId,
                          child: Text(product.partName),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProduct = value;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Filter Kategori'),
                items: ['Kategori 1', 'Kategori 2', 'Kategori 3']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Type'),
                      value: _reportType,
                      items: ['Detail', 'Summary']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _reportType = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Shift'),
                      value: _shift,
                      items: ['Semua', 'Pagi', 'Siang', 'Malam']
                          .map((shift) => DropdownMenuItem(
                                value: shift,
                                child: Text(shift),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _shift = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Format Penjualan By:'),
              Column(
                children: [
                  RadioListTile(
                    title: Text('Harian'),
                    value: 'Harian',
                    groupValue: _salesFormat,
                    onChanged: (value) {
                      setState(() {
                        _salesFormat = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Kasir'),
                    value: 'Kasir',
                    groupValue: _salesFormat,
                    onChanged: (value) {
                      setState(() {
                        _salesFormat = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Terapis'),
                    value: 'Terapis',
                    groupValue: _salesFormat,
                    onChanged: (value) {
                      setState(() {
                        _salesFormat = value.toString();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  masterButton(() {}, "Laporan", Icons.book),
                  masterButton(() {}, "Laporan Kasir", Icons.menu_book),
                ],
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
