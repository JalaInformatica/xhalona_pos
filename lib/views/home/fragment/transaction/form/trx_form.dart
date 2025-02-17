import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/repositories/transaction/transaction_repository.dart';
// ignore_for_file: deprecated_member_use, non_constant_identifier_names, prefer_const_constructors_in_immutables, library_private_types_in_public_api

// ignore_for_file: use_build_context_synchronously

// ignore: must_be_immutable
class TrxFormScreen extends StatefulWidget {
  String? actionId;
  String? salesId;
  TrxFormScreen({super.key, this.actionId, this.salesId});

  @override
  _TrxFormScreenState createState() => _TrxFormScreenState();
}

class _TrxFormScreenState extends State<TrxFormScreen> {
  TransactionRepository _trxRepository = TransactionRepository();

  final _formKey = GlobalKey<FormState>();
  final _statusDescController = TextEditingController();
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
    void handleTrxFormScreen() async {
      if (_formKey.currentState!.validate()) {
        String result = await _trxRepository.onTransactionHeader(
          actionId: widget.actionId,
          salesId: widget.salesId,
          statusDesc: _statusDescController.text,
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data berhasil disimpan!')),
          );
        }
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
            "Transaksi Lanjutan",
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
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextField(
                                  '', 'Masukan input', _statusDescController)
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(
                              handleTrxFormScreen, "Simpan", Icons.add),
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
}
