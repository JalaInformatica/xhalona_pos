import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_controller.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_widget.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/employee_modal.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/employee_modal_controller.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/widgets/app_image.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';

class PosScreen extends StatelessWidget {
  final PosController controller = Get.put(PosController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: AppTextField(
              context: context,
              hintText: "Cari Produk",
              onChanged: controller.updateProductFilterValue,
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 10, 
                        runSpacing: 10,
                        children: List.generate(
                          controller.products.length,
                          (index) {
                            final product = controller.products[index];
                            return GestureDetector(
                              onTap: (){
                                if(!controller.isAddingProductToTrx.value){
                                  controller.addProductToTrx(product);
                                }
                              },
                              child: Container(
                                width: 115,
                                height: 115,
                                decoration: BoxDecoration(
                                  color: !controller.isAddingProductToTrx.value || controller.selectedProductPartIdToTrx.value == product.partId? AppColor.tertiaryColor : AppColor.blackColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.grey200,
                                      blurRadius: 1,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5), 
                                      child: Opacity(
                                        opacity: 0.7, // Set opacity value here (0.0 to 1.0)
                                        child: CachedNetworkImage(
                                        imageUrl: "https://dreadnought.core-erp.com/XHALONA/${product.mainImage}",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) {
                                          // Shimmer effect when image is loading
                                          return Shimmer.fromColors(
                                            baseColor: AppColor.grey100,
                                            highlightColor: AppColor.grey200,
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              color: AppColor.grey300, // Color of the shimmer
                                            ),
                                          );
                                        },
                                        errorWidget: (context, str, obj) {
                                          return SvgPicture.asset(
                                            'assets/logo-only-pink.svg',
                                            color: AppColor.whiteColor,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    )),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                                          width: double.maxFinite,
                                          color: AppColor.blackColor.withOpacity(0.7),
                                          child: Text(
                                            product.partName,
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.textBodyStyle(
                                              overflow: TextOverflow.visible,
                                              color: AppColor.whiteColor
                                            ),
                                          )
                                        ),
                                        Container(
                                          width: double.maxFinite,
                                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                                          decoration: BoxDecoration(
                                            color: AppColor.whiteColor,
                                            border: Border.all(color: AppColor.primaryColor),
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))
                                          ),
                                          child: Text(
                                            formatToRupiah(product.unitPrice),
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.textBodyStyle(
                                              overflow: TextOverflow.visible,
                                              color: AppColor.primaryColor,
                                              fontWeight: FontWeight.bold
                                            ),
                                          )
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 115),
                    ],
                  ),
                ),
              );
            }
          }),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: 
        Obx(()=> !controller.isOpenTransaksi.value?
          AppElevatedButton(
            onPressed: (){
              controller.isOpenTransaksi.value = true;
            }, 
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
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
                Text(
                  "Transaksi",
                  style: AppTextStyle.textSubtitleStyle(
                      color: AppColor.whiteColor),
                ),
              ],
            )
          )
        : Obx(()=> Container(
  constraints: BoxConstraints(
    maxHeight: MediaQuery.of(context).size.height * 0.5,
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Header Section
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 10.w,
        ),
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
        ),
        child: Row(
          children: [
            Text(
              "Transaksi",
              style: AppTextStyle.textSubtitleStyle(
                color: AppColor.whiteColor,
              ),
            ),
            Spacer(),
            AppTextButton(
              onPressed: () {
                
              },
              borderColor: AppColor.grey300,
              foregroundColor: AppColor.blackColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Shift",
                    style: AppTextStyle.textBodyStyle(),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            AppIconButton(
              onPressed: () {},
              foregroundColor: AppColor.whiteColor,
              padding: EdgeInsets.zero,
              icon: Icon(Icons.shopping_bag),
            ),
            AppIconButton(
              onPressed: () {
                controller.isOpenTransaksi.value = false;
              },
              foregroundColor: AppColor.whiteColor,
              padding: EdgeInsets.zero,
              icon: Icon(Icons.arrow_drop_down),
            ),
          ],
        ),
      ),

      // Content Section
      Expanded(child: Container(
        color: AppColor.whiteColor,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 10.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 5.h,
          children: [
            // Scrollable Section for Current Transaction Details
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...controller.currentTransactionDetail.map((currentTrxDetail) {
                      return Column(
                        spacing: 10.h,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(currentTrxDetail.partName),
                              ),
                              Expanded(
                                child: AppTextButton(
                                  onPressed: () {
                                    SmartDialog.show(builder: (context) {
                                      return AppDialog(
                                        content: SizedBox(
                                          width: double.maxFinite,
                                          height: MediaQuery.of(context).size.height * 0.5,
                                          child: EmployeeModal(
                                            onEmployeeSelected: (selectedEmployee) {
                                              SmartDialog.dismiss();
                                            },
                                          ),
                                        ),
                                      );
                                    }).then((_) => Get.delete<EmployeeModalController>());
                                  },
                                  borderColor: AppColor.grey300,
                                  foregroundColor: AppColor.blackColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Terapis",
                                        style: AppTextStyle.textBodyStyle(),
                                      ),
                                      Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ),
                              AppIconButton(
                                onPressed: () {},
                                icon: Icon(Icons.add),
                              ),
                              AppIconButton(
                                backgroundColor: AppColor.dangerColor,
                                foregroundColor: AppColor.whiteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                onPressed: () {},
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 5.w,
                            children: [
                              Expanded(
                                child: posTextField(
                                  context: context,
                                  textEditingController: TextEditingController(),
                                  labelText: "Note",
                                ),
                              ),
                              Expanded(
                                child: posTextField(
                                  context: context,
                                  textEditingController: TextEditingController()..text=currentTrxDetail.nettoVal.toString(),
                                  labelText: "Harga",
                                  isReadOnly: currentTrxDetail.isFixPrice
                                ),
                              ),
                              Expanded(
                                child: posTextField(
                                  context: context,
                                  textEditingController: TextEditingController(),
                                  labelText: "Diskon",
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 5.w,
              children: [
                posAppButton(
                  onPressed: () {
                    controller.currentTransactionId.value = "";
                    controller.currentTransaction.value = [];
                    controller.currentTransactionDetail.value = [];
                  },
                  text: "Baru",
                ),
                posAppButton(
                  onPressed: () {},
                  text: "Member",
                ),
                posAppButton(
                  onPressed: () {},
                  text: "Tamu",
                ),
                posAppButton(
                  onPressed: () {},
                  text: "Diskon",
                ),
                posAppButton(
                  text: "Batal", 
                  onPressed: (){}
                )
              ],
            ),
            Row(
  mainAxisAlignment: MainAxisAlignment.start,
  // crossAxisAlignment: CrossAxisAlignment.stretch,
  spacing: 5.w,
  children: [
    // Wrap the Column with IntrinsicWidth for uniform width
    IntrinsicWidth(
      child: Column(
        spacing: 5.h,
        children: [
          AppTextButton(
            foregroundColor: AppColor.primaryColor,
            onPressed: () {},
            child: Row(
              spacing: 5.w,
              children: [
                Icon(Icons.event_seat, color: AppColor.primaryColor),
                Text("Antrian", style: AppTextStyle.textBodyStyle())
              ],
            ),
          ),
          AppTextButton(
            foregroundColor: AppColor.primaryColor,
            onPressed: () {},
            child: Row(
              spacing: 5.w,
              children: [
                Icon(Icons.document_scanner, color: AppColor.primaryColor),
                Text("Nota", style: AppTextStyle.textBodyStyle())
              ],
            ),
          ),
        ],
      ),
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tagihan: ${formatToRupiah(controller.currentTransaction.isNotEmpty? controller.currentTransaction[0].nettoVal : 0)}"),
        AppElevatedButton(
          size: AppElevatedButtonSize.big,
          backgroundColor: AppColor.primaryColor,
          foregroundColor: AppColor.whiteColor,
          onPressed: () {},
          text: Row(
            spacing: 5.w,
            children: [
              Icon(Icons.payment_outlined, color: AppColor.whiteColor),
              Text("Checkout", style: AppTextStyle.textSubtitleStyle())
            ],
          ),
        ),
      ],
    ),
  ],
),

          ],
        ),
       ) ),
    ],
  ),
)

        ))
    );
  }
}