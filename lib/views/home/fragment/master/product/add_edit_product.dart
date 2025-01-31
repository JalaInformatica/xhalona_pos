import 'dart:io';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/models/dao/kategori.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xhalona_pos/services/user/user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xhalona_pos/repositories/kategori_repository.dart';
import 'package:xhalona_pos/repositories/product/product_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/master_product_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/kategori/kategori_controller.dart';

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
  List<String> categories = ['Kategori 1', 'Kategori 2', 'Kategori 3'];
  String? selectedCategory;
  String? selectedGlobalCategory;

  // Variables for input fields
  String? productName;
  String? productDescription;
  String? productUnit;
  double? productPrice;
  double? productDiscountPercentage;
  int? productDiscount;
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
      selectedCategory = widget.product?.analisaId;
      selectedGlobalCategory = widget.product?.analisaIdGlobal;
      productName = widget.product?.partName;
      productDescription = widget.product?.spec;
      productUnit = widget.product?.unit1;
      productPrice = widget.product?.unitPriceNet.toDouble();
      productDiscountPercentage = widget.product?.discountPct.toDouble();
      productDiscount = widget.product?.discountVal;
      chipStatus['Qty Tetap'] = widget.product?.isFixQty ?? false;
      chipStatus['Bonus'] = widget.product?.isNonSales ?? false;
      chipStatus['Paket'] = widget.product?.isPacket ?? false;
      chipStatus['Stock'] = widget.product?.isStock ?? false;
      chipStatus['Promo'] = widget.product?.isPromo ?? false;
      chipStatus['Tak Dijual'] = widget.product?.isFixPrice ?? false;
    }
  }

  Future<void> inisiasi() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImageUrl = prefs.getString('profileImageUrl');
      controller.kategoriHeader;
      controller.kategoriGlobalHeader;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleAddEditProduct() async {
      if (_formKey.currentState!.validate()) {
        String result = await _productRepository.addEditProduct(
          analisaId: selectedCategory,
          analisaIdGlobal: selectedGlobalCategory,
          partId: widget.product?.partId,
          partName: productName,
          deskripsi: productDescription,
          unit1: productUnit,
          unitPrice: productPrice?.toInt(),
          discPct: productDiscountPercentage?.toInt(),
          discVal: productDiscount,
          isFixQty: chipStatus['Qty Tetap'] == true ? 1 : 0,
          isFixPrice: chipStatus['Bonus'] == true ? 1 : 0,
          isPacket: chipStatus['Paket'] == true ? 1 : 0,
          isStock: chipStatus['Stock'] == true ? 1 : 0,
          isPromo: chipStatus['Promo'] == true ? 1 : 0,
          isFree: chipStatus['Tak Dijual'] == true ? 1 : 0,
          mainImage: profileImageUrl,
          thumbImage: profileImageUrl,
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
            MaterialPageRoute(builder: (context) => MasterProductScreen()),
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
            MaterialPageRoute(builder: (context) => MasterProductScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah/Edit Data Product",
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
                        Obx(() {
                          return buildDropdownField(
                            "Kategori",
                            controller.kategoriHeader,
                            (value) {
                              setState(() {
                                _kategori = value;
                              });
                            },
                          );
                        }),
                        SizedBox(height: 16),
                        Obx(() {
                          return buildDropdownField(
                            "Kategori Global",
                            controller.kategoriGlobalHeader,
                            (value) {
                              setState(() {
                                _kategoriGlobal = value;
                              });
                            },
                          );
                        }),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nama Produk',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: widget.product?.partName,
                          onChanged: (value) => productName = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan nama produk';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Deskripsi',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: widget.product?.spec,
                          maxLines: 3,
                          onChanged: (value) => productDescription = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Deskripsi harus di isi';
                            }
                            return null;
                          },
                        ),
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
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: AppColor.primaryColor,
                                  width: 4,
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://dreadnought.core-erp.com/XHALONA/${profileImageUrl}',
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
                                  child: const Icon(Icons.error,
                                      color: Colors.redAccent),
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
                          'Satuan & Harga',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 16.0),
                        buildDropdownFieldJK("Satuan", genders, (value) {
                          setState(() {
                            productUnit = value;
                          });
                        }),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Harga Satuan',
                            hintText: '0',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: widget.product?.unitPriceNet.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              productPrice = double.tryParse(value ?? '0'),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Diskon %',
                            hintText: '0',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: widget.product?.discountPct.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => productDiscountPercentage =
                              double.tryParse(value ?? '0'),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Diskon',
                            hintText: 'Masukkan Diskon',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: widget.product?.discountVal.toString(),
                          onChanged: (value) => productDiscount = value as int?,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Ubah Harga',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: chipStatus.keys.map((label) {
                            return FilterChip(
                              label: Text(label),
                              selected: chipStatus[label]!,
                              selectedColor: AppColor.secondaryColor,
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

  Widget masterButton(VoidCallback onPressed, String label, IconData icon) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.secondaryColor, // Background color
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

  Widget buildDropdownField(
      String label, List<KategoriDAO> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
            value: item.analisaId, child: Text(item.ketAnalisa));
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
