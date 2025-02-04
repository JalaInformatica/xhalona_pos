import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/member_modal.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/member_modal_controller.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_widget.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_controller.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/employee_modal.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/employee_modal_controller.dart';

class PosScreen extends StatelessWidget {
  final PosController controller = Get.put(PosController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius:0,
                        blurRadius: 0.5,
                        color: AppColor.grey500,
                        offset: Offset(0, 1)
                      )
                    ]
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  child: 
                  Column(
                    spacing: 5.h,
                    children: [
                    Row(
                    spacing: 5.w,
                    children: [
                    Expanded(child: AppTextField(
                      fillColor: AppColor.whiteColor,
                      context: context,
                      contentPadding: EdgeInsets.all(5),
                      hintText: "Cari Produk",
                      onChanged: controller.updateProductFilterValue,
                    )),
                    AppIconButton(
                      padding: EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(side: BorderSide(color: AppColor.grey300),borderRadius: BorderRadius.circular(5) ),
                      onPressed: (){}, 
                      foregroundColor: AppColor.secondaryColor,
                      icon: Icon(Icons.category_outlined))
                  ],) ,
Row(
                  spacing: 10.w,
                  children: [
                    Row(
                    spacing: 5.w,
                      children: [
                        Icon(Icons.face_retouching_natural, size: 15, color: AppColor.secondaryColor,),
                        Text("Jasa", style: AppTextStyle.textBodyStyle(),),
                      ],
                    ),
                    Row(
                    spacing: 5.w,
                      children: [
                        Icon(Icons.all_inbox, size: 15, color: AppColor.dangerColor,),
                        Text("Paket", style: AppTextStyle.textBodyStyle(),),
                      ],
                    ),
                    Row(
                    spacing: 5.w,
                      children: [
                        Icon(Icons.shopping_bag, size: 15, color: AppColor.blackColor,),
                        Text("Barang", style: AppTextStyle.textBodyStyle(),),
                      ],
                    ),
                  ],
                ),
                    ],),
                ),
                SizedBox(height: 5.h,),
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Expanded(
                      child: 
                      // RefreshIndicator(
                      //   onRefresh: () => controller.fetchProducts(),
                      //   child: 
                        SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Column(
                            children: [
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 15.w,
                                runSpacing: 15.h,
                                children: List.generate(
                                  controller.products.length,
                                  (index) {
                                    final product = controller.products[index];
                                    return produkImage(controller, product);
                                  },
                                ),
                              ),
                              SizedBox(height: 115),
                            ],
                          ),
                        )
                      // )
                    );
                  }
                }),
              ],
            ),
            Obx(()=> transaction(
              context: context,
              controller: controller, 
              onTerapisClicked: (String rowId){
                SmartDialog.show(
                  builder: (context) {
                  return Padding(padding: EdgeInsets.only(top: 15.h), child: AppDialog(
                    content: SizedBox(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: EmployeeModal(
                        onEmployeeSelected: (selectedEmployee) {
                          controller.editTerapisOfTrx(rowId, selectedEmployee.empId);
                          SmartDialog.dismiss();
                        },
                      ),
                    ),
                  ));
                }).then((_) => Get.delete<
                    EmployeeModalController>());
                }, 
                onMemberClicked: () async {
                  SmartDialog.show(
                  builder: (context) {
                  return Padding(padding: EdgeInsets.only(top: 15.h), child: AppDialog(
                    content: SizedBox(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: MemberModal(
                        memberContext: context,
                        onMemberSelected: (selectedMember) {
                          controller.addMemberToTrx(selectedMember);
                          SmartDialog.dismiss();
                        },
                      ),
                    ),
                  ));
                }).then((_) => Get.delete<
                    MemberModalController>());
                },
                onCheckoutClicked: () async {
                  await SmartDialog.show(
                    builder: (_) => SafeArea(child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Checkout", style: AppTextStyle.textTitleStyle(color: AppColor.primaryColor),),
                          SizedBox(height: 5.h,),
                          Text("Ringkasan Tagihan", style: AppTextStyle.textSubtitleStyle(),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text("Total: ", style: AppTextStyle.textBodyStyle(color: AppColor.grey500),),
                            Text("Rp. 100.000", style: AppTextStyle.textBodyStyle(),),
                          ],),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text("Diskon: ", style: AppTextStyle.textBodyStyle(color: AppColor.grey500),),
                            Text("Rp. 10.000", style: AppTextStyle.textBodyStyle(),),
                          ],),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text("Tagihan: ", style: AppTextStyle.textBodyStyle(color: AppColor.grey500),),
                            Text("Rp. 90.000", style: AppTextStyle.textBodyStyle(),),
                          ],),
                          SizedBox(height: 10.h,),
                          Text("Pembayaran", style: AppTextStyle.textSubtitleStyle(),),
                          Row(
                            spacing: 5.w,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text("Tunai: ", style: AppTextStyle.textBodyStyle(),)
                              ),
                              Expanded(
                                flex: 2,
                                child: AppTextField(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                  context: context, hintText: "0", textAlign: TextAlign.right,)),
                          ],), 
                          SizedBox(height: 5.h,),
                          Row(
                            spacing: 5.w,
                            children: [
                              Expanded(
                                flex: 1,
                                child: DropdownButton<String>(
                                value: "Non-tunai",
                                items: [
                                  DropdownMenuItem(
                                    value: "Non-tunai",
                                    child: Text(
                                      "Non-tunai", style: AppTextStyle.textBodyStyle(),
                                    )
                                  ),
                                  DropdownMenuItem(
                                    value: "QRIZ",
                                    child: Text(
                                      "QRIZ", style: AppTextStyle.textBodyStyle(),
                                    )
                                  ),
                                ], 
                                onChanged: (v){})
                              ),
                              Expanded(
                                flex: 2,
                                child:AppTextField(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                  context: context, hintText: "0", textAlign: TextAlign.right,)),
                          ],), 
                          SizedBox(height: 5.h,),
                          Row(
                            spacing: 5.w,
                            children: [
                              Expanded(
                                flex: 1,
                                child: DropdownButton<String>(
                                value: "Non-tunai",
                                items: [
                                  DropdownMenuItem(
                                    value: "Non-tunai",
                                    child: Text(
                                      "Non-tunai", style: AppTextStyle.textBodyStyle(),
                                    )
                                  ),
                                  DropdownMenuItem(
                                    value: "QRIZ",
                                    child: Text(
                                      "QRIZ", style: AppTextStyle.textBodyStyle(),
                                    )
                                  ),
                                ], 
                                onChanged: (v){})
                              ),
                              Expanded(
                                flex: 2,
                                child: AppTextField(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                  context: context, hintText: "0", textAlign: TextAlign.right,)),
                          ],), 
                          SizedBox(height: 5.h,),
                          Row(
                            spacing: 5.w,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text("Komplimen: ", style: AppTextStyle.textBodyStyle(),)
                              ),
                              Expanded(
                                flex: 2,
                                child: AppTextField(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                  context: context, hintText: "0", textAlign: TextAlign.right,)),
                          ],),
                          SizedBox(height: 10.h,),
                          Row(
                            spacing: 5.w,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text("Hutang: ", style: AppTextStyle.textBodyStyle(),)
                              ),
                              Expanded(
                                flex: 2,
                                child: AppTextField(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                  context: context, hintText: "0", textAlign: TextAlign.right,)),
                          ],),
                          SizedBox(height: 10.h),
                          Row(
                            spacing: 5.w,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: Text("Total: ", style: AppTextStyle.textBodyStyle(fontWeight: FontWeight.bold),))
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.only(top: 5.h),
                                  decoration: BoxDecoration(
                                    border: Border(top: BorderSide())
                                  ),
                                  child: AppTextField(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                  context: context, hintText: "0", textAlign: TextAlign.right,))),
                          ],),
                          SizedBox(height:10.h,),
                          Row(
                            spacing: 5.w,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: Text("Kembalian: ", style: AppTextStyle.textBodyStyle(fontWeight: FontWeight.bold),))
                              ),
                              Expanded(
                                flex: 2,
                                child: AppTextField(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                  context: context, hintText: "0", textAlign: TextAlign.right,)),
                          ],),
                          SizedBox(height: 10.h,),
                          Row(
                            spacing: 5.w,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: Text("Titipan: ", style: AppTextStyle.textBodyStyle(fontWeight: FontWeight.bold),))
                              ),
                              Expanded(
                                flex: 2,
                                child: AppTextField(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                  context: context, hintText: "0", textAlign: TextAlign.right,)),
                          ],),
                          SizedBox(height: 10.h,),
                          SizedBox(
                            width: double.infinity,
                            child: AppElevatedButton(
                              backgroundColor: AppColor.primaryColor,
                              foregroundColor: AppColor.whiteColor,
                              onPressed: (){}, 
                              text: Text("Checkout", style: AppTextStyle.textSubtitleStyle(),)),
                          )
                        ],
                      ),
                      
                    ),
                  ));
                }
              )
            )
          ]
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Obx(() => !controller.isOpenTransaksi.value
            ? AppElevatedButton(
                onPressed: () {
                  controller.isOpenTransaksi.value = true;
                },
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                backgroundColor: AppColor.primaryColor,
                foregroundColor: AppColor.whiteColor,
                text: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5.w,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: AppColor.whiteColor,
                    ),
                    Obx(()=> Text(
                      controller.currentTransactionId.value==""? "Transaksi" : 
                      "${shortenTrxIdAndName(controller.currentTransactionId.value, guestName: controller.currentTransaction.value.guestName)}",
                      style: AppTextStyle.textSubtitleStyle(
                          color: AppColor.whiteColor),
                    )),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColor.backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(controller.currentTransactionDetail.length.toString(), style: AppTextStyle.textBodyStyle(fontWeight: FontWeight.bold, color: AppColor.dangerColor),),
                    )
                  ],
                ))
            : SizedBox.shrink()));
  }
}
