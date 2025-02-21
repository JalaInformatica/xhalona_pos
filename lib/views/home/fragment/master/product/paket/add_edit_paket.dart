import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/paket.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/repositories/paket_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/paket/paket_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/paket/master_paket_screen.dart';

// ignore: must_be_immutable
class AddEditPaket extends StatefulWidget {
  PaketDAO? paket;
  String? partId;
  AddEditPaket({super.key, this.paket, this.partId});

  @override
  _AddEditPaketState createState() => _AddEditPaketState();
}

class _AddEditPaketState extends State<AddEditPaket> {
  PaketRepository _paketRepository = PaketRepository();
  final PaketController controller = Get.put(PaketController());
  final ProductController controllerPro = Get.put(ProductController());

  final _formKey = GlobalKey<FormState>();
  final _hargaController = TextEditingController();
  final _qtyController = TextEditingController();
  bool _isLoading = true;
  String? _product;

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.paket != null) {
      // Inisialisasi data dari karyawan jika tersedia
      _hargaController.text = widget.paket!.comUnitPrice.toString();
      _qtyController.text = widget.paket!.comValue.toString();
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditPaket() async {
      if (_formKey.currentState!.validate()) {
        String result = await _paketRepository.addEditPaket(
            comUnitPrice: parseRupiah(_hargaController.text).toString(),
            comValue: _qtyController.text,
            comPartId: _product,
            partId: widget.partId,
            actionId: widget.paket == null ? '0' : '1');

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterPaketScreen()),
            (route) => false,
          );
          controller.fetchProducts();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data berhasil disimpan!')),
          );
        }
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterPaketScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Paket",
            style: AppTextStyle.textTitleStyle(color: Colors.white),
          ),
          backgroundColor: AppColor.secondaryColor,
        ),
        body: _isLoading
            ? buildShimmerLoading()
            : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Field NIK
                      buildTypeAheadFieldProduct("Kode Produk/Nama Produk",
                          controllerPro.productHeader, (value) {
                        setState(() {
                          _product = value;
                        });
                      }, controllerPro.updateFilterValue),
                      SizedBox(height: 16),

                      // Field Nama
                      buildTextField("Qty", "Masukkan Qty", _qtyController,
                          keyboardType: TextInputType.number),
                      SizedBox(height: 16),

                      buildTextField(
                          "Harga", "Masukkan Harga", _hargaController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [CurrencyInputFormatter()]),
                      SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(handleAddEditPaket, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => MasterPaketScreen()),
                                (route) => false);
                          }, "Batal", Icons.refresh),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
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
                labelText: label,
                labelStyle: TextStyle(color: AppColor.primaryColor),
                hintText: 'Cari nama...',
                hintStyle: TextStyle(color: AppColor.primaryColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColor.primaryColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primaryColor),
                ),
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
}
