import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/globals/product/models/product.dart';
import 'package:xhalona_pos/widgets/app_bottombar.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/globals/product/repositories/product_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/add_edit_product.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/bahan/bahan_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/paket/paket_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/m_all/master_mAll_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/paket/master_paket_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/bahan/master_bahan_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/varian/master_varian_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/kategori/master_kategori_screen.dart';

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
    VoidCallback onTap,
    String label,
    IconData icon,
  ) {
    return AppElevatedButton(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      onPressed: onTap,
      foregroundColor: AppColor.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColor.primaryColor,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(label,
              style:
                  AppTextStyle.textSubtitleStyle(color: AppColor.primaryColor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
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
                child: Row(
                  children: [
                    mButton(() {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MasterVarianScreen(),
                      ));
                    }, "Varian", Icons.layers),
                    SizedBox(width: screenWidth * 0.02),
                    mButton(
                      () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MasterKategoriScreen(),
                        ));
                      },
                      "Kategori",
                      Icons.category,
                    ), // Ikon kategori

                    SizedBox(width: screenWidth * 0.02),
                    mButton(
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MasterMasAllScreen(),
                          ),
                        );
                      },
                      "Semua",
                      Icons.apps,
                    ), // Ikon untuk semua item
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              AppElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddEditProduct()));
                  },
                  foregroundColor: AppColor.primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: AppColor.primaryColor,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text("Add Product",
                          style: AppTextStyle.textSubtitleStyle(
                              color: AppColor.primaryColor)),
                    ],
                  )),
              SizedBox(
                height: 5.h,
              ),
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      checkboxItem("Publish", controller.isPublish.value,
                          (_) => controller.updateFilterPublish()),
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
                        AppTableCell(
                          value: product.partId,
                          index: i,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onPaket: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                            value: '',
                            index: i,
                            isModalBahan:
                                product.isFixQty == true ? true : false,
                            isModalPaket:
                                product.isPacket == true ? true : false,
                            onEdit: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => AddEditProduct(
                                            product: product,
                                          )),
                                  (route) => false);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  product.partId, product.partName);
                            },
                            onPaket: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => MasterPaketScreen(),
                                ),
                                (route) => false,
                              );
                              controllerPaket.filterPartId.value =
                                  product.partId;
                              controllerPaket.fetchProducts();
                            },
                            onBahan: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => MasterBahanScreen(),
                                ),
                                (route) => false,
                              );
                              controllerBahan.filterPartId.value =
                                  product.partId;
                              controllerBahan.fetchProducts();
                            },
                            showImgTap: true,
                            imageUrl:
                                'https://dreadnought.core-erp.com/XHALONA/${product.mainImage}'),
                        AppTableCell(
                          value: product.partName,
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
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
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: product.analisaId,
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
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
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: product.ketAnalisa,
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
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
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: product.unit1,
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
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
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: '${product.qtyPerUnit1}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
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
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: '${formatCurrency(product.unitPriceNet)}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
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
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: '${product.discountPct}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
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
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: '${product.discountVal}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
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
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: '${formatCurrency(product.unitPrice)}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
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
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: '${product.employeeFeePct}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
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
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: '${product.employeeFeeVal}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
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
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value:
                              '${product.isFixPrice == true ? 'Iya' : 'Tidak'}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
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
                        ),
                        AppTableCell(
                          value: '${product.isFree == true ? 'Iya' : 'Tidak'}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
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
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          index: i,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          showOptionsOnTap: true,
                          value: "", // Ganti dengan URL gambar jika ada
                          isEdit: true,
                          isDelete: true,
                        ),
                        AppTableCell(
                          index: i,
                          isPaket: product.isFixQty == true ? true : false,
                          isBahan: product.isPacket == true ? true : false,
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
                          value: "",
                        )
                      ];
                    }),
                    onRefresh: () => controller.fetchProducts(),
                    isRefreshing: controller.isLoading.value,
                  )))
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<dynamic> goTo(BuildContext context, ProductDAO product) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => AddEditProduct(product: product)),
        (route) => false);
  }

  Future<dynamic> messageHapus(String partId, String partName) {
    return SmartDialog.show(builder: (context) {
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
            style: AppTextStyle.textTitleStyle(color: AppColor.primaryColor),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "Apakah Anda yakin ingin menghapus data '$partName'?",
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
                style: AppTextStyle.textBodyStyle(color: AppColor.grey500),
              ),
            ),
            TextButton(
              onPressed: () async {
                String result =
                    await _productRepository.deleteProduct(partId: partId);

                bool isSuccess = result == "1";
                if (isSuccess) {
                  SmartDialog.dismiss(result: false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data gagal dihapus!')),
                  );
                } else {
                  SmartDialog.dismiss(result: false);
                  controller.fetchProducts();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data berhasil dihapus!')),
                  );
                }
              },
              child: Text(
                "Iya",
                style: AppTextStyle.textBodyStyle(color: AppColor.primaryColor),
              ),
            )
          ]);
    });
  }
}
