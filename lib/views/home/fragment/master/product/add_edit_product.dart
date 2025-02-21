import 'dart:io';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/models/dao/kategori.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xhalona_pos/widgets/full_screen_image.dart';
import 'package:xhalona_pos/services/user/user_service.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/services/api_service.dart' as api;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xhalona_pos/repositories/product/product_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/kategori/kategori_controller.dart';
// ignore_for_file: unused_field

// ignore: must_be_immutable
class AddEditProduct extends StatefulWidget {
  ProductDAO? product;
  String? profileImageUrl;
  AddEditProduct({super.key, this.product, this.profileImageUrl});
  @override
  _AddEditProductState createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  final KategoriController controller = Get.put(KategoriController());
  final ProductController controllerPro = Get.put(ProductController());
  ProductRepository _productRepository = ProductRepository();
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;

  // Contoh data untuk dropdown

  // Variables for input fields
  final productName = TextEditingController();
  final productDescription = TextEditingController();
  String? productUnit;
  final productPrice = TextEditingController();
  final productDiscountPercentage = TextEditingController();
  final productDiscount = TextEditingController();
  String? _kategori;
  String? _kategoriGlobal;
  final List<String> genders = ['PCS', 'JASA', 'BUAH'];

  String? profileImageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    inisiasi();
    if (widget.product != null) {
      productName.text = widget.product?.partName ?? '';
      productDescription.text = widget.product?.spec ?? '';
      productUnit = widget.product?.unit1 ?? '';
      productPrice.text = widget.product?.unitPrice.toString() ?? '';
      productDiscountPercentage.text =
          widget.product?.discountPct.toString() ?? '';
      productDiscount.text = widget.product?.discountVal.toString() ?? '';
      chipStatus['Qty Tetap'] = widget.product?.isFixQty ?? false;
      chipStatus['Bonus'] = widget.product?.isNonSales ?? false;
      chipStatus['Paket'] = widget.product?.isPacket ?? false;
      chipStatus['Stock'] = widget.product?.isStock ?? false;
      chipStatus['Promo'] = widget.product?.isPromo ?? false;
      chipStatus['Tak Dijual'] = widget.product?.isFixPrice ?? false;
      profileImageUrl = widget.product?.thumbImage;
    }
  }

  Future<void> inisiasi() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImageUrl = prefs.getString('profileImageUrl');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditProduct() async {
      if (_formKey.currentState!.validate()) {
        String result = await _productRepository.addEditProduct(
          analisaId: _kategori,
          analisaIdGlobal: _kategoriGlobal,
          partId: widget.product?.partId,
          partName: productName.text,
          deskripsi: productDescription.text,
          unit1: productUnit,
          unitPrice: parseRupiah(productPrice.text),
          discPct: parseRupiah(productDiscountPercentage.text),
          discVal: parseRupiah(productDiscount.text),
          isFixQty: chipStatus['Qty Tetap'] == true ? 1 : 0,
          isFixPrice: chipStatus['Bonus'] == true ? 1 : 0,
          isPacket: chipStatus['Paket'] == true ? 1 : 0,
          isStock: chipStatus['Stock'] == true ? 1 : 0,
          isPromo: chipStatus['Promo'] == true ? 1 : 0,
          isFree: chipStatus['Tak Dijual'] == true ? 1 : 0,
          mainImage: profileImageUrl ?? widget.product?.thumbImage,
          thumbImage: profileImageUrl ?? widget.product?.thumbImage,
          actionId: widget.product == null ? "0" : "1",
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
          controllerPro.fetchProducts();
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
          automaticallyImplyLeading: false,
          title: Text(
            "Tambah/Edit Data Product ",
            style: AppTextStyle.textTitleStyle(color: Colors.white),
          ),
          backgroundColor: AppColor.secondaryColor,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Informasi Produk Section
                Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Produk',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 16.0),
                        buildTypeAheadField(
                            "Kategori", controller.kategoriHeader, (value) {
                          setState(() {
                            _kategori = value;
                          });
                        }, controller.updateFilterValue, api.companyId),
                        SizedBox(height: 16),
                        buildTypeAheadField(
                            "Kategori Global", controller.kategoriHeader,
                            (value) {
                          setState(() {
                            _kategoriGlobal = value;
                          });
                        }, controller.updateFilterValue, 'All'),
                        SizedBox(height: 16),
                        buildTextField(
                            "Nama Produk", "Masukkan Nama Produk", productName),
                        SizedBox(height: 16.0),
                        buildTextField(
                            "Deskripsi", "Masukkan input", productDescription,
                            maxline: 3),
                        SizedBox(height: 16.0),
                        Text(
                          'Tambah Gambar',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            masterButton(_showImageSourceSelector,
                                "Unggah (1X1)", Icons.image),
                            SizedBox(width: 8.0),
                            GestureDetector(
                              onTap: () {
                                showFullScreenImage(
                                  context,
                                  'https://dreadnought.core-erp.com/XHALONA/${widget.product?.thumbImage ?? profileImageUrl}',
                                );
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: AppColor.secondaryColor,
                                    width: 4,
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://dreadnought.core-erp.com/XHALONA/${widget.product?.thumbImage ?? profileImageUrl}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
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
                                    child: const Icon(Icons.add_a_photo),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Satuan & Harga Section
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Satuan & Harga ',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 16.0),
                        buildDropdownFieldJK("Satuan", genders, (value) {
                          setState(() {
                            productUnit = value;
                          });
                        }),
                        SizedBox(height: 16.0),
                        buildTextField(
                            "Harga Satuan", "Masukkan Harga", productPrice,
                            keyboardType: TextInputType.number,
                            inputFormatters: [CurrencyInputFormatter()]),
                        SizedBox(height: 16.0),
                        buildTextField("Diskon %", "Masukkan Diskon %",
                            productDiscountPercentage,
                            keyboardType: TextInputType.number),
                        SizedBox(height: 16.0),
                        buildTextField(
                            "Diskon ", "Masukkan Diskon ", productDiscount,
                            keyboardType: TextInputType.number,
                            inputFormatters: [CurrencyInputFormatter()]),
                        SizedBox(height: 16.0),
                        Text(
                          'Ubah Harga',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: chipStatus.keys.map((label) {
                            return FilterChip(
                              label: Text(
                                label,
                                style: TextStyle(
                                  color: chipStatus[label]!
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              selected: chipStatus[label]!,
                              selectedColor: AppColor.secondaryColor,
                              backgroundColor: Colors.transparent,
                              checkmarkColor: Colors.white,
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: chipStatus[label]!
                                      ? Colors.transparent
                                      : AppColor.secondaryColor,
                                ),
                              ),
                              onSelected: (isSelected) {
                                setState(() {
                                  chipStatus[label] = isSelected;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                masterButton(handleAddEditProduct, "Simpan", Icons.add)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, bool> chipStatus = {
    "Qty Tetap": false,
    "Bonus": false,
    "Paket": false,
    "Stock": false,
    "Promo": false,
    "Tak Dijual": false,
  };

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

  Widget buildTypeAheadField(
      String label,
      List<KategoriDAO> items,
      ValueChanged<String?> onChanged,
      void Function(String newFilterValue) updateFilterValue,
      String company) {
    TextEditingController controllerText = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.textTitleStyle()),
        SizedBox(height: 8),
        TypeAheadField<KategoriDAO>(
          suggestionsCallback: (pattern) async {
            updateFilterValue(pattern); // Update filter
            controller.updateFilterCompanyValue(company);
            return items
                .where((item) => item.ketAnalisa
                    .toLowerCase()
                    .contains(pattern.toLowerCase()))
                .toList(); // Pencarian berdasarkan nama
          },
          builder: (context, textEditingController, focusNode) {
            controllerText = textEditingController;

            return TextField(
              controller: controllerText,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: AppColor.primaryColor),
                hintText: 'Cari Kategori...',
                hintStyle: TextStyle(color: AppColor.primaryColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColor.primaryColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primaryColor),
                ),
              ),
              onChanged: (value) {
                // Jangan lakukan apa-apa saat mengetik, biarkan saat dipilih
              },
            );
          },
          itemBuilder: (context, KategoriDAO suggestion) {
            return ListTile(
              title: Text(suggestion.ketAnalisa
                  .toString()), // Tampilkan ID sebagai info tambahan
            );
          },
          onSelected: (KategoriDAO suggestion) {
            controllerText.text = suggestion.ketAnalisa
                .toString(); // Tampilkan nama produk di field
            onChanged(suggestion.analisaId); // Simpan ID produk di _product
          },
        ),
      ],
    );
  }
}
