import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/models/response/rekening.dart';
import 'package:xhalona_pos/widgets/app_bottombar.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/rekening/rekening_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/rekening/add_edit_rekening.dart';
import 'package:xhalona_pos/views/home/fragment/master/rekening/rekening_controller.dart';

// ignore: must_be_immutable
class MasterRekeningScreen extends StatelessWidget {
  MasterRekeningScreen({super.key});

  final RekeningController controller = Get.put(RekeningController());
  RekeningRepository _rekeningRepository = RekeningRepository();

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
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddEditRekening()),
                );
              }, Icons.add, "Add Rekening"),
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
                      AppTableTitle(value: "No Rek."),
                      AppTableTitle(value: "Nama Rek."),
                      AppTableTitle(value: "Nama Bank."),
                      AppTableTitle(value: "Coa."),
                      AppTableTitle(value: "Atas Nama."),
                      AppTableTitle(value: "J Rek."),
                      AppTableTitle(value: "Group"),
                      AppTableTitle(value: "Aksi"),
                    ],
                    data: List.generate(controller.rekeningHeader.length,
                        (int i) {
                      var rekening = controller.rekeningHeader[i];
                      return [
                        AppTableCell(
                            value: rekening.acNoReff!,
                            index: i,
                            onEdit: () {
                              goTo(context, rekening);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  rekening.acId, rekening.namaAc);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: rekening.namaAc,
                            index: i,
                            onEdit: () {
                              goTo(context, rekening);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  rekening.acId, rekening.namaAc);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: rekening.bankName!,
                            index: i,
                            onEdit: () {
                              goTo(context, rekening);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  rekening.acId, rekening.namaAc);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: rekening.acGL!,
                            index: i,
                            onEdit: () {
                              goTo(context, rekening);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  rekening.acId, rekening.namaAc);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: rekening.bankAcName!,
                            index: i,
                            onEdit: () {
                              goTo(context, rekening);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  rekening.acId, rekening.namaAc);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: rekening.jenisAc,
                            index: i,
                            onEdit: () {
                              goTo(context, rekening);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  rekening.acId, rekening.namaAc);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: rekening.acGroupId!,
                            index: i,
                            onEdit: () {
                              goTo(context, rekening);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  rekening.acId, rekening.namaAc);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                          index: i,
                          onEdit: () {
                            goTo(context, rekening);
                          },
                          onDelete: () async {
                            await messageHapus(rekening.acId, rekening.namaAc);
                          },
                          value: "", // Ganti dengan URL gambar jika ada
                          isEdit: true,
                          isDelete: true,
                        ),
                      ];
                    }),
                    onRefresh: () => controller.fetchProducts(),
                    isRefreshing: controller.isLoading.value,
                  )))
            ],
          ),
        )
    );
  }

  Future<dynamic> messageHapus(String acId, String namaAc) {
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
            "Apakah Anda yakin ingin menghapus data '$namaAc'?",
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
                    await _rekeningRepository.deleteKaryawan(acId: acId);

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

  Future<dynamic> goTo(BuildContext context, RekeningDAO rekening) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => AddEditRekening(rekening: rekening)),
        (route) => false);
  }
}
