import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/models/dao/kategori.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/models/dao/karyawan.dart';
import 'package:xhalona_pos/widgets/app_bottombar.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/karyawan_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/kategori/kategori_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/supplier/supplier_kustomer_controller.dart';

class MonitorScreen extends StatefulWidget {
  @override
  _MonitorScreenState createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  final KaryawanController controllerKar = Get.put(KaryawanController());
  final KustomerController controllerKus = Get.put(KustomerController());
  final ProductController controllerProduct = Get.put(ProductController());
  final KategoriController controllerKat = Get.put(KategoriController());

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
    final screenWidth = MediaQuery.of(context).size.width;
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
            style: AppTextStyle.textTitleStyle(color: Colors.white),
          ),
          backgroundColor: AppColor.secondaryColor,
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
              buildTypeAheadFieldTerapis(
                  "Filter Terapis", controllerKar.karyawanHeader, (value) {
                setState(() {
                  _selectedTherapist = value;
                });
              }, controllerKar.updateFilterValue),
              SizedBox(height: 16),
              buildTypeAheadFieldCustomer(
                  "Filter Customer", controllerKus.kustomerHeader, (value) {
                setState(() {
                  _selectedCustomer = value;
                });
              }, controllerKus.updateMonitorValue),
              SizedBox(height: 16),
              buildTypeAheadFieldProduct(
                  "Filter Product", controllerProduct.productHeader, (value) {
                setState(() {
                  _selectedProduct = value;
                });
              }, controllerProduct.updateFilterValue),
              SizedBox(height: 16),
              buildTypeAheadFieldKategori(
                  "Filter Kategori", controllerKat.kategoriGlobalHeader,
                  (value) {
                setState(() {
                  _selectedCategory = value;
                });
              }, controllerKat.updateFilterValue),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Type'),
                      value: _reportType,
                      items: ['Detail', 'Rekap', 'Subtotal']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type,
                                    style: AppTextStyle.textTitleStyle()),
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
                      items: ['Semua', 'Pagi', 'Siang']
                          .map((shift) => DropdownMenuItem(
                                value: shift,
                                child: Text(shift,
                                    style: AppTextStyle.textTitleStyle()),
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
              Text('Format Penjualan By:',
                  style: AppTextStyle.textTitleStyle()),
              Column(
                children: [
                  RadioListTile(
                    title: Text('Harian', style: AppTextStyle.textTitleStyle()),
                    value: 'Harian',
                    groupValue: _salesFormat,
                    onChanged: (value) {
                      setState(() {
                        _salesFormat = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Kasir', style: AppTextStyle.textTitleStyle()),
                    value: 'Kasir',
                    groupValue: _salesFormat,
                    onChanged: (value) {
                      setState(() {
                        _salesFormat = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title:
                        Text('Terapis', style: AppTextStyle.textTitleStyle()),
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
              SizedBox(height: 70),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: buildFloatingActionButton(context, screenWidth),
        bottomNavigationBar: buildBottomNavigationBar(context),
      ),
    );
  }

  Widget buildTypeAheadFieldCustomer(
    String label,
    List<KustomerDAO> items,
    ValueChanged<String?> onChanged,
    void Function(String newFilterValue) updateFilterValue,
  ) {
    TextEditingController controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.textTitleStyle()),
        SizedBox(height: 8),
        TypeAheadField<KustomerDAO>(
          suggestionsCallback: (pattern) async {
            updateFilterValue(pattern); // Update filter
            return items
                .where((item) => item.suplierName
                    .toLowerCase()
                    .contains(pattern.toLowerCase()))
                .toList(); // Pencarian berdasarkan nama
          },
          builder: (context, textEditingController, focusNode) {
            controller = textEditingController;

            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Cari nama...",
              ),
              onChanged: (value) {
                // Jangan lakukan apa-apa saat mengetik, biarkan saat dipilih
              },
            );
          },
          itemBuilder: (context, KustomerDAO suggestion) {
            return ListTile(
              title: Text(suggestion.suplierName
                  .toString()), // Tampilkan ID sebagai info tambahan
            );
          },
          onSelected: (KustomerDAO suggestion) {
            controller.text = suggestion.suplierName
                .toString(); // Tampilkan nama produk di field
            onChanged(suggestion.suplierId); // Simpan ID produk di _product
          },
        ),
      ],
    );
  }

  Widget buildTypeAheadFieldTerapis(
    String label,
    List<KaryawanDAO> items,
    ValueChanged<String?> onChanged,
    void Function(String newFilterValue) updateFilterValue,
  ) {
    TextEditingController controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.textTitleStyle()),
        SizedBox(height: 8),
        TypeAheadField<KaryawanDAO>(
          suggestionsCallback: (pattern) async {
            updateFilterValue(pattern); // Update filter
            return items
                .where((item) =>
                    item.fullName.toLowerCase().contains(pattern.toLowerCase()))
                .toList(); // Pencarian berdasarkan nama
          },
          builder: (context, textEditingController, focusNode) {
            controller = textEditingController;

            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Cari nama...",
              ),
              onChanged: (value) {
                // Jangan lakukan apa-apa saat mengetik, biarkan saat dipilih
              },
            );
          },
          itemBuilder: (context, KaryawanDAO suggestion) {
            return ListTile(
              title: Text(suggestion.fullName
                  .toString()), // Tampilkan ID sebagai info tambahan
            );
          },
          onSelected: (KaryawanDAO suggestion) {
            controller.text = suggestion.fullName
                .toString(); // Tampilkan nama produk di field
            onChanged(suggestion.empId); // Simpan ID produk di _product
          },
        ),
      ],
    );
  }

  Widget buildTypeAheadFieldProduct(
    String label,
    List<ProductDAO> items,
    ValueChanged<String?> onChanged,
    void Function(String newFilterValue) updateFilterValue,
  ) {
    TextEditingController controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.textTitleStyle()),
        SizedBox(height: 8),
        TypeAheadField<ProductDAO>(
          suggestionsCallback: (pattern) async {
            updateFilterValue(pattern); // Update filter
            return items
                .where((item) =>
                    item.partName.toLowerCase().contains(pattern.toLowerCase()))
                .toList(); // Pencarian berdasarkan nama
          },
          builder: (context, textEditingController, focusNode) {
            controller = textEditingController;

            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Cari nama...",
              ),
              onChanged: (value) {
                // Jangan lakukan apa-apa saat mengetik, biarkan saat dipilih
              },
            );
          },
          itemBuilder: (context, ProductDAO suggestion) {
            return ListTile(
              title: Text(suggestion.partName
                  .toString()), // Tampilkan ID sebagai info tambahan
            );
          },
          onSelected: (ProductDAO suggestion) {
            controller.text = suggestion.partName
                .toString(); // Tampilkan nama produk di field
            onChanged(suggestion.partId); // Simpan ID produk di _product
          },
        ),
      ],
    );
  }

  Widget buildTypeAheadFieldKategori(
    String label,
    List<KategoriDAO> items,
    ValueChanged<String?> onChanged,
    void Function(String newFilterValue) updateFilterValue,
  ) {
    TextEditingController controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.textTitleStyle()),
        SizedBox(height: 8),
        TypeAheadField<KategoriDAO>(
          suggestionsCallback: (pattern) async {
            updateFilterValue(pattern); // Update filter
            return items
                .where((item) => item.ketAnalisa
                    .toLowerCase()
                    .contains(pattern.toLowerCase()))
                .toList(); // Pencarian berdasarkan nama
          },
          builder: (context, textEditingController, focusNode) {
            controller = textEditingController;

            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Cari kategori...",
              ),
              onChanged: (value) {
                // Jangan lakukan apa-apa saat mengetik, biarkan saat dipilih
              },
            );
          },
          itemBuilder: (context, KategoriDAO suggestion) {
            return ListTile(
              title: Text(suggestion.ketAnalisa
                  .toString()), // Tampilkan ID sebagai info tambahan
            );
          },
          onSelected: (KategoriDAO suggestion) {
            controller.text = suggestion.ketAnalisa
                .toString(); // Tampilkan nama produk di field
            onChanged(suggestion.analisaId); // Simpan ID produk di _product
          },
        ),
      ],
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
