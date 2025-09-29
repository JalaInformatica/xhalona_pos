import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/response/varian.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:xhalona_pos/repositories/varian/varian_repositorty.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/m_all/mAll_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/varian/varian_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/varian/master_varian_screen.dart';

// ignore: must_be_immutable
class AddEditVarian extends StatefulWidget {
  VarianDAO? kategori;
  String? varGroupId;
  AddEditVarian({super.key, this.kategori, this.varGroupId});

  @override
  _AddEditVarianState createState() => _AddEditVarianState();
}

class _AddEditVarianState extends State<AddEditVarian> {
  VarianRepository _kategoriRepository = VarianRepository();
  final VarianController controller = Get.put(VarianController());
  final ProductController controllerPro = Get.put(ProductController());
  final MasAllController controllerMas = Get.put(MasAllController());

  final _formKey = GlobalKey<FormState>();
  final _nameVarianController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Inisialisasi();
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditVarian() async {
      if (_formKey.currentState!.validate()) {
        String result = await _kategoriRepository.addEditVarian(
            varName: _nameVarianController.text,
            varGroupId: widget.varGroupId,
            actionId: widget.kategori == null ? '0' : '1');

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterVarianScreen()),
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
            MaterialPageRoute(builder: (context) => MasterVarianScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Sub Varian",
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
                      // Field Nama
                      AppTextFormField(
                        context: context,
                        textEditingController: _nameVarianController,
                        validator: (value) {
                          if (value == '') {
                            return "Sub Varian harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Sub Varian",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(
                              handleAddEditVarian, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => MasterVarianScreen()),
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
}
