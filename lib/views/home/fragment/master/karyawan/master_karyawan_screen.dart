import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/karyawan_controller.dart';

class MasterKaryawanScreen extends StatelessWidget {
  MasterKaryawanScreen({super.key});

  final KaryawanController controller = Get.put(KaryawanController());

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
          title: Text("Master Karyawan"),
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
                            print("Edit tapped");
                          },
                          onDelete: () {
                            print("Delete tapped");
                          },
                          onAdd: () {
                            print("Add tapped");
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
