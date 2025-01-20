import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/master_product_screen.dart';

class AddEditProduct extends StatefulWidget {
  ProductDAO? product;
  AddEditProduct({super.key, this.product});
  @override
  _AddEditProductState createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  final _formKey = GlobalKey<FormState>();

  // Contoh data untuk dropdown
  List<String> categories = ['Kategori 1', 'Kategori 2', 'Kategori 3'];
  String? selectedCategory;
  String? selectedGlobalCategory;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterProductScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Product",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColor.secondaryColor,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Informasi Produk Section
                Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Produk',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Nama Kategori',
                            border: OutlineInputBorder(),
                          ),
                          value: selectedCategory,
                          items: categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) return 'Pilih kategori';
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Nama Kategori Global',
                            border: OutlineInputBorder(),
                          ),
                          value: selectedGlobalCategory,
                          items: categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedGlobalCategory = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) return 'Pilih kategori global';
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nama Produk',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan nama produk';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Deskripsi',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Deskripsi harus di isi';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Tambah Gambar',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Implementasikan fungsi unggah
                              },
                              child: Text('Unggah (1x)'),
                            ),
                            SizedBox(width: 8.0),
                            Icon(Icons.image, size: 40),
                            Icon(Icons.image, size: 40),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Satuan & Harga Section
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Satuan & Harga',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Satuan',
                            hintText: 'Masukkan Satuan Produk',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Satuan wajib di isi';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Harga Satuan',
                            hintText: '0',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Diskon %',
                            hintText: '0',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Diskon',
                            hintText: 'Masukkan Diskon',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Ubah Harga',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: [
                            FilterChip(
                              label: Text('Qty Tetap'),
                              selected: false,
                              onSelected: (value) {},
                            ),
                            FilterChip(
                              label: Text('Bonus'),
                              selected: false,
                              onSelected: (value) {},
                            ),
                            FilterChip(
                              label: Text('Paket'),
                              selected: false,
                              onSelected: (value) {},
                            ),
                            FilterChip(
                              label: Text('Stock'),
                              selected: false,
                              onSelected: (value) {},
                            ),
                            FilterChip(
                              label: Text('Promo'),
                              selected: false,
                              onSelected: (value) {},
                            ),
                            FilterChip(
                              label: Text('Tak Dijual'),
                              selected: false,
                              onSelected: (value) {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                masterButton(() {}, "Simpan", Icons.add)
              ],
            ),
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
