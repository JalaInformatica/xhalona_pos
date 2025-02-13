import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/metodebayar.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/repositories/metodebayar/metodebayar_repository.dart';
import 'package:xhalona_pos/views/home/fragment/finance/metodebayar/metodebayar_screen.dart';
import 'package:xhalona_pos/views/home/fragment/finance/metodebayar/metodebayar_controller.dart';

// ignore: must_be_immutable
class AddEditMetodeBayar extends StatefulWidget {
  MetodeBayarDAO? metodebayar;
  AddEditMetodeBayar({super.key, this.metodebayar});

  @override
  _AddEditMetodeBayarState createState() => _AddEditMetodeBayarState();
}

class _AddEditMetodeBayarState extends State<AddEditMetodeBayar> {
  MetodeBayarRepository _metodebayarRepository = MetodeBayarRepository();
  final MetodeBayarController controllerKar = Get.put(MetodeBayarController());

  final _formKey = GlobalKey<FormState>();
  final _kodeRekController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isActive = true; // Status Aktif/Non-Aktif
  bool _isCash = true;
  bool _isCard = true;
  bool _isDefault = true;
  bool _isbelowAmt = true;
  bool _isfixAmt = true;
  bool _isnumberCard = true;
  bool _isPiutang = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.metodebayar != null) {
      // Inisialisasi data dari metodebayar jika tersedia
      _kodeRekController.text = widget.metodebayar!.payMetodeGroup;
      _nameController.text = widget.metodebayar!.payMetodeName;
      _isActive = widget.metodebayar!.isActive;
      _isCash = widget.metodebayar!.isCash;
      _isCard = widget.metodebayar!.isCard;
      _isDefault = widget.metodebayar!.isDefault;
      _isbelowAmt = widget.metodebayar!.isBellowHmt;
      _isfixAmt = widget.metodebayar!.isFixHmt;
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditMetodeBayar() async {
      if (_formKey.currentState!.validate()) {
        String result = await _metodebayarRepository.addEditMetodeBayar(
          payMethodeId: widget.metodebayar!.payMetodeId,
          payMethodeGroup: _kodeRekController.text,
          payMethodeName: _nameController.text,
          isCard: _isCard ? "1" : "0",
          isCash: _isCash ? "1" : "0",
          isDefault: _isDefault ? "1" : "0",
          isPiutang: _isPiutang ? "1" : "0",
          isbellowAmt: _isbelowAmt ? "1" : "0",
          isfixAmt: _isfixAmt ? "1" : "0",
          isnumberCard: _isnumberCard ? "1" : "0",
          isActive: _isActive ? "1" : "0",
          actionId: widget.metodebayar == null ? "0" : "1",
        );

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MetodeBayarScreen()),
            (route) => false,
          );
          controllerKar.fetchProducts();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data berhasil disimpan!')),
          );
        }
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MetodeBayarScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data MetodeBayar",
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
                      buildTextField(
                          "Group Metode Pembayaran",
                          "Masukkan Group Metode Pembayaran",
                          _kodeRekController),
                      SizedBox(height: 16),

                      // Field Nama
                      buildTextField("Nama Metode Pembayaran",
                          "Masukkan Nama Metode Pembayaran", _nameController),
                      SizedBox(height: 16),
                      // Field Aktif/Non-Aktif

                      SwitchListTile(
                        title: Text("Cash"),
                        value: _isCash,
                        onChanged: (value) {
                          setState(() {
                            _isCash = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),

                      SwitchListTile(
                        title: Text("Debit"),
                        value: _isCard,
                        onChanged: (value) {
                          setState(() {
                            _isCard = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),

                      SwitchListTile(
                        title: Text("Hutang"),
                        value: _isPiutang,
                        onChanged: (value) {
                          setState(() {
                            _isPiutang = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),

                      SwitchListTile(
                        title: Text("Otomatis"),
                        value: _isDefault,
                        onChanged: (value) {
                          setState(() {
                            _isDefault = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),

                      SwitchListTile(
                        title: Text("Bawah Tagihan"),
                        value: _isbelowAmt,
                        onChanged: (value) {
                          setState(() {
                            _isbelowAmt = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),

                      SwitchListTile(
                        title: Text("Sesuai Tagihan"),
                        value: _isfixAmt,
                        onChanged: (value) {
                          setState(() {
                            _isfixAmt = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),

                      SwitchListTile(
                        title: Text("Nomor Kartu"),
                        value: _isnumberCard,
                        onChanged: (value) {
                          setState(() {
                            _isnumberCard = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),

                      SwitchListTile(
                        title: Text("Aktif"),
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                      ),
                      SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(
                              handleAddEditMetodeBayar, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => MetodeBayarScreen()),
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
