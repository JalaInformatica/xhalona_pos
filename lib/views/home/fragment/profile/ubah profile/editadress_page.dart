import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:xhalona_pos/views/home/fragment/profile/profile_screen.dart';

class EditAddressPage extends StatefulWidget {
  @override
  State<EditAddressPage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  final HomeController controller = Get.put(HomeController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Key untuk form validation

  @override
  void initState() {
    super.initState();
    // Inisialisasi dengan nilai email saat ini
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addressController.text =
          controller.profileData.value.profileAddress ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Ubah Alamat'),
        actions: [
          TextButton(
            onPressed: () async {
              // Validasi input sebelum menyimpan
              if (_formKey.currentState!.validate()) {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setString('userAddress', _addressController.text);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              }
            },
            child: const Text(
              'Simpan',
              style: TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Form key untuk validasi
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextFormField(
                context: context,
                textEditingController: _addressController,
                validator: (value) {
                  if (value == '') {
                    return "Alamat harus diisi!";
                  }
                  return null;
                },
                maxLines: 5,
                labelText: "Alamat",
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),
              const Text(
                'Ex: Jalan Merdeka No. 10, RT 03/RW 05, Kelurahan Cempaka Putih, Kecamatan Cempaka Putih, Kota Jakarta Pusat, DKI Jakarta 10510',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
