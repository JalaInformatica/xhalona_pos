import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:xhalona_pos/repositories/user/user_repository.dart';

// ignore: must_be_immutable
class EditPassword extends StatefulWidget {
  EditPassword({super.key});

  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  UserRepository _userRepository = UserRepository();
  final _formKey = GlobalKey<FormState>();
  final _pw1Controller = TextEditingController();
  final _pw2Controller = TextEditingController();
  bool _isLoading = true;
  bool isScurePass = true;

  @override
  void initState() {
    super.initState();
    inisialisasi();
  }

  Future<void> inisialisasi() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleEditPassword() async {
      if (_formKey.currentState!.validate()) {
        String result = await _userRepository.changePasswordProfile(
          password1: _pw1Controller.text,
          password2: _pw2Controller.text,
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
            SnackBar(content: Text('Ganti password berhasil disimpan!')),
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
            "Edit Password",
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
                      AppTextFormField(
                        context: context,
                        textEditingController: _pw1Controller,
                        icon: tooglePass(),
                        isScurePass: isScurePass,
                        validator: (value) {
                          if (value == '') {
                            return "Password harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Password",
                        inputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),

                      // Field Nama

                      AppTextFormField(
                        context: context,
                        textEditingController: _pw2Controller,
                        icon: tooglePass(),
                        isScurePass: isScurePass,
                        validator: (value) {
                          if (value == '') {
                            return "Konfirmasi Password harus diisi!";
                          }
                          return null;
                        },
                        labelText: "Konfirmasi Password",
                        inputAction: TextInputAction.send,
                        onFieldSubmitted: (_) {
                          handleEditPassword();
                        },
                      ),
                      SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          masterButton(handleEditPassword, "Simpan", Icons.add),
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

  Widget buildTextField(
      String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isScurePass,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        icon: tooglePass(),
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

  Widget tooglePass() {
    return IconButton(
      onPressed: () {
        setState(() {
          isScurePass = !isScurePass;
        });
      },
      icon: isScurePass
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }
}
