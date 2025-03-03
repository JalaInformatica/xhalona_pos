import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/models/dao/kasbank.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/kasbank/kasbank_repository.dart';
import 'package:xhalona_pos/views/home/fragment/finance/add_edit_finance.dart';
import 'package:xhalona_pos/views/home/fragment/finance/finance_controller.dart';

// ignore: must_be_immutable
class FinanceScreen extends StatelessWidget {
  FinanceScreen({super.key});

  final FinanceController controller = Get.put(FinanceController());
  KasBankRepository _financeRepository = KasBankRepository();

  Widget mButton(
      VoidCallback onTap, String label, IconData icon, double? width) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.primaryColor, // Background color
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

  Future<dynamic> messageHapus(String acId, String ket) {
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
            "Apakah Anda yakin ingin menghapus data '$ket'?",
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
                    await _financeRepository.deleteKasBank(voucherNo: acId);

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

  Future<dynamic> goTo(BuildContext context, KasBankDAO finance) {
    return Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => AddEditFinance(finance: finance)));
  }

  String getLastFourDigits(String voucherNo) {
    if (voucherNo.length >= 4) {
      return voucherNo.substring(voucherNo.length - 4);
    } else {
      return voucherNo; // Jika string kurang dari 4 karakter, kembalikan seluruh string
    }
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
              AppElevatedButton(
                foregroundColor: AppColor.primaryColor,
                backgroundColor: AppColor.whiteColor,
                onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddEditFinance()));
              }, 
              icon: Icons.add, 
              child: Text("Catatan Keuangan Baru", style: AppTextStyle.textSubtitleStyle(),),),
              SizedBox(
                height: 10.h,
              ),
              Obx(() => Flexible(
                      child: AppTable(
                    onSearch: (filterValue) =>
                        controller.updateFilterValue(filterValue),
                    onChangePageNo: (pageNo) => controller.updatePageNo(pageNo),
                    onChangePageRow: (pageRow) =>
                        controller.updatePageRow(pageRow),
                    pageNo: controller.pageNo.value,
                    pageRow: controller.pageRow.value,
                    titles: [
                      AppTableTitle(value: "Trx "),
                      AppTableTitle(value: "Tanggal "),
                      AppTableTitle(value: "M/K"),
                      AppTableTitle(value: "Jenis Byr"),
                      AppTableTitle(value: "Supplier"),
                      AppTableTitle(value: "Ket"),
                      AppTableTitle(value: "Jumlah"),
                      AppTableTitle(value: "Post"),
                      AppTableTitle(value: "Open"),
                    ],
                    data:
                        List.generate(controller.financeHeader.length, (int i) {
                      var finance = controller.financeHeader[i];
                      return [
                        AppTableCell(
                            value: getLastFourDigits(finance.voucherNo),
                            index: i,
                            onEdit: () {
                              goTo(context, finance);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: DateFormat('dd-MM-yyyy')
                                .format(DateTime.parse(finance.voucherDate)),
                            index: i,
                            onEdit: () {
                              goTo(context, finance);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: finance.jenisAc == "M" ? "Masuk" : finance.jenisAc == "K"? "Keluar" : "",
                            index: i,
                            onEdit: () {
                              goTo(context, finance);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: finance.namaAc,
                            index: i,
                            onEdit: () {
                              goTo(context, finance);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: finance.refName,
                            index: i,
                            onEdit: () {
                              goTo(context, finance);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: finance.ket,
                            index: i,
                            onEdit: () {
                              goTo(context, finance);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: formatCurrency(finance.jmlBayar),
                            index: i,
                            onEdit: () {
                              goTo(context, finance);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: '',
                            index: i,
                            isPost: finance.isApproved,
                            onEdit: () {
                              goTo(context, finance);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                          index: i,

                          value: "", // Ganti dengan URL gambar jika ada
                          isEdit: true,
                          onEdit: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => AddEditFinance(
                                          finance: finance,
                                        )));
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
