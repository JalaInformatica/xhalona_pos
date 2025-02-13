import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xhalona_pos/views/home/fragment/profile/profile_screen.dart';

class EditNamePage extends StatefulWidget {
  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final TextEditingController _nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Key untuk form validation

  @override
  void initState() {
    super.initState();
    // Inisialisasi dengan nilai email saat ini
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final userProvider = Provider.of<UserProvider>(context, listen: false);
    //   _nameController.text = userProvider.user.userName ?? '';
    // });
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
        title: const Text('Ubah Nama'),
        actions: [
          TextButton(
            onPressed: () async {
              // Validasi input sebelum menyimpan
              if (_formKey.currentState!.validate()) {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setString('name', _nameController.text);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
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
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Nama lengkap',
                  hintStyle: TextStyle(fontWeight: FontWeight.w300),
                  border: const UnderlineInputBorder(),
                ),
                maxLength: 100,
                validator: (value) {
                  // Validasi input
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  if (value.length < 3) {
                    return 'Nama harus memiliki setidaknya 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Maks. 100 karakter',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
