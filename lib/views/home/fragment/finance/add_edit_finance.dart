import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/kasbank.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/models/dao/rekening.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/repositories/kasbank/kasbank_repository.dart';
import 'package:xhalona_pos/views/home/fragment/finance/finance_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/rekening/rekening_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/supplier/supplier_kustomer_controller.dart';

// ignore: must_be_immutable
class AddEditFinance extends StatefulWidget {
  KasBankDAO? finance;
  AddEditFinance({super.key, this.finance});

  @override
  _AddEditFinanceState createState() => _AddEditFinanceState();
}

class _AddEditFinanceState extends State<AddEditFinance> {
  KasBankRepository _financeRepository = KasBankRepository();
  final RekeningController controllerKar = Get.put(RekeningController());
  final FinanceController controllerFi = Get.put(FinanceController());
  final KustomerController controllerKus = Get.put(KustomerController());

  final _formKey = GlobalKey<FormState>();
  final _noTrxController = TextEditingController();
  final _ketController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _jmlBayarController = TextEditingController();
  String? _jenisTrx;
  String? _finance;
  String? _kustomer;
  bool _isLoading = true;

  final List<String> jenisTrx = ['M', 'K'];
  final List<String> flagTm = ['T', 'M'];

  @override
  void initState() {
    super.initState();
    Inisialisasi();
    if (widget.finance != null) {
      // Inisialisasi data dari finance jika tersedia
      _noTrxController.text = widget.finance!.voucherNo ?? '';
      _ketController.text = widget.finance!.ket ?? '';
      _jmlBayarController.text = widget.finance!.jmlBayar.toString() ?? '';
      _jenisTrx = widget.finance!.jenisAc ?? '';
      _kustomer = widget.finance!.refName ?? '';
    }
  }

  Future<void> Inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<RekeningDAO> rekening = controllerKar.rekeningHeader;
    final List<KustomerDAO> kustomer = controllerKus.kustomerHeader;

    void handleAddEditFinance() async {
      if (_formKey.currentState!.validate()) {
        String result = await _financeRepository.addEditKasBank(
          acId: _finance,
          refID: _kustomer,
          subModulId: _jenisTrx,
          vocherDate: _tanggalController.text,
          vocherNo: _noTrxController.text,
          ket: _ketController.text,
          actionId: widget.finance == null ? "0" : "1",
        );

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
          setState(() {});
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
          controllerFi.fetchProducts();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data berhasil disimpan!')),
          );
        }
      }
    }

    void handleuPost() async {
      String? result;
      if (widget.finance!.isApproved == false) {
        result = await _financeRepository.postingKasBank(
            voucherNo: _noTrxController.text);
      } else {
        result = await _financeRepository.unpostingKasBank(
            voucherNo: _noTrxController.text);
      }

      bool isSuccess = result == "1";
      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data gagal disimpan!')),
        );
        setState(() {});
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
        controllerFi.fetchProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil disimpan!')),
        );
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
          title: Text(
            "Finance",
            style: AppTextStyle.textTitleStyle(color: Colors.white),
          ),
          backgroundColor: AppColor.secondaryColor,
          actions: [
            masterButton(() {}, '', Icons.settings),
            SizedBox(width: 5),
            masterButton(() {}, 'Print', Icons.print),
            SizedBox(width: 5),
          ],
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
                      buildTextField(
                          "No Trx", "Masukkan no trx", _noTrxController,
                          isEnabled: false),
                      SizedBox(height: 16),

                      buildDropdownFieldJK("Jenis Trx", jenisTrx, (value) {
                        setState(() {
                          _jenisTrx = value;
                        });
                      }),
                      SizedBox(height: 16),

                      buildDropdownField("Akun", rekening, (value) {
                        setState(() {
                          _finance = value;
                        });
                      }),
                      SizedBox(height: 16),

                      buildDateField("Tanggal", _tanggalController),
                      SizedBox(height: 16),

                      buildDropdownFieldRef("Diterima dari", kustomer, (value) {
                        setState(() {
                          _kustomer = value;
                        });
                      }),
                      SizedBox(height: 16),

                      // Field Nama
                      buildTextField(
                          "Keterangan", "Masukkan keterangan", _ketController),
                      SizedBox(height: 16),

                      // Field BPJS Kesehatan
                      buildTextField("Jumlah Bayar", "Masukkan jumlah bayar",
                          _jmlBayarController,
                          isEnabled: false),
                      SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(
                              handleAddEditFinance, "Simpan", Icons.add),
                          masterButton(
                              handleuPost,
                              widget.finance != null &&
                                      widget.finance!.isApproved == true
                                  ? 'UnPost'
                                  : 'Post',
                              Icons.post_add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
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

  Widget masterButton(VoidCallback onTap, String label, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.primaryColor, // Background color
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
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(label,
                style: AppTextStyle.textTitleStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget buildDateField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text = "${pickedDate.toLocal()}".split(' ')[0];
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool isEnabled = true, // Tambahkan parameter ini
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: isEnabled, // Atur properti enabled berdasarkan parameter
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget buildDropdownFieldRef(
      String label, List<KustomerDAO> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
            value: item.suplierId, child: Text(item.suplierName));
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 16,
            margin: EdgeInsets.symmetric(vertical: 8),
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget buildDropdownField(
      String label, List<RekeningDAO> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item.acId, child: Text(item.namaAc));
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget buildDropdownFieldJK(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
