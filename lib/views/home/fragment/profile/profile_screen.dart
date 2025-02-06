import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xhalona_pos/services/user/user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xhalona_pos/views/home/fragment/profile/ubah%20profile/editname_page.dart';
import 'package:xhalona_pos/views/home/fragment/profile/ubah%20profile/editemail_page.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  String? profileImageUrl;

  ProfileScreen({this.profileImageUrl});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _dateController = TextEditingController();
  late SharedPreferences prefs;
  String? name;
  String? tLahir;
  String? email;
  String? jKelamin;

  String? profileImageUrl;
  String? baseUrl;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('userName');
      tLahir = prefs.getString('datePicker');
      email = prefs.getString('userEmail');
    });
  }

  Future<void> _requestPermissionCamera() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  Future<void> _requestPermissionGallery() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      await Permission.photos.request();
    }
  }

  Future<File?> _cropImage(File pickedFile) async {
    // CroppedFile? croppedFile = await ImageCropper().cropImage(
    //     sourcePath: pickedFile.path,
    //     aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    //     uiSettings: [
    //       AndroidUiSettings(
    //         toolbarTitle: 'Crop Image',
    //         toolbarColor: AppColor.primaryColor,
    //         toolbarWidgetColor: Colors.white,
    //         initAspectRatio: CropAspectRatioPreset.square,
    //         lockAspectRatio: true,
    //       ),
    //       IOSUiSettings(
    //         minimumAspectRatio: 1.0,
    //       ),
    //     ]);

    // if (croppedFile != null) {
    //   return File(croppedFile.path);
    // }
    // return null;
    return pickedFile;
  }

  Future<void> _pickImage(ImageSource source) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        File? croppedFile = await _cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          String uploadedImageUrl =
              await UserService().uploadProfile(croppedFile);
          setState(() {
            profileImageUrl = uploadedImageUrl;
            prefs.setString('profileImageUrl', profileImageUrl!);
          });
        } else {
          print('Image cropping cancelled.');
        }
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Fungsi untuk menampilkan opsi sumber gambar (galeri atau kamera)
  void _showImageSourceSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.pink),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                await _requestPermissionGallery();
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.pink),
              title: const Text('Ambil dari Kamera'),
              onTap: () async {
                await _requestPermissionCamera();
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate() async {
    prefs = await SharedPreferences.getInstance();
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xffC0226D),
            colorScheme: const ColorScheme.light(primary: Color(0xffC0226D)),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (_picked != null) {
      setState(() {
        // Format tanggal
        _dateController.text = DateFormat('yyyy-MM-dd').format(_picked);
        prefs.setString('datePicker', _dateController.text);
      });
    }
  }

  String? _selectedGender;
  void _showGenderSelector() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.male, color: Colors.blue),
              title: const Text('Laki-laki'),
              onTap: () {
                setState(() {
                  _selectedGender = 'Laki-laki';
                  prefs.setString('gender', _selectedGender!);
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.female, color: Colors.pink),
              title: const Text('Perempuan'),
              onTap: () {
                setState(() {
                  _selectedGender = 'Perempuan';
                  prefs.setString('gender', _selectedGender!);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // handleChangeProfile() async {
    //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   if (await userProvider.changeUserDetail(
    //     userName: name ?? userDetail.userName,
    //     userEmail: email ?? userDetail.emailAddress,
    //     userPhone: userDetail.phoneNumber,
    //     joinDate: userDetail.jointDate,
    //     userPic: prefs.getString('profileImageUrl') ?? userDetail.profilePic,
    //     userBirthDate: _dateController.text == null
    //         ? '${userDetail.profileBirthDate?.date}'
    //         : prefs.getString('datePicker'),
    //     userGender: prefs.getString('gender') == "Laki-laki"
    //         ? 'M'
    //         : 'F' ?? userDetail.profileSex,
    //   )) {
    //     Navigator.pushNamed(context, '/home');
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         backgroundColor: Colors.green,
    //         content: Text(
    //           "Ubah profile berhasil!!",
    //           textAlign: TextAlign.center,
    //         ),
    //       ),
    //     );
    //     Navigator.pushNamed(context, '/profile-user');
    //   }
    // }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColor.primaryColor,
        title: const Text(
          'Profile Saya',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: isLoading // Periksa apakah data masih dimuat
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: [
                  // CircleAvatar di atas daftar
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  // ListTile di bawah CircleAvatar
                  Expanded(
                    child: ListView(
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                width: double.infinity,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 5),
                              Container(
                                height: 20,
                                width: double.infinity,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar & Edit Button
                    Center(
                      child: GestureDetector(
                        onTap: _showImageSourceSelector,
                        child: Stack(
                          children: [
                            prefs.getString('profileImageUrl') != null &&
                                    prefs
                                        .getString('profileImageUrl')!
                                        .isNotEmpty
                                ? Container(
                                    width:
                                        100, // Ukuran `width` dan `height` harus lebih besar dari `CircleAvatar`
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColor.primaryColor,
                                        width: 4, // Tebal border
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.transparent,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '${baseUrl}/${prefs.getString('profileImageUrl')}',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundColor: Colors.grey[200],
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.grey[200],
                                            child: const Icon(Icons.error,
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width:
                                        100, // Ukuran `width` dan `height` harus lebih besar dari `CircleAvatar`
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4, // Tebal border
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      child: Text(
                                        'A',
                                        style: TextStyle(
                                            color: Colors.pink.shade800,
                                            fontSize: 30),
                                      ),
                                    ),
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width:
                                    28, // Slightly larger edit icon container
                                height: 28,
                                decoration: const BoxDecoration(
                                  color:
                                      Colors.blue, // Edit icon background color
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white, // Edit icon color
                                  size: 18, // Slightly larger edit icon
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      title: const Text('Nama'),
                      subtitle: Text('Atur Sekarang'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditNamePage()));
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Tanggal lahir'),
                      subtitle: Text('Atur Sekarang'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _selectDate,
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('No. Handphone'),
                      subtitle: Text('Atur Sekarang'),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Email'),
                      subtitle: Text('Atur Sekarang'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditEmailPage()));
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Jenis Kelamin'),
                      subtitle:
                          Text(_selectedGender ?? jKelamin ?? 'Atur Sekarang'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _showGenderSelector,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
