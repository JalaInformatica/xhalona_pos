import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/form/form_kustomer_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/form/form_kustomer_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/kustomer_controller.dart';
import 'package:xhalona_pos/widgets/app_dialog2.dart';
import 'package:xhalona_pos/widgets/app_dialog_list.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_radio_text.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/kustomer/kustomer_repository.dart';
import 'package:xhalona_pos/widgets/app_table2.dart';
import 'package:xhalona_pos/widgets/app_tile.dart';

// ignore: must_be_immutable
class MasterKustomerScreen extends StatelessWidget {
  MasterKustomerScreen({super.key});

  final KustomerController controller = Get.put(KustomerController());

  void actions(BuildContext context, KustomerDAO kustomer){
    AppDialogList.showListActionsDialog(
      title: kustomer.suplierName, 
      icon: Icons.person,
      actionTiles: [
        AppDialogList.editAppTile(
          onTap: (){
            SmartDialog.dismiss().then(
              (_){
                Get.to(
                  () => KustomerFormScreen(kustomer: kustomer),
                  binding: BindingsBuilder(() {
                    Get.put(KustomerFormController(formCustomer: kustomer));
                  }),
                )?.then((_) => controller.fetchKustomers());
              }
            );
          }),
        AppDialogList.deleteAppTile(
          onTap: () async{
            SmartDialog.dismiss();
            AppDialogList.showDeleteConfirmation(
              title: "Hapus ${kustomer.suplierName}?", 
              onDelete: (){
                controller.deleteKustomer(kustomer.suplierId).then((_){
                  SmartDialog.dismiss();
                  controller.fetchKustomers();
                });
              }, 
              onCancel: (){
                SmartDialog.dismiss();    
              }
            );
        })
      ]
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  AppElevatedButton(
                    backgroundColor: AppColor.primaryColor,
                    onPressed: () {
                      Get.to(
                          () => KustomerFormScreen(),
                          binding: BindingsBuilder(() {
                            Get.put(KustomerFormController()); // not permanent = can be auto-deleted
                          }),
                        )?.then((_)=>controller.fetchKustomers());
                    }, 
                    foregroundColor: AppColor.whiteColor,
                    icon: Icons.add, 
                    child: Text("Kustomer Baru", style: AppTextStyle.textSubtitleStyle(),)
                  ),
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
                      child: AppTable2(
                    onSearch: (filterValue) =>
                        controller.updateFilterValue(filterValue),
                    onChangePageNo: (pageNo) => controller.updatePageNo(pageNo),
                    onChangePageRow: (pageRow) =>
                        controller.updatePageRow(pageRow),
                    pageNo: controller.pageNo.value,
                    pageRow: controller.pageRow.value,
                    titles: [
                      AppTableTitle2(value: "Telp"),
                      AppTableTitle2(value: "Nama"),
                      AppTableTitle2(value: "Alamat"),
                      AppTableTitle2(value: "Email"),
                      AppTableTitle2(value: "Hutang"),
                      AppTableTitle2(value: "Komplimen"),
                      AppTableTitle2(value: "Aksi"),
                    ],
                    data: List.generate(controller.kustomerHeader.length,
                        (int i) {
                      var kustomer = controller.kustomerHeader[i];
                      return [
                        AppTableCell2(
                            value: kustomer.telp,
                            action: () => actions(context, kustomer),
                        ),
                        AppTableCell2(
                            value: kustomer.suplierName,
                            action: () => actions(context, kustomer),
                        ),
                        AppTableCell2(
                            value: kustomer.address1,
                            action: () => actions(context, kustomer),
                        ),
                        AppTableCell2(
                            value: kustomer.emailAdress,
                            action: () => actions(context, kustomer),
                        ),
                        AppTableCell2(
                            customWidget: kustomer.isPayable?
                            Icon(Icons.check, color: AppColor.doneColor,) : 
                            Icon(Icons.close, color: AppColor.dangerColor),
                            action: () => actions(context, kustomer),
                        ),
                        AppTableCell2(
                            customWidget: kustomer.isCompliment?
                            Icon(Icons.check, color: AppColor.doneColor,) : 
                            Icon(Icons.close, color: AppColor.dangerColor),                            
                            action: () => actions(context, kustomer),
                        ),
                        AppTableCell2(

                        ),
                      ];
                    }),
                    onRefresh: () => controller.fetchKustomers(),
                    isRefreshing: controller.isLoading.value,
                  )))
            ],
          ),
        ),
      );
  }

  
}
