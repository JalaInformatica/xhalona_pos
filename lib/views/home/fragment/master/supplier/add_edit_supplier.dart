import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/response/kustomer.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:xhalona_pos/repositories/kustomer/kustomer_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/supplier/supplier_controller.dart';

class AddEditSupplier extends StatelessWidget {
  KustomerDAO? kustomer;
  AddEditSupplier({this.kustomer});
  KustomerRepository _kustomerRepository = KustomerRepository();
  final SupplierController controller = Get.put(SupplierController());

  final _formKey = GlobalKey<FormState>();
  final _kdKustomerController = TextEditingController();
  final _nameKustomerController = TextEditingController();
  final _telpKustomerController = TextEditingController();
  final _emailKustomerController = TextEditingController();
  final _address1KustomerController = TextEditingController();
  final _address2KustomerController = TextEditingController();
  // bool _isLoading = true;
  bool _isPayable = false;
  bool _isCompliment = false;

  final List<String> genders = ['Laki-laki', 'Perempuan'];

  // @override
  // void initState() {
  //   super.initState();
  //   Inisialisasi();
  //   if (widget.kustomer != null) {
  //     // Inisialisasi data dari karyawan jika tersedia
  //     _kdKustomerController.text = widget.kustomer!.suplierId;
  //     _nameKustomerController.text = widget.kustomer!.suplierName;
  //     _telpKustomerController.text = widget.kustomer!.telp;
  //     _emailKustomerController.text = widget.kustomer!.emailAdress;
  //     _address1KustomerController.text = widget.kustomer!.address1;
  //     _address2KustomerController.text = widget.kustomer!.address2;
  //     _isPayable = widget.kustomer!.isPayable ?? false;
  //     _isCompliment = widget.kustomer!.isCompliment ?? false;
  //   }
  // }

  // Future<void> Inisialisasi() async {
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    void handleAddEditKustomer() async {
      if (_formKey.currentState!.validate()) {
        String result = await _kustomerRepository.addEditKustomer(
            suplierId: _kdKustomerController.text,
            suplierName: _nameKustomerController.text,
            telp: _telpKustomerController.text,
            emailAdress: _emailKustomerController.text,
            adress1: _address1KustomerController.text,
            adress2: _address2KustomerController.text,
            isPayable: _isPayable == true ? "1" : "0",
            isCompliment: _isCompliment == true ? "1" : "0",
            isSuplier: "1",
            actionId: kustomer == null ? '0' : '1');

        bool isSuccess = result == "1";
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan!')),
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
          );
          controller.fetchProducts();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data berhasil disimpan!')),
          );
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Supplier",
            style: AppTextStyle.textTitleStyle(color: Colors.white),
          ),
          backgroundColor: AppColor.secondaryColor,
        ),
        body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Field NIK
                      AppTextFormField(
                        context: context,
                        textEditingController: _kdKustomerController,
                        validator: (value) {
                          if (value == '') {
                            return "Kode harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Kode ",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),

                      // Field Nama
                      AppTextFormField(
                        context: context,
                        textEditingController: _nameKustomerController,
                        validator: (value) {
                          if (value == '') {
                            return "Nama  harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Nama ",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),

                      AppTextFormField(
                        context: context,
                        textEditingController: _telpKustomerController,
                        validator: (value) {
                          if (value == '') {
                            return "Telp harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Telp",
                        inputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                      ),

                      SizedBox(height: 16),

                      AppTextFormField(
                        context: context,
                        textEditingController: _emailKustomerController,
                        validator: (value) {
                          if (value == '') {
                            return "Email harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Email",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),

                      AppTextFormField(
                        context: context,
                        textEditingController: _address1KustomerController,
                        validator: (value) {
                          if (value == '') {
                            return "Alamat harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Alamat",
                        inputAction: TextInputAction.next,
                      ),

                      SizedBox(height: 16),

                      AppTextFormField(
                        context: context,
                        textEditingController: _address2KustomerController,
                        validator: (value) {
                          if (value == '') {
                            return "Alamat lain harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Alamat lain",
                        inputAction: TextInputAction.next,
                      ),

                      SizedBox(height: 16),
                        SwitchListTile(
                          title: Text(
                            "Is Payable",
                            style: AppTextStyle.textBodyStyle(),
                          ),
                          value: _isPayable,
                          onChanged: (value) {
                            // setState(() {
                            //   _isPayable = value;
                            // });
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            "Is Compliment",
                            style: AppTextStyle.textBodyStyle(),
                          ),
                          value: _isCompliment,
                          onChanged: (value) {
                            // setState(() {
                            //   _isCompliment = value;
                            // });
                          },
                        ),
                      SizedBox(height: 15),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(
                              handleAddEditKustomer, "Simpan", Icons.add),
                          masterButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (route) => false);
                          }, "Batal", Icons.refresh),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
