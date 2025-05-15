import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/form/form_kustomer_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/supplier/supplier_controller.dart';
import 'package:xhalona_pos/widgets/app_dialog2.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_radio_text.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/kustomer/kustomer_repository.dart';

// ignore: must_be_immutable
class MasterSupplierScreen extends StatelessWidget {
  MasterSupplierScreen({super.key});

  final SupplierController controller = Get.put(SupplierController());

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  AppElevatedButton(
                    backgroundColor: AppColor.primaryColor,
                    onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => KustomerFormScreen(
                                )),
                        (route) => false);
                  }, 
                  foregroundColor: AppColor.whiteColor,
                  icon: Icons.add, 
                  child: Text("Kustomer Baru", style: AppTextStyle.textSubtitleStyle(),)),
                  AppTextButton(
                    icon: Icons.filter_alt_outlined,
                    onPressed: (){
                    SmartDialog.show(builder: (context){
                        final filterDebt = controller.filterDebt.value.obs;
                        final filterCompliment = controller.filterCompliment.value.obs;
                        return AppDialog2(
                          actions: [
                            AppTextButton(
                              borderColor: const Color.fromARGB(0, 190, 29, 29),
                              backgroundColor: AppColor.grey500,
                              foregroundColor: AppColor.whiteColor,
                              onPressed: (){
                                SmartDialog.dismiss();
                              }, 
                              child: Text("Batalkan")
                            ),
                            AppTextButton(
                              backgroundColor: AppColor.primaryColor,
                              foregroundColor: AppColor.whiteColor,
                              onPressed: (){
                                controller.updateFilterDialog(
                                  newFilterCompliment: filterCompliment.value,
                                  newFilterDebt: filterDebt.value,
                                );
                                SmartDialog.dismiss();
                              }, 
                              child: Text("Terapkan")
                            )
                          ],
                          child: Column(
                            spacing: 5.h,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Komplimen", style: AppTextStyle.textBodyStyle(),),
                              Obx(()=> Row(
                                spacing: 10.w,
                                children: [
                                  AppRadioText(
                                    text: "Semua", 
                                    value: FilterCompliment.ALL, 
                                    groupValue: filterCompliment.value, 
                                    onChanged: (val){
                                      filterCompliment.value = val!;
                                    }
                                  ),
                                  AppRadioText(
                                    text: "Ya", 
                                    value: FilterCompliment.TRUE, 
                                    groupValue: filterCompliment.value, 
                                    onChanged: (val){
                                      filterCompliment.value = val!;
                                    }
                                  ),
                                  AppRadioText(
                                    text: "Tidak", 
                                    value: FilterCompliment.FALSE, 
                                    groupValue: filterCompliment.value, 
                                    onChanged: (val){
                                      filterCompliment.value = val!;
                                    }
                                  ),
                                ],
                              )),
                              SizedBox(height: 5.h,),
                              Text("Hutang", style: AppTextStyle.textBodyStyle(),),
                              Obx(()=> Row(
                                spacing: 10.w,
                                children: [
                                  AppRadioText(
                                    text: "Semua", 
                                    value: FilterDebt.ALL, 
                                    groupValue: filterDebt.value, 
                                    onChanged: (val){
                                      filterDebt.value = val!;
                                    }
                                  ),
                                  AppRadioText(
                                    text: "Ya", 
                                    value: FilterDebt.TRUE, 
                                    groupValue: filterDebt.value, 
                                    onChanged: (val){
                                      filterDebt.value = val!;
                                    }
                                  ),
                                  AppRadioText(
                                    text: "Tidak", 
                                    value: FilterDebt.FALSE, 
                                    groupValue: filterDebt.value, 
                                    onChanged: (val){
                                      filterDebt.value = val!;
                                    }
                                  ),
                                ],
                              ))
                            ],
                          ),
                        );
                      });
                    }, 
                    child: Text("Filter")
                  )
                ]
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
                      AppTableTitle(value: "Kode Kustomer"),
                      AppTableTitle(value: "Nama Kustomer"),
                      AppTableTitle(value: "Telp"),
                      AppTableTitle(value: "Alamat"),
                      AppTableTitle(value: "Email"),
                      AppTableTitle(value: "Aksi"),
                    ],
                    data: List.generate(controller.kustomerHeader.length,
                        (int i) {
                      var kustomer = controller.kustomerHeader[i];
                      return [
                        AppTableCell(
                            value: kustomer.suplierId,
                            index: i,
                            onEdit: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => KustomerFormScreen(
                                            kustomer: kustomer,
                                          )),
                                  (route) => false);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  kustomer.suplierId, kustomer.suplierName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: kustomer.suplierName,
                            index: i,
                            onEdit: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => KustomerFormScreen(
                                            kustomer: kustomer,
                                          )),
                                  (route) => false);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  kustomer.suplierId, kustomer.suplierName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: kustomer.telp,
                            index: i,
                            onEdit: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => KustomerFormScreen(
                                            kustomer: kustomer,
                                          )),
                                  (route) => false);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  kustomer.suplierId, kustomer.suplierName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: kustomer.address1,
                            index: i,
                            onEdit: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => KustomerFormScreen(
                                            kustomer: kustomer,
                                          )),
                                  (route) => false);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  kustomer.suplierId, kustomer.suplierName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: kustomer.emailAdress,
                            index: i,
                            onEdit: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => KustomerFormScreen(
                                            kustomer: kustomer,
                                          )),
                                  (route) => false);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  kustomer.suplierId, kustomer.suplierName);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                          index: i,
                          onDelete: () async {
                            await messageHapus(
                                kustomer.suplierId, kustomer.suplierName);
                          },
                          value: "", // Ganti dengan URL gambar jika ada
                          isEdit: true,
                          isDelete: true,
                          onEdit: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => KustomerFormScreen(
                                          kustomer: kustomer,
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

  Future<dynamic> messageHapus(String suplierId, String suplierName) {
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
            "Apakah Anda yakin ingin menghapus data '$suplierName'?",
            maxLines: 2,
            style: AppTextStyle.textSubtitleStyle(),
            textAlign: TextAlign.center,
          ),
          actions: [
            // TextButton(
            //   onPressed: () {
            //     SmartDialog.dismiss(result: false);
            //   },
            //   child: Text(
            //     "Tidak",
            //     style: AppTextStyle.textBodyStyle(color: AppColor.grey500),
            //   ),
            // ),
            // TextButton(
            //   onPressed: () async {
            //     String result = await _kustomerRepository.deleteKustomer(
            //         suplierId: suplierId);

            //     bool isSuccess = result == "1";
            //     if (isSuccess) {
            //       SmartDialog.dismiss(result: false);
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(content: Text('Data gagal dihapus!')),
            //       );
            //     } else {
            //       SmartDialog.dismiss(result: false);
            //       controller.fetchProducts();
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(content: Text('Data berhasil dihapus!')),
            //       );
            //     }
            //   },
            //   child: Text(
            //     "Iya",
            //     style: AppTextStyle.textBodyStyle(color: AppColor.primaryColor),
            //   ),
            // )
          ]);
    });
  }
}
