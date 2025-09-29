import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/models/response/coa.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/coa/coa_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/coa/add_edit_coa.dart';
import 'package:xhalona_pos/views/home/fragment/master/coa/coa_controller.dart';

// ignore: must_be_immutable
class MasterCoaScreen extends StatelessWidget {
  MasterCoaScreen({super.key});

  final CoaController controller = Get.put(CoaController());
  CoaRepository _coaRepository = CoaRepository();

  Widget mButton(
      VoidCallback onTap, String label, IconData icon, double? width) {
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

  Future<dynamic> messageHapus(String acId, String namaRekening) {
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
            "Apakah Anda yakin ingin menghapus data '$namaRekening'?",
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
                String result = await _coaRepository.deleteCoa(accId: acId);

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

  Future<dynamic> goTo(BuildContext context, CoaDAO coa) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AddEditCoa(coa: coa)),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  MaterialPageRoute(builder: (context) => AddEditCoa()),
                  (route) => false);
            }, "Add Coa", Icons.add, double.infinity),
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
                  AppTableTitle(value: "Kode "),
                  AppTableTitle(value: "Nama "),
                  AppTableTitle(value: "jenis"),
                  AppTableTitle(value: "D/K"),
                  AppTableTitle(value: "TM"),
                  AppTableTitle(value: "Aksi"),
                ],
                data: List.generate(controller.coaHeader.length, (int i) {
                  var coa = controller.coaHeader[i];
                  return [
                    AppTableCell(
                        value: coa.acId,
                        index: i,
                        onEdit: () {
                          goTo(context, coa);
                        },
                        onDelete: () async {
                          await messageHapus(coa.acId, coa.namaRekening);
                        },
                        showOptionsOnTap: true),
                    AppTableCell(
                        value: coa.namaRekening,
                        index: i,
                        onEdit: () {
                          goTo(context, coa);
                        },
                        onDelete: () async {
                          await messageHapus(coa.acId, coa.namaRekening);
                        },
                        showOptionsOnTap: true),
                    AppTableCell(
                        value: coa.jenisRek,
                        index: i,
                        onEdit: () {
                          goTo(context, coa);
                        },
                        onDelete: () async {
                          await messageHapus(coa.acId, coa.namaRekening);
                        },
                        showOptionsOnTap: true),
                    AppTableCell(
                        value: coa.flagDk,
                        index: i,
                        onEdit: () {
                          goTo(context, coa);
                        },
                        onDelete: () async {
                          await messageHapus(coa.acId, coa.namaRekening);
                        },
                        showOptionsOnTap: true),
                    AppTableCell(
                        value: coa.flagTm!,
                        index: i,
                        onEdit: () {
                          goTo(context, coa);
                        },
                        onDelete: () async {
                          await messageHapus(coa.acId, coa.namaRekening);
                        },
                        showOptionsOnTap: true),
                    AppTableCell(
                      index: i,
                      onDelete: () async {
                        await messageHapus(coa.acId, coa.namaRekening);
                      },
                      value: "", // Ganti dengan URL gambar jika ada
                      isEdit: true,
                      isDelete: true,
                      onEdit: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => AddEditCoa(
                                      coa: coa,
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
