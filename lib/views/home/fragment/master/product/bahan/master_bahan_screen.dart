import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/bahan.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/bahan/bahan_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/bahan/add_edit_bahan.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/master_product_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/bahan/bahan_controller.dart';

// ignore: must_be_immutable
class MasterBahanScreen extends StatelessWidget {
  MasterBahanScreen({super.key});

  final BahanController controller = Get.put(BahanController());
  final ProductController controllerPro = Get.put(ProductController());
  BahanRepository _bahanRepository = BahanRepository();

  Widget mButton(VoidCallback onTap, IconData icon, String label) {
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MasterProductScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        controllerPro.filterValue.value = "";
        controllerPro.fetchProducts();
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Master Bahan",
            style: AppTextStyle.textTitleStyle(),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => MasterProductScreen()),
                  (route) => false); // Jika tidak, gunakan navigator default
              controllerPro.fetchProducts();
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
                    MaterialPageRoute(
                        builder: (context) => AddEditBahan(
                              partId: controller.filterPartId.value,
                            )),
                    (route) => false);
              }, Icons.add, "Add Bahan"),
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
                      AppTableTitle(value: "Nama Bahan"),
                      AppTableTitle(value: "Unit"),
                      AppTableTitle(value: "Aksi"),
                    ],
                    data: List.generate(controller.bahanHeader.length, (int i) {
                      var bahan = controller.bahanHeader[i];
                      return [
                        AppTableCell(
                            value: bahan.bomPartName,
                            index: i,
                            onEdit: () {
                              goTo(context, bahan,
                                  controller.filterPartId.value);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  bahan.rowId.toString(), bahan.bomPartName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: bahan.unitId.toString(),
                            index: i,
                            onEdit: () {
                              goTo(context, bahan,
                                  controller.filterPartId.value);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  bahan.rowId.toString(), bahan.bomPartName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                          index: i,
                          onEdit: () {
                            goTo(context, bahan, controller.filterPartId.value);
                          },
                          onDelete: () async {
                            await messageHapus(
                                bahan.rowId.toString(), bahan.bomPartName);
                          },
                          value: "",
                          isDelete: true,
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

  Future<dynamic> messageHapus(String rowId, String cpartName) {
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
            "Apakah Anda yakin ingin menghapus data '$cpartName'?",
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
                    await _bahanRepository.deleteBahan(rowId: rowId);

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

  Future<dynamic> goTo(BuildContext context, BahanDAO bahan, String partId) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => AddEditBahan(
                  kategori: bahan,
                  partId: partId,
                )),
        (route) => false);
  }
}
