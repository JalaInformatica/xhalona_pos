import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/widgets/app_bottombar.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/models/dao/kasbankdetail.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/kasbank/kasbankdetail_repository.dart';
import 'package:xhalona_pos/views/home/fragment/finance/kasbankdetail/edit_kasbankdetail.dart';
import 'package:xhalona_pos/views/home/fragment/finance/kasbankdetail/kasbankdetail_controller.dart';

// ignore: must_be_immutable
class KasBankDetailScreen extends StatelessWidget {
  bool? approve;
  KasBankDetailScreen({super.key, this.approve});

  final KasBankDetailController controller = Get.put(KasBankDetailController());
  KasBankDetailRepository _kasbankdetailRepository = KasBankDetailRepository();

  Future<dynamic> messageHapus(int rowId, String detVoucherNo) {
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
            "Apakah Anda yakin ingin menghapus data '$detVoucherNo'?",
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
                String result = await _kasbankdetailRepository
                    .deleteKasBankDetail(rowId: rowId, voucerNo: detVoucherNo);

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

  Future<dynamic> goTo(BuildContext context, KasBankDetailDAO kasbankdetail) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                AddEditKasBankDetail(kasbankdetail: kasbankdetail)),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kas Bank Detail",
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
            mButton(() {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => AddEditKasBankDetail(
                          noTrx: controller.vocherNo.value)),
                  (route) => false);
            }, "Add Kas Bank Detail", Icons.add, double.infinity,
                disable: approve ?? false),
            SizedBox(
              height: 5.h,
            ),
            Obx(
              () => Expanded(
                  child: AppTable(
                onSearch: (filterValue) =>
                    controller.updateFilterValue(filterValue),
                onChangePageNo: (pageNo) => controller.updatePageNo(pageNo),
                onChangePageRow: (pageRow) => controller.updatePageRow(pageRow),
                pageNo: controller.pageNo.value,
                pageRow: controller.pageRow.value,
                titles: [
                  AppTableTitle(value: "Keterangan "),
                  AppTableTitle(value: "Rekening (COA) "),
                  AppTableTitle(value: "Qty"),
                  AppTableTitle(value: "Harga"),
                  AppTableTitle(value: "D/K"),
                  AppTableTitle(value: "Aksi"),
                ],
                data: List.generate(controller.kbdetailHeader.length, (int i) {
                  var kasbankdetail = controller.kbdetailHeader[i];
                  return [
                    AppTableCell(
                        value: kasbankdetail.uraianDet,
                        index: i,
                        onEdit: () {
                          goTo(context, kasbankdetail);
                        },
                        onDelete: () async {
                          await messageHapus(
                              kasbankdetail.rowId, kasbankdetail.detVoucherNo);
                        },
                        showOptionsOnTap: true),
                    AppTableCell(
                        value:
                            '${kasbankdetail.acId} - ${kasbankdetail.namaRek}',
                        index: i,
                        onEdit: () {
                          goTo(context, kasbankdetail);
                        },
                        onDelete: () async {
                          await messageHapus(
                              kasbankdetail.rowId, kasbankdetail.detVoucherNo);
                        },
                        showOptionsOnTap: true),
                    AppTableCell(
                        value: kasbankdetail.qty.toString(),
                        index: i,
                        onEdit: () {
                          goTo(context, kasbankdetail);
                        },
                        onDelete: () async {
                          await messageHapus(
                              kasbankdetail.rowId, kasbankdetail.detVoucherNo);
                        },
                        showOptionsOnTap: true),
                    AppTableCell(
                        value: formatCurrency(kasbankdetail.priceUnit),
                        index: i,
                        onEdit: () {
                          goTo(context, kasbankdetail);
                        },
                        onDelete: () async {
                          await messageHapus(
                              kasbankdetail.rowId, kasbankdetail.detVoucherNo);
                        },
                        showOptionsOnTap: true),
                    AppTableCell(
                        value: kasbankdetail.flagDK,
                        index: i,
                        onEdit: () {
                          goTo(context, kasbankdetail);
                        },
                        onDelete: () async {
                          await messageHapus(
                              kasbankdetail.rowId, kasbankdetail.detVoucherNo);
                        },
                        showOptionsOnTap: true),
                    AppTableCell(
                      index: i,
                      onDelete: () async {
                        await messageHapus(
                            kasbankdetail.rowId, kasbankdetail.detVoucherNo);
                      },
                      value: "", // Ganti dengan URL gambar jika ada
                      isEdit: approve == true ? false : true,
                      isDelete: approve == true ? false : true,
                      onEdit: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => AddEditKasBankDetail(
                                      kasbankdetail: kasbankdetail,
                                    )),
                            (route) => false);
                      },
                    ),
                  ];
                }),
                onRefresh: () => controller.fetchProducts(),
                isRefreshing: controller.isLoading.value,
              )),
            )
          ],
        ),
      ),
    );
  }
}
