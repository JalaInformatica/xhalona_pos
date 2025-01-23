import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/product/product_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/add_edit_product.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';

class MasterProductScreen extends StatelessWidget {
  MasterProductScreen({super.key});

  final ProductController controller = Get.put(ProductController());
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

   Widget mButton(VoidCallback onTap, IconData icon, String label) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.secondaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Master Produk"),
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
              mButton(() {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AddEditProduct()),
                    (route) => false);
              }, Icons.add, "Add Product"),
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
              // SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: Obx(
              //       () => Wrap(
              //         spacing: 5.w,
              //         children: [
              //           transactionFilterButton(
              //             text: "Produk",
              //             onPressed: () =>
              //                 controller.updateFilterTrxStatusCategory(
              //                     TransactionStatusCategory.progress),
              //             isSelected: controller.trxStatusCategory.value ==
              //                 TransactionStatusCategory.progress,
              //           ),
              //           transactionFilterButton(
              //               text: "Varian",
              //               onPressed: () =>
              //                   controller.updateFilterTrxStatusCategory(
              //                       TransactionStatusCategory.done),
              //               isSelected: controller.trxStatusCategory.value ==
              //                   TransactionStatusCategory.done),
              //           transactionFilterButton(
              //               text: "Kategori",
              //               onPressed: () =>
              //                   controller.updateFilterTrxStatusCategory(
              //                       TransactionStatusCategory.late),
              //               isSelected: controller.trxStatusCategory.value ==
              //                   TransactionStatusCategory.late),
              //           transactionFilterButton(
              //               text: "Master All",
              //               onPressed: () =>
              //                   controller.updateFilterTrxStatusCategory(
              //                       TransactionStatusCategory.cancel),
              //               isSelected: controller.trxStatusCategory.value ==
              //                   TransactionStatusCategory.cancel),
              //         ],
              //       ),
              //     )),
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
                                '${product.isFixPrice == 'true' ? 'Iya' : 'Tidak'}',
                            index: i),
                        AppTableCell(
                            value:
                                '${product.isFree == 'true' ? 'Iya' : 'Tidak'}',
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
                                        String result =
                                            await _productRepository
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
