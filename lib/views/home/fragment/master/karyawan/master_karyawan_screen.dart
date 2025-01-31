import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/karyawan/karyawan_repository.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/add_edit_karyawan.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/karyawan_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/departemen/master_departemen_screen.dart';

// ignore: must_be_immutable
class MasterKaryawanScreen extends StatelessWidget {
  MasterKaryawanScreen({super.key});

  final KaryawanController controller = Get.put(KaryawanController());
  KaryawanRepository _karyawanRepository = KaryawanRepository();

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
            "Master Karyawan",
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
                        builder: (context) => MasterDepartemenScreen()),
                    (route) => false);
              }, Icons.add_home_work, "Departement"),
              SizedBox(
                height: 5.h,
              ),
              mButton(() {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AddEditKaryawan()),
                    (route) => false);
              }, Icons.add, "Add Karyawan"),
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
                      AppTableTitle(value: "NIK"),
                      AppTableTitle(value: "Nama"),
                      AppTableTitle(value: "Tgl Masuk"),
                      AppTableTitle(value: "BPJS Kes"),
                      AppTableTitle(value: "BPJS Ket."),
                      AppTableTitle(value: "JK"),
                      AppTableTitle(value: "Tgl Lahir"),
                      AppTableTitle(value: "Alamat"),
                      AppTableTitle(value: "Bagian"),
                      AppTableTitle(value: "Bonus"),
                      AppTableTitle(value: "Target"),
                      AppTableTitle(value: "Aksi"),
                    ],
                    data: List.generate(controller.karyawanHeader.length,
                        (int i) {
                      var karyawan = controller.karyawanHeader[i];
                      return [
                        AppTableCell(value: karyawan.empId, index: i),
                        AppTableCell(value: karyawan.fullName, index: i),
                        AppTableCell(
                            value: karyawan.dateIn.split("T").first, index: i),
                        AppTableCell(value: karyawan.bpjsNo, index: i),
                        AppTableCell(value: '${karyawan.bpjsTk}', index: i),
                        AppTableCell(
                            value:
                                '${karyawan.gender == 1 ? 'Laki-laki' : 'Perempuan'}',
                            index: i),
                        AppTableCell(
                            value: karyawan.birthDate!.split("T").first,
                            index: i),
                        AppTableCell(value: '${karyawan.alamat}', index: i),
                        AppTableCell(value: '${karyawan.kd_dept}', index: i),
                        AppTableCell(
                            value: formatCurrency(karyawan.bonusAmount),
                            index: i),
                        AppTableCell(
                            value: formatCurrency(karyawan.bonusAmount),
                            index: i),
                        AppTableCell(
                          index: i,
                          value: "", // Ganti dengan URL gambar jika ada
                          isEdit: true,
                          isDelete: true,
                          onEdit: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => AddEditKaryawan(
                                          karyawan: karyawan,
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
                                    "Apakah Anda yakin ingin menghapus data '${karyawan.fullName}'?",
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
                                            await _karyawanRepository
                                                .deleteKaryawan(
                                                    empId: karyawan.empId);

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
