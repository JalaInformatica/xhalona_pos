import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/models/response/metodebayar.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/metodebayar/metodebayar_repository.dart';
import 'package:xhalona_pos/views/home/fragment/finance/metodebayar/add_edit_metodebayar.dart';
import 'package:xhalona_pos/views/home/fragment/finance/metodebayar/metodebayar_controller.dart';

// ignore: must_be_immutable
class MetodeBayarScreen extends StatelessWidget {
  MetodeBayarScreen({super.key});

  final MetodeBayarController controller = Get.put(MetodeBayarController());
  MetodeBayarRepository _metodebayarRepository = MetodeBayarRepository();

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

  Future<dynamic> messageHapus(String payMethodeId, String namaRekening) {
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
                String result = await _metodebayarRepository.deleteMetodeBayar(
                    payMethodeId: payMethodeId);

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

  Future<dynamic> goTo(BuildContext context, MetodeBayarDAO metodebayar) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => AddEditMetodeBayar(metodebayar: metodebayar)),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Metode Bayar",
            style: AppTextStyle.textTitleStyle(color: AppColor.whiteColor),
          ),
          backgroundColor: AppColor.primaryColor,
          leading: AppIconButton(
            foregroundColor: AppColor.whiteColor,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }, 
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
              AppElevatedButton(
                onPressed: () {
                 Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => AddEditMetodeBayar()),
                    (route) => false);
              }, 
              backgroundColor: AppColor.primaryColor,
              foregroundColor: AppColor.whiteColor,
              icon: Icons.add, 
              child: Text("Tambah Metode Bayar", style: AppTextStyle.textSubtitleStyle(),)
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
                      AppTableTitle(value: "Metode Pembayaran"),
                      AppTableTitle(value: "Jenis Metode Pembayaran"),
                      AppTableTitle(value: "Debit"),
                      AppTableTitle(value: "Cash"),
                      AppTableTitle(value: "Otomatis"),
                      AppTableTitle(value: "Sesuai Tagihan"),
                      AppTableTitle(value: "Kurang dari Tagihan"),
                      AppTableTitle(value: "Hutang"),
                      AppTableTitle(value: "Kartu"),
                      AppTableTitle(value: "Aksi"),
                    ],
                    data: List.generate(controller.metodebayarHeader.length,
                        (int i) {
                      var metodebayar = controller.metodebayarHeader[i];
                      return [
                        AppTableCell(
                            value: metodebayar.payMetodeName,
                            index: i,
                            onEdit: () {
                              goTo(context, metodebayar);
                            },
                            onDelete: () async {
                              await messageHapus(metodebayar.payMetodeId,
                                  metodebayar.payMetodeName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: metodebayar.payMetodeGroup,
                            index: i,
                            onEdit: () {
                              goTo(context, metodebayar);
                            },
                            onDelete: () async {
                              await messageHapus(metodebayar.payMetodeId,
                                  metodebayar.payMetodeName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: metodebayar.isCard == true ? 'Ya' : 'Tidak',
                            index: i,
                            onEdit: () {
                              goTo(context, metodebayar);
                            },
                            onDelete: () async {
                              await messageHapus(metodebayar.payMetodeId,
                                  metodebayar.payMetodeName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: metodebayar.isCash == true ? 'Ya' : 'Tidak',
                            index: i,
                            onEdit: () {
                              goTo(context, metodebayar);
                            },
                            onDelete: () async {
                              await messageHapus(metodebayar.payMetodeId,
                                  metodebayar.payMetodeName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value:
                                metodebayar.isDefault == true ? 'Ya' : 'Tidak',
                            index: i,
                            onEdit: () {
                              goTo(context, metodebayar);
                            },
                            onDelete: () async {
                              await messageHapus(metodebayar.payMetodeId,
                                  metodebayar.payMetodeName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value:
                                metodebayar.isFixHmt == true ? 'Ya' : 'Tidak',
                            index: i,
                            onEdit: () {
                              goTo(context, metodebayar);
                            },
                            onDelete: () async {
                              await messageHapus(metodebayar.payMetodeId,
                                  metodebayar.payMetodeName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: metodebayar.isBellowHmt == true
                                ? 'Ya'
                                : 'Tidak',
                            index: i,
                            onEdit: () {
                              goTo(context, metodebayar);
                            },
                            onDelete: () async {
                              await messageHapus(metodebayar.payMetodeId,
                                  metodebayar.payMetodeName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: 'Tidak',
                            index: i,
                            onEdit: () {
                              goTo(context, metodebayar);
                            },
                            onDelete: () async {
                              await messageHapus(metodebayar.payMetodeId,
                                  metodebayar.payMetodeName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: 'Tidak',
                            index: i,
                            onEdit: () {
                              goTo(context, metodebayar);
                            },
                            onDelete: () async {
                              await messageHapus(metodebayar.payMetodeId,
                                  metodebayar.payMetodeName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                          index: i,
                          onDelete: () async {
                            await messageHapus(metodebayar.payMetodeId,
                                metodebayar.payMetodeName);
                          },
                          value: "", // Ganti dengan URL gambar jika ada
                          isEdit: true,
                          isDelete: true,
                          onEdit: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => AddEditMetodeBayar(
                                          metodebayar: metodebayar,
                                        )),
                                (route) => false);
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
    );
  }
}
