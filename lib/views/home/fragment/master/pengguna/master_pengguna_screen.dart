import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/models/response/pengguna.dart';
import 'package:xhalona_pos/widgets/app_bottombar.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/pengguna/pengguna_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/pengguna/add_edit_pengguna.dart';
import 'package:xhalona_pos/views/home/fragment/master/pengguna/pengguna_controller.dart';

// ignore: must_be_immutable
class MasterPenggunaScreen extends StatelessWidget {
  MasterPenggunaScreen({super.key});

  final PenggunaController controller = Get.put(PenggunaController());
  PenggunaRepository _penggunaRepository = PenggunaRepository();

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
                    MaterialPageRoute(builder: (context) => AddEditPengguna()),
                    (route) => false);
              }, Icons.add, "Add Pengguna"),
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
                      AppTableTitle(value: "UserId"),
                      AppTableTitle(value: "UserName"),
                      AppTableTitle(value: "Email"),
                      AppTableTitle(value: "Level"),
                      AppTableTitle(value: "Departemen"),
                      AppTableTitle(value: "Role"),
                      AppTableTitle(value: "Aksi"),
                    ],
                    data: List.generate(controller.penggunaHeader.length,
                        (int i) {
                      var pengguna = controller.penggunaHeader[i];
                      return [
                        AppTableCell(
                            value: pengguna.userId,
                            index: i,
                            onEdit: () {
                              goTo(context, pengguna);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  pengguna.memberId, pengguna.memberId);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: pengguna.userName,
                            index: i,
                            onEdit: () {
                              goTo(context, pengguna);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  pengguna.memberId, pengguna.memberId);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: pengguna.emailAddress,
                            index: i,
                            onEdit: () {
                              goTo(context, pengguna);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  pengguna.memberId, pengguna.memberId);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: "${pengguna.levelId}",
                            index: i,
                            onEdit: () {
                              goTo(context, pengguna);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  pengguna.memberId, pengguna.memberId);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: pengguna.deptId!,
                            index: i,
                            onEdit: () {
                              goTo(context, pengguna);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  pengguna.memberId, pengguna.memberId);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: "${pengguna.roleId}",
                            index: i,
                            onEdit: () {
                              goTo(context, pengguna);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  pengguna.memberId, pengguna.memberId);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                          index: i,
                          onEdit: () {
                            goTo(context, pengguna);
                          },
                          onDelete: () async {
                            await messageHapus(
                                pengguna.memberId, pengguna.userName);
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
        ),
      );
  }

  Future<dynamic> messageHapus(String memberId, String userName) {
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
            "Apakah Anda yakin ingin menghapus data '$memberId'?",
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
                String result = await _penggunaRepository.deletePengguna(
                    memberId: userName);

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

  Future<dynamic> goTo(BuildContext context, PenggunaDAO pengguna) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => AddEditPengguna(pengguna: pengguna)),
        (route) => false);
  }
}
