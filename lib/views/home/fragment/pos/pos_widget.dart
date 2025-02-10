import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_image.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_pdf_viewer.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_controller.dart';

AppTextField posTextField(
    {required BuildContext context,
    required TextEditingController textEditingController,
    required labelText,
    bool isReadOnly = false,
    TextAlign textAlign = TextAlign.start,
    bool isThousand = false}) {
  return AppTextField(
    context: context,
    textEditingController: textEditingController,
    labelText: labelText,
    contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
    readOnly: isReadOnly,
    textAlign: textAlign,
    isThousand: isThousand,
  );
}

AppElevatedButton posAppButton(
    {required String text,
    required VoidCallback onPressed,
    bool isActive = false}) {
  return AppElevatedButton(
      backgroundColor: !isActive ? AppColor.whiteColor : AppColor.doneColor,
      foregroundColor: !isActive ? AppColor.primaryColor : AppColor.whiteColor,
      borderColor: !isActive ? AppColor.primaryColor : AppColor.doneColor,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      onPressed: onPressed,
      child: Text(
        text,
        style: AppTextStyle.textBodyStyle(),
      ));
}

Widget produkImage(PosController controller, ProductDAO product) {
  return Container(
      width: 165.w,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      // height: 125,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey200,
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            AppImage(
              imageUrl:
                  "https://dreadnought.core-erp.com/XHALONA/${product.mainImage}",
              width: 160.w,
              height: 160.h,
              radius: 5,
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5)),
                color: product.isPacket
                    ? AppColor.dangerColor.withAlpha(200)
                    : product.isFixQty
                        ? AppColor.secondaryColor.withAlpha(200)
                        : AppColor.blackColor.withAlpha(200),
              ),
              child: Icon(
                product.isPacket
                    ? Icons.all_inbox
                    : product.isFixQty
                        ? Icons.face_retouching_natural
                        : Icons.shopping_bag,
                size: 15,
                color: AppColor.whiteColor,
              ),
            )
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          product.partName,
          style: AppTextStyle.textBodyStyle(
              fontFamily: 'GoogleSans', fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatToRupiah(product.unitPriceNet),
              style: AppTextStyle.textBodyStyle(color: AppColor.doneColor),
            ),
            Text(
              formatToRupiah(product.unitPrice),
              style: AppTextStyle.textCaptionStyle(
                  color: AppColor.dangerColor,
                  decoration: TextDecoration.lineThrough),
            )
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        SizedBox(
            width: double.maxFinite,
            child: AppTextButton(
                onPressed: () {
                  if (!controller.isAddingProductToTrx.value) {
                    controller.addProductToTrx(product);
                    SmartDialog.show(builder: (_) {
                      return AppDialog(
                          content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                            Text(
                              "Menambahkan",
                              style: AppTextStyle.textSubtitleStyle(),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                AppImage(
                                  imageUrl:
                                      "https://dreadnought.core-erp.com/XHALONA/${product.mainImage}",
                                  width: 160.w,
                                  height: 160.h,
                                  radius: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5)),
                                    color: product.isPacket
                                        ? AppColor.dangerColor.withAlpha(200)
                                        : product.isFixQty
                                            ? AppColor.secondaryColor
                                                .withAlpha(200)
                                            : AppColor.blackColor
                                                .withAlpha(200),
                                  ),
                                  child: Icon(
                                    product.isPacket
                                        ? Icons.all_inbox
                                        : product.isFixQty
                                            ? Icons.face_retouching_natural
                                            : Icons.shopping_bag,
                                    size: 15,
                                    color: AppColor.whiteColor,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              product.partName,
                              style: AppTextStyle.textBodyStyle(
                                  fontFamily: 'GoogleSans',
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 5.w,
                              children: [
                                Text(
                                  formatToRupiah(product.unitPriceNet),
                                  style: AppTextStyle.textBodyStyle(
                                      color: AppColor.doneColor),
                                ),
                                Text(
                                  formatToRupiah(product.unitPrice),
                                  style: AppTextStyle.textCaptionStyle(
                                      color: AppColor.dangerColor,
                                      decoration: TextDecoration.lineThrough),
                                )
                              ],
                            ),
                          ]));
                    });
                    Future.delayed(Duration(seconds: 2), () {
                      SmartDialog.dismiss();
                    });
                  }
                },
                child: Text(
                  "Tambah Pesanan",
                  style: AppTextStyle.textBodyStyle(),
                )))
      ]));
}

