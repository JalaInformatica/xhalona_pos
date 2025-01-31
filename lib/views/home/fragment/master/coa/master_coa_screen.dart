import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/coa/coa_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/coa/add_edit_coa.dart';
import 'package:xhalona_pos/views/home/fragment/master/coa/coa_controller.dart';

// ignore: must_be_immutable
class MasterCoaScreen extends StatelessWidget {
  MasterCoaScreen({super.key});

  final CoaController controller = Get.put(CoaController());
  CoaRepository _coaRepository = CoaRepository();

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
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Master Coa",
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
                    MaterialPageRoute(builder: (context) => AddEditCoa()),
                    (route) => false);
              }, Icons.add, "Add Coa"),
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
                        AppTableCell(value: coa.acId, index: i),
                        AppTableCell(value: coa.namaRekening, index: i),
                        AppTableCell(value: coa.jenisRek, index: i),
                        AppTableCell(value: coa.flagDk, index: i),
                        AppTableCell(value: coa.flagTm!, index: i),
                        AppTableCell(
                          index: i,
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
                                    "Apakah Anda yakin ingin menghapus data '${coa.namaRekening}'?",
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
                                        String result = await _coaRepository
                                            .deleteCoa(accId: coa.acId);

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
