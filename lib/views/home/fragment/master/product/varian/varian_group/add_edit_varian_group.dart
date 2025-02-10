import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/varian.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/repositories/varian/varianGroup_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/m_all/mAll_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/varian/varian_group/varianGroup_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/varian/varian_group/master_varian_group_screen.dart';


// ignore: must_be_immutable
class AddEditVarianGroup extends StatefulWidget {
  VarianDAO? kategori;
  String? varGroupId;
  AddEditVarianGroup({super.key, this.kategori, this.varGroupId});

  @override
  _AddEditVarianGroupState createState() => _AddEditVarianGroupState();
}

class _AddEditVarianGroupState extends State<AddEditVarianGroup> {
  VarianGroupRepository _kategoriRepository = VarianGroupRepository();
  final VarianGroupController controller = Get.put(VarianGroupController());
  final ProductController controllerPro = Get.put(ProductController());
  final MasAllController controllerMas = Get.put(MasAllController());

  final _formKey = GlobalKey<FormState>();
  final _nameVarianGroupController = TextEditingController();
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
    void handleAddEditVarianGroup() async {
      if (_formKey.currentState!.validate()) {
        String result = await _kategoriRepository.addEditVarianGroup(
            varName: _nameVarianGroupController.text,
            actionId: widget.kategori == null ? '0' : '1');

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterVarianGroupScreen()),
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
            MaterialPageRoute(builder: (context) => MasterVarianGroupScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Varian Group",
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
                      buildTextField(
                          "Group VarianGroup",
                          "Masukkan Group VarianGroup",
                          _nameVarianGroupController),
                      SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(
                              handleAddEditVarianGroup, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MasterVarianGroupScreen()),
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
