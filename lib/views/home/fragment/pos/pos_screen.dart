import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/models/dto/tamu.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_widget.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_controller.dart';
import 'package:xhalona_pos/views/home/fragment/pos/checkout_screen.dart';
import 'package:xhalona_pos/views/home/fragment/pos/checkout_controller.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/shift_modal.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/member_modal.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/employee_modal.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/shift_modal_controller.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/member_modal_controller.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/employee_modal_controller.dart';

class PosScreen extends StatelessWidget {
  final PosController controller = Get.put(PosController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.whiteColor,
        body: Stack(children: [
          Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(color: AppColor.whiteColor, boxShadow: [
                  BoxShadow(
                      spreadRadius: 0,
                      blurRadius: 0.5,
                      color: AppColor.grey500,
                      offset: Offset(0, 1))
                ]),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Column(
                  spacing: 5.h,
                  children: [
                    Row(
                      spacing: 5.w,
                      children: [
                        Expanded(
                            child: AppTextField(
                          fillColor: AppColor.whiteColor,
                          context: context,
                          contentPadding: EdgeInsets.all(5),
                          hintText: "Cari Produk",
                          onChanged: controller.updateProductFilterValue,
                        )),
                        AppIconButton(
                            padding: EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppColor.grey300),
                                borderRadius: BorderRadius.circular(5)),
                            onPressed: () {},
                            foregroundColor: AppColor.secondaryColor,
                            icon: Icon(Icons.category_outlined))
                      ],
                    ),
                    Row(
                      spacing: 10.w,
                      children: [
                        Row(
                          spacing: 5.w,
                          children: [
                            Icon(
                              Icons.face_retouching_natural,
                              size: 15,
                              color: AppColor.secondaryColor,
                            ),
                            Text(
                              "Jasa",
                              style: AppTextStyle.textBodyStyle(),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 5.w,
                          children: [
                            Icon(
                              Icons.all_inbox,
                              size: 15,
                              color: AppColor.dangerColor,
                            ),
                            Text(
                              "Paket",
                              style: AppTextStyle.textBodyStyle(),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 5.w,
                          children: [
                            Icon(
                              Icons.shopping_bag,
                              size: 15,
                              color: AppColor.blackColor,
                            ),
                            Text(
                              "Barang",
                              style: AppTextStyle.textBodyStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return Expanded(
                      child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 15.h),
                          child: Column(children: [
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 15.w,
                              runSpacing: 15.h,
                              children: List.generate(
                                4,
                                (index) {
                                  return Shimmer.fromColors(
                                      child: Container(
                                        width: 165.w,
                                        height: 185.h,
                                        color: AppColor.whiteColor,
                                      ),
                                      baseColor: AppColor.grey300,
                                      highlightColor: AppColor.grey100);
                                },
                              ),
                            )
                          ])));
                } else {
                  return Expanded(
                      child:
                          // RefreshIndicator(
                          //   onRefresh: () => controller.fetchProducts(),
                          //   child:
                          SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.start,
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
                      ],
                    ),
                  ));
                }
              }),
            ],
          ),
          Obx(() => transaction(
              context: context,
              controller: controller,
              onShiftSelected: () async {
                SmartDialog.show(builder: (context) {
                  return Padding(
                      padding: EdgeInsets.only(top: 15.h),
                      child: AppDialog(
                        content: SizedBox(
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ShiftModal(
                            onShiftSelected: (selectedShift) {
                              controller.setCurrentShift(selectedShift.shiftId);
                              SmartDialog.dismiss();
                            },
                          ),
                        ),
                      ));
                }).then((_) => Get.delete<ShiftModalController>());
              },
              onTerapisClicked: (String rowId, String? selectedEmpName) {
                SmartDialog.show(builder: (context) {
                  return Padding(
                      padding: EdgeInsets.only(top: 15.h),
                      child: AppDialog(
                        content: SizedBox(
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: EmployeeModal(
                            selectedEmpName: selectedEmpName ?? "",
                            onEmployeeSelected: (selectedEmployee) {
                              controller.editTerapisOfTrx(
                                  rowId, selectedEmployee.empId);
                              SmartDialog.dismiss();
                            },
                          ),
                        ),
                      ));
                }).then((_) => Get.delete<EmployeeModalController>());
              },
              onMemberClicked: () async {
                SmartDialog.show(builder: (context) {
                  return Padding(
                      padding: EdgeInsets.only(top: 15.h),
                      child: AppDialog(
                        content: SizedBox(
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: MemberModal(
                            // memberContext: context,
                            onMemberSelected: (selectedMember) {
                              controller.addMemberToTrx(selectedMember);
                              SmartDialog.dismiss();
                            },
                          ),
                        ),
                      ));
                }).then((_) => Get.delete<MemberModalController>());
              },
              onTamuClicked: () {
                TextEditingController guestNameController =
                    TextEditingController();
                TextEditingController guestPhoneController =
                    TextEditingController();
                if (controller.currentTransaction.value.supplierName.isEmpty) {
                  guestNameController
                    ..text = controller.currentTransaction.value.guestName;
                  guestPhoneController
                    ..text = controller.currentTransaction.value.guestPhone;
                }
                final _formkey = GlobalKey<FormState>();
                SmartDialog.show(builder: (_) {
                  return AppDialog(
                      content: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15.h,
                      children: [
                        Text(
                          "Tamu",
                          style: AppTextStyle.textSubtitleStyle(),
                        ),
                        AppTextFormField(
                          inputAction: TextInputAction.next,
                          textEditingController: guestNameController,
                          // contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                          context: context, labelText: "Nama Customer*",
                          validator: (value) {
                            if (value == '') {
                              return 'Nama Tamu Wajib diisi';
                            }
                            return null;
                          },
                        ),
                        AppTextFormField(
                          inputAction: TextInputAction.done,
                          textEditingController: guestPhoneController,
                          // contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                          context: context, labelText: "Nomor Handphone/Telp",
                          validator: (value) {
                            if (value == '') {
                              return 'No HP Wajib diisi';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: AppElevatedButton(
                              backgroundColor: AppColor.primaryColor,
                              foregroundColor: AppColor.whiteColor,
                              onPressed: () {
                                if (_formkey.currentState?.validate() ??
                                    false) {
                                  controller.addTamuToTrx(TamuDTO(
                                    guestName: guestNameController.text,
                                    guestPhone: guestPhoneController.text,
                                  ));
                                  SmartDialog.dismiss();
                                }
                              },
                              child: Text("Simpan")),
                        )
                      ],
                    ),
                  ));
                });
              },
              onCheckoutClicked: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => CheckoutScreen(
                            salesId: controller.currentTransactionId.value,
                            brutoVal:
                                controller.currentTransaction.value.brutoVal,
                            discVal:
                                controller.currentTransaction.value.discVal,
                            nettoVal:
                                controller.currentTransaction.value.nettoVal)))
                    .then((_) {
                      Get.delete<CheckoutController>();
                    });
              }))
        ]),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5.w,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: AppColor.whiteColor,
                    ),
                    Obx(() => Text(
                          controller.currentTransactionId.value == ""
                              ? "Transaksi"
                              : shortenTrxIdAndName(
                                  controller.currentTransactionId.value,
                                  guestName: controller
                                      .currentTransaction.value.guestName),
                          style: AppTextStyle.textSubtitleStyle(
                              color: AppColor.whiteColor),
                        )),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColor.backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        controller.currentTransactionDetail.length.toString(),
                        style: AppTextStyle.textBodyStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.dangerColor),
                      ),
                    )
                  ],
                ))
            : SizedBox.shrink()));
  }
}
