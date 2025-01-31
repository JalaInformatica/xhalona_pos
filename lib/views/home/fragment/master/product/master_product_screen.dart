import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/product/product_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/add_edit_product.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/bahan/bahan_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/paket/paket_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/m_all/master_mAll_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/paket/master_paket_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/bahan/master_bahan_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/kategori/master_kategori_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/varian/varian_group/master_varian_group_screen.dart';

// ignore: must_be_immutable
class MasterProductScreen extends StatelessWidget {
  MasterProductScreen({super.key});

  final ProductController controller = Get.put(ProductController());
  final BahanController controllerBahan = Get.put(BahanController());
  final PaketController controllerPaket = Get.put(PaketController());
  ProductRepository _productRepository = ProductRepository();

  Widget checkboxItem(String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        Text(
          title,
          style: AppTextStyle.textBodyStyle(),
        ),
      ],
    );
  }

  Widget mButton(
      VoidCallback onTap, IconData icon, String label, double width) {
    return GestureDetector(
      onTap: onTap,
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
            "Master Product",
            style: AppTextStyle.textTitleStyle(),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false); // Jika tidak, gunakan navigator default
            }, // Navigasi kembali ke halaman sebelumnya
          ),
        ),
        backgroundColor: AppColor.whiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 47,
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Scrollbar(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        mButton(() {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => MasterVarianGroupScreen(),
                            ),
                            (route) => false,
                          );
                        }, Icons.layers, "Master Varian",
                            170), // Ikon untuk varian
                        SizedBox(width: screenWidth * 0.02),
                        mButton(() {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => MasterKategoriScreen(),
                            ),
                            (route) => false,
                          );
                        }, Icons.category, "Master Kategori",
                            170), // Ikon kategori

                        SizedBox(width: screenWidth * 0.02),
                        mButton(() {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => MasterMasAllScreen(),
                            ),
                            (route) => false,
                          );
                        }, Icons.apps, "Master All",
                            170), // Ikon untuk semua item
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              mButton(() {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AddEditProduct()),
                    (route) => false);
              }, Icons.add, "Add Product", double.infinity),
              SizedBox(
                height: 5.h,
              ),
              Obx(
                () => Row(
                  children: [
                    checkboxItem("Jasa", controller.isJasa.value,
                        (_) => controller.updateFilterJasa()),
                    checkboxItem("Stock", controller.isStock.value,
                        (_) => controller.updateFilterStock()),
                    checkboxItem("Paket", controller.isPaket.value,
                        (_) => controller.updateFilterPaket()),
                    checkboxItem("Promo", controller.isPromo.value,
                        (_) => controller.updateFilterPromo()),
                    checkboxItem("Bahan", controller.isBahan.value,
                        (_) => controller.updateFilterBahan()),
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Obx(() => Expanded(
                      child: AppTable(
                    onSearch: (filterValue) =>
                        controller.updateFilterValue(filterValue),
                    onChangePageNo: (pageNo) => controller.updatePageNo(pageNo),
                    onChangePageRow: (pageRow) =>
                        controller.updatePageRow(pageRow),
                    pageNo: controller.pageNo.value,
                    pageRow: controller.pageRow.value,
                    titles: [
                      AppTableTitle(value: "ID"),
                      AppTableTitle(value: "Image"),
                      AppTableTitle(value: "Produk"),
                      AppTableTitle(value: "Kategori"),
                      AppTableTitle(value: "Ket."),
                      AppTableTitle(value: "Satuan"),
                      AppTableTitle(value: "Qty"),
                      AppTableTitle(value: "Harga"),
                      AppTableTitle(value: "Disc %"),
                      AppTableTitle(value: "Disc (Rp)"),
                      AppTableTitle(value: "Tetap"),
                      AppTableTitle(value: "Terjual Fee %"),
                      AppTableTitle(value: "Fee (Rp)"),
                      AppTableTitle(value: "Ubah Harga"),
                      AppTableTitle(value: "Free"),
                      AppTableTitle(value: "Aksi"),
                      AppTableTitle(value: ""),
                    ],
                    data:
                        List.generate(controller.productHeader.length, (int i) {
                      var product = controller.productHeader[i];
                      return [
                        AppTableCell(value: product.partId, index: i),
                        AppTableCell(
                          value: product.mainImage,
                          index: i,
                          imageUrl:
                              'https://dreadnought.core-erp.com/XHALONA/${product.mainImage}',
                        ),
                        AppTableCell(value: product.partName, index: i),
                        AppTableCell(value: product.analisaId, index: i),
                        AppTableCell(value: product.ketAnalisa, index: i),
                        AppTableCell(value: product.unit1, index: i),
                        AppTableCell(value: '${product.qtyPerUnit1}', index: i),
                        AppTableCell(
                            value: '${product.unitPriceNet}', index: i),
                        AppTableCell(value: '${product.discountPct}', index: i),
                        AppTableCell(value: '${product.discountVal}', index: i),
                        AppTableCell(value: '${product.unitPrice}', index: i),
                        AppTableCell(
                            value: '${product.employeeFeePct}', index: i),
                        AppTableCell(
                            value: '${product.employeeFeeVal}', index: i),
                        AppTableCell(
                            value:
                                '${product.isFixPrice == true ? 'Iya' : 'Tidak'}',
                            index: i),
                        AppTableCell(
                            value:
                                '${product.isFree == true ? 'Iya' : 'Tidak'}',
                            index: i),
                        AppTableCell(
                          index: i,
                          value: "", // Ganti dengan URL gambar jika ada
                          isEdit: true,
                          isDelete: true,
                          onEdit: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => AddEditProduct(
                                          product: product,
                                        )),
                                (route) => false);
                          },
                          onDelete: () async {
                            await SmartDialog.show(builder: (context) {
                              return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  icon: const Icon(
                                    Icons.info_outlined,
                                    color: AppColor.primaryColor,
                                  ),
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    "Konfirmasi",
                                    style: AppTextStyle.textTitleStyle(
                                        color: AppColor.primaryColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Text(
                                    "Apakah Anda yakin ingin menghapus data '${product.partName}'?",
                                    maxLines: 2,
                                    style: AppTextStyle.textSubtitleStyle(),
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        SmartDialog.dismiss(result: false);
                                      },
                                      child: Text(
                                        "Tidak",
                                        style: AppTextStyle.textBodyStyle(
                                            color: AppColor.grey500),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        String result = await _productRepository
                                            .deleteProduct(
                                                partId: product.partId);

                                        bool isSuccess = result == "1";
                                        if (isSuccess) {
                                          SmartDialog.dismiss(result: false);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Data gagal dihapus!')),
                                          );
                                        } else {
                                          SmartDialog.dismiss(result: false);
                                          controller.fetchProducts();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Data berhasil dihapus!')),
                                          );
                                        }
                                      },
                                      child: Text(
                                        "Iya",
                                        style: AppTextStyle.textBodyStyle(
                                            color: AppColor.primaryColor),
                                      ),
                                    )
                                  ]);
                            });
                          },
                        ),
                        AppTableCell(
                          index: i,
                          value: "",
                          isBahan: product.isFixQty == true ? true : false,
                          isPaket: product.isPacket == true ? true : false,
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                        )
                      ];
                    }),
                    onRefresh: () => controller.fetchProducts(),
                    isRefreshing: controller.isLoading.value,
                  )))
            ],
          ),
        ),
      ),
    );
  }
}