Widget transaction(
    {required PosController controller,
    required Function(String, String) onTerapisClicked,
    required VoidCallback onCheckoutClicked,
    required VoidCallback onTamuClicked,
    required VoidCallback onMemberClicked,
    required VoidCallback onShiftSelected,
    required BuildContext context}) {
  return controller.isOpenTransaksi.value
      ? Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
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
                    controller.currentTransactionId.value == ""
                        ? "Transaksi"
                        : shortenTrxIdAndName(
                            controller.currentTransactionId.value,
                            guestName:
                                controller.currentTransaction.value.guestName,
                            supplierName: controller
                                .currentTransaction.value.supplierName),
                    style: AppTextStyle.textSubtitleStyle(
                      color: AppColor.whiteColor,
                    ),
                  ),
                  Spacer(),
                  AppTextButton(
                    onPressed: onShiftSelected,
                    borderColor: AppColor.grey300,
                    foregroundColor: AppColor.blackColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.currentShiftId.isEmpty
                              ? "Shift"
                              : controller.currentShiftId.value,
                          style: AppTextStyle.textBodyStyle(),
                        ),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
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
            Container(
              color: AppColor.whiteColor,
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 10.w,
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              child: controller.currentTransactionId.isEmpty
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5.w,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColor.grey500,
                        ),
                        Text(
                          "Belum Ada Transaksi",
                          style: AppTextStyle.textSubtitleStyle(),
                        ),
                      ],
                    ))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5.h,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10.h,
                              children: [
                                ...controller.currentTransactionDetail
                                    .map((currentTrxDetail) {
                                  return Column(
                                    spacing: 10.h,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child:
                                                Text(currentTrxDetail.partName),
                                          ),
                                          Expanded(
                                            child: AppTextButton(
                                              onPressed: () => onTerapisClicked(
                                                  currentTrxDetail.rowId,
                                                  currentTrxDetail
                                                          .employeeName1 ??
                                                      ""),
                                              borderColor: AppColor.grey300,
                                              foregroundColor:
                                                  AppColor.blackColor,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    currentTrxDetail
                                                            .employeeName1 ??
                                                        "Terapis*",
                                                    style: AppTextStyle
                                                        .textBodyStyle(),
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
                                            backgroundColor:
                                                AppColor.dangerColor,
                                            foregroundColor:
                                                AppColor.whiteColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            onPressed: () {
                                              controller.deleteProductFromTrx(
                                                  currentTrxDetail.rowId);
                                            },
                                            icon: controller
                                                    .isDeletingProductFromTrx
                                                    .value
                                                ? SizedBox(
                                                    width: 18,
                                                    height: 18,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color:
                                                          AppColor.whiteColor,
                                                    ))
                                                : Icon(Icons.delete),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        spacing: 5.w,
                                        children: [
                                          Expanded(
                                            child: posTextField(
                                                context: context,
                                                textEditingController:
                                                    TextEditingController()
                                                      ..text = formatThousands(
                                                          currentTrxDetail
                                                              .nettoVal
                                                              .toString()),
                                                labelText: "Harga",
                                                isReadOnly:
                                                    currentTrxDetail.isFixPrice,
                                                textAlign: TextAlign.end,
                                                isThousand: true),
                                          ),
                                          Expanded(
                                            child: posTextField(
                                                context: context,
                                                textEditingController:
                                                    TextEditingController()
                                                      ..text = formatThousands(
                                                          currentTrxDetail
                                                              .deductionVal
                                                              .toString()),
                                                labelText: "Diskon",
                                                textAlign: TextAlign.end,
                                                isThousand: true),
                                          ),
                                          AppIconButton(
                                              onPressed: () {
                                                controller.toggleNoteVisible(
                                                    currentTrxDetail.rowId);
                                              },
                                              icon: Icon(
                                                  Icons.note_add_outlined)),
                                        ],
                                      ),
                                      Obx(() => (controller.isNoteVisible[
                                                  currentTrxDetail.rowId] ??
                                              false)
                                          ? AppTextField(
                                              context: context,
                                              maxLines: 3,
                                            )
                                          : SizedBox.shrink()),
                                      Divider(
                                        color: AppColor.secondaryColor,
                                      )
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 5.w,
                          children: [
                            AppElevatedButton(
                                backgroundColor: AppColor.blueColor,
                                foregroundColor: AppColor.whiteColor,
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                borderColor: AppColor.blueColor,
                                onPressed: () {
                                  controller.newTransaction();
                                },
                                child: Text(
                                  "Baru",
                                  style: AppTextStyle.textBodyStyle(),
                                )),
                            AppElevatedButton(
                                backgroundColor: controller.currentTransaction
                                        .value.supplierName.isEmpty
                                    ? AppColor.whiteColor
                                    : AppColor.doneColor,
                                foregroundColor: controller.currentTransaction
                                        .value.supplierName.isEmpty
                                    ? AppColor.primaryColor
                                    : AppColor.whiteColor,
                                borderColor: controller.currentTransaction.value
                                        .supplierName.isEmpty
                                    ? AppColor.primaryColor
                                    : AppColor.doneColor,
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                onPressed: onMemberClicked,
                                child: Row(spacing: 5.w, children: [
                                  Text(
                                    "Member",
                                    style: AppTextStyle.textBodyStyle(),
                                  ),
                                  if (controller.currentTransaction.value
                                      .supplierName.isNotEmpty)
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: AppColor.whiteColor,
                                    )
                                ])),
                            AppElevatedButton(
                                backgroundColor: controller.currentTransaction
                                            .value.guestName.isNotEmpty &&
                                        controller.currentTransaction.value
                                            .supplierName.isEmpty
                                    ? AppColor.doneColor
                                    : AppColor.whiteColor,
                                foregroundColor: controller.currentTransaction
                                            .value.guestName.isNotEmpty &&
                                        controller.currentTransaction.value
                                            .supplierName.isEmpty
                                    ? AppColor.whiteColor
                                    : AppColor.primaryColor,
                                borderColor: controller.currentTransaction.value
                                            .guestName.isNotEmpty &&
                                        controller.currentTransaction.value
                                            .supplierName.isEmpty
                                    ? AppColor.doneColor
                                    : AppColor.primaryColor,
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                onPressed: onTamuClicked,
                                child: Row(
                                  spacing: 5.w,
                                  children: [
                                    Text(
                                      "Tamu",
                                      style: AppTextStyle.textBodyStyle(),
                                    ),
                                    if (controller.currentTransaction.value
                                            .guestName.isNotEmpty &&
                                        controller.currentTransaction.value
                                            .supplierName.isEmpty)
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: AppColor.whiteColor,
                                      )
                                  ],
                                )),
                            AppElevatedButton(
                                backgroundColor: AppColor.whiteColor,
                                foregroundColor: AppColor.purpleColor,
                                borderColor: AppColor.purpleColor,
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                onPressed: () {},
                                child: Text(
                                  "Diskon",
                                  style: AppTextStyle.textBodyStyle(),
                                )),
                            AppElevatedButton(
                                backgroundColor: AppColor.dangerColor,
                                foregroundColor: AppColor.whiteColor,
                                borderColor: AppColor.dangerColor,
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                onPressed: () {
                                  controller.cancelTransaction();
                                },
                                child: Text(
                                  "Batal",
                                  style: AppTextStyle.textBodyStyle(),
                                )),
                          ],
                        ),
                        if (controller.showError.value &&
                            (controller.currentTransaction.value.supplierId
                                    .isEmpty ||
                                controller.currentTransactionDetail.any(
                                    (detail) => detail.employeeId.isEmpty)))
                          Text(
                            "*Lengkapi informasi${controller.currentTransaction.value.supplierId.isEmpty ? " pelanggan" : ""} ${controller.currentTransactionDetail.any((detail) => detail.employeeId.isEmpty) ? " terapis" : ""}",
                            style: AppTextStyle.textCaptionStyle(
                                color: AppColor.dangerColor),
                            textAlign: TextAlign.left,
                          ),
                        SizedBox(
                          height: 3.h,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 5.w,
                            children: [
                              IntrinsicWidth(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 5.h,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total: ",
                                            style: AppTextStyle.textBodyStyle(
                                                color: AppColor.grey500),
                                          ),
                                          Text(
                                            "${formatToRupiah(controller.currentTransaction.value.brutoVal)}",
                                            style: AppTextStyle.textBodyStyle(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Diskon: ",
                                            style: AppTextStyle.textBodyStyle(
                                                color: AppColor.grey500),
                                          ),
                                          Text(
                                            "${formatToRupiah(controller.currentTransaction.value.discVal)}",
                                            style: AppTextStyle.textBodyStyle(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Tagihan: ",
                                            style: AppTextStyle.textBodyStyle(
                                                color: AppColor.grey500),
                                          ),
                                          Text(
                                            "${formatToRupiah(controller.currentTransaction.value.nettoVal)}",
                                            style: AppTextStyle.textBodyStyle(),
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                              Spacer(),
                              IntrinsicWidth(
                                  child: Column(
                                spacing: 5.h,
                                children: [
                                  AppTextButton(
                                    disabled: controller.currentTransaction
                                            .value.supplierId.isEmpty ||
                                        controller.currentTransactionDetail.any(
                                            (detail) =>
                                                detail.employeeId.isEmpty),
                                    foregroundColor: AppColor.primaryColor,
                                    onPressed: () {},
                                    child: Row(
                                      spacing: 5.w,
                                      children: [
                                        Icon(Icons.event_seat,
                                            color: AppColor.primaryColor),
                                        Text("Antrian",
                                            style: AppTextStyle.textBodyStyle())
                                      ],
                                    ),
                                  ),
                                  AppTextButton(
                                    disabled: controller.currentTransaction
                                            .value.totalHutang ==
                                        controller
                                            .currentTransaction.value.nettoVal,
                                    foregroundColor: AppColor.primaryColor,
                                    onPressed: () {
                                      controller.printNota().then(
                                          (url) => Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AppPDFViewer(pdfUrl: url),
                                                ),
                                              ));
                                    },
                                    child: Row(
                                      spacing: 5.w,
                                      children: [
                                        Icon(Icons.document_scanner,
                                            color: AppColor.primaryColor),
                                        Text("Nota",
                                            style: AppTextStyle.textBodyStyle())
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                              AppElevatedButton(
                                  onPressedValidation: () {
                                    controller.showError.value = true;
                                  },
                                  disabled: controller.currentTransaction.value
                                          .supplierId.isEmpty ||
                                      controller.currentTransactionDetail.any(
                                          (detail) =>
                                              detail.employeeId.isEmpty),
                                  backgroundColor: AppColor.primaryColor,
                                  foregroundColor: AppColor.whiteColor,
                                  onPressed: onCheckoutClicked,
                                  child: IntrinsicHeight(
                                    child: Row(
                                      spacing: 5.w,
                                      children: [
                                        Text("Checkout",
                                            style: AppTextStyle
                                                .textSubtitleStyle())
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
            ),
          ],
        )
      : SizedBox.shrink();
}



// DropdownSearch<EmployeeDAO>(
//                               selectedItem: null,
//                               mode: Mode.form,  
//                               suffixProps: DropdownSuffixProps(
//                                 dropdownButtonProps: DropdownButtonProps(
//                                   iconOpened: Icon(Icons.arrow_drop_down),
//                                   iconClosed: Icon(Icons.arrow_drop_down),
//                                   iconSize: 24,
//                                   style: IconButton.styleFrom(
//                                     visualDensity: VisualDensity.compact,
//                                     padding: EdgeInsets.zero,
//                                     tapTargetSize: MaterialTapTargetSize.shrinkWrap
//                                   )
//                                 )
//                               ),
//                               onChanged: (EmployeeDAO? selectedEmployee) {
//                                 if (selectedEmployee != null) {
//                                   print("Selected Employee: ${selectedEmployee.fullName}");
//                                 }
//                               },
//                               items: controller.getEmployees,  
//                                 dropdownBuilder: (BuildContext context, EmployeeDAO? selectedItem) {
//                                   return Text(
//                                     selectedItem?.fullName ?? "Terapis",
//                                     style: AppTextStyle.textBodyStyle(),
//                                   );
//                                 },
//                                 decoratorProps: DropDownDecoratorProps(
//                                   decoration: InputDecoration(
//                                     isDense: true,
//                                     contentPadding: EdgeInsets.only(left: 5.w),
//                                     border: OutlineInputBorder(
//                                       gapPadding: 0,
//                                       borderSide: BorderSide(color: AppColor.grey300),
//                                       borderRadius: BorderRadius.circular(5)
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       gapPadding: 0,
//                                       borderSide: BorderSide(color: AppColor.grey300),
//                                       borderRadius: BorderRadius.circular(5)
//                                     )
//                                   )
//                                 ),
//                               itemAsString: (EmployeeDAO? employee) => employee?.fullName ?? '',
//                               compareFn: (EmployeeDAO a, EmployeeDAO b) => a.empId == b.empId,  
//                               popupProps: PopupProps.menu(
//                                 showSearchBox: true,  
//                                 searchDelay: Duration(milliseconds: 1000), 
//                                 constraints: BoxConstraints(maxHeight: 300),
//                                 itemBuilder: (context, item, isSelected, isFocused) {
//                                   return ListTile(
//                                     title: Text(item.fullName),
//                                     selected: isSelected,  
//                                     tileColor: isFocused ? Colors.grey.shade200 : null, 
//                                   );
//                                 },
//                                 searchFieldProps: TextFieldProps(
//                                   decoration: InputDecoration(
//                                     hintText: "Cari Terapis",
//                                     border: OutlineInputBorder(
//                                       gapPadding: 0,
//                                       borderSide: BorderSide(color: AppColor.grey300),
//                                       borderRadius: BorderRadius.circular(5)
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       gapPadding: 0,
//                                       borderSide: BorderSide(color: AppColor.grey300),
//                                       borderRadius: BorderRadius.circular(5)
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       gapPadding: 0,
//                                       borderSide: BorderSide(color: AppColor.primaryColor),
//                                       borderRadius: BorderRadius.circular(5)
//                                     ),  
//                                     contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),  // Padding inside the search box
//                                   ),
//                                   style: TextStyle(fontSize: 16, color: Colors.black),  // Customize the text style
//                                   autofocus: true, 
//                                 ),
//                               ),
                              
//                               validator: (EmployeeDAO? employee) =>
//                                   employee == null ? "Please select an employee" : null,  // Validation for selection
//                             ),