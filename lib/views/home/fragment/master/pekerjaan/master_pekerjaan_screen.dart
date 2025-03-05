import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/models/dao/pekerjaan.dart';
import 'package:xhalona_pos/widgets/app_bottombar.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/pekerjaan/pekerjaan_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/pekerjaan/add_edit_pekerjaan.dart';
import 'package:xhalona_pos/views/home/fragment/master/pekerjaan/pekerjaan_controller.dart';

// ignore: must_be_immutable
class MasterPekerjaanScreen extends StatelessWidget {
  MasterPekerjaanScreen({super.key});

  final PekerjaanController controller = Get.put(PekerjaanController());
  PekerjaanRepository _pekerjaanRepository = PekerjaanRepository();

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
                    MaterialPageRoute(builder: (context) => AddEditPekerjaan()),
                    (route) => false);
              }, 'Add Pekerjaan', Icons.add, double.infinity),
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
                      AppTableTitle(value: "Kode Pekerjaan"),
                      AppTableTitle(value: "Nama Pekerjaan"),
                      AppTableTitle(value: "Aksi"),
                    ],
                    data: List.generate(controller.pekerjaanHeader.length,
                        (int i) {
                      var pekerjaan = controller.pekerjaanHeader[i];
                      return [
                        AppTableCell(
                            value: pekerjaan.jobId,
                            index: i,
                            onEdit: () {
                              goTo(context, pekerjaan);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  pekerjaan.jobId, pekerjaan.jobDesc);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: pekerjaan.jobDesc,
                            index: i,
                            onEdit: () {
                              goTo(context, pekerjaan);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  pekerjaan.jobId, pekerjaan.jobDesc);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                          index: i,
                          onEdit: () {
                            goTo(context, pekerjaan);
                          },
                          onDelete: () async {
                            await messageHapus(
                                pekerjaan.jobId, pekerjaan.jobDesc);
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
        ));
  }

  Future<dynamic> messageHapus(String jobId, String jobDesc) {
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
            "Apakah Anda yakin ingin menghapus data '$jobDesc'?",
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
                    await _pekerjaanRepository.deletePekerjaan(jobId: jobId);

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

  Future<dynamic> goTo(BuildContext context, PekerjaanDAO pekerjaan) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => AddEditPekerjaan(pekerjaan: pekerjaan)),
        (route) => false);
  }
}
