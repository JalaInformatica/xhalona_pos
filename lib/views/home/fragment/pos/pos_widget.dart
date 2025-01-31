import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_controller.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/widgets/app_image.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_pdf_viewer.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';

AppTextField posTextField({
  required BuildContext context,
  required TextEditingController textEditingController,
  required labelText,
  bool isReadOnly = false,
}) {
  return AppTextField(
    context: context,
    textEditingController: textEditingController,
    labelText: labelText,
    contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
    readOnly: isReadOnly,
  );
}

AppElevatedButton posAppButton(
    {required String text, required VoidCallback onPressed}) {
  return AppElevatedButton(
      backgroundColor: AppColor.whiteColor,
      foregroundColor: AppColor.primaryColor,
      borderColor: AppColor.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      onPressed: onPressed,
      text: Text(text));
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    color: product.isPacket? AppColor.dangerColor.withAlpha(200) : product.isFixQty? AppColor.secondaryColor.withAlpha(200) : AppColor.blackColor.withAlpha(200),
                  ),
                  child: Icon(product.isPacket? Icons.all_inbox: product.isFixQty? Icons.face_retouching_natural : Icons.shopping_bag, size: 15, color: AppColor.whiteColor,),
                )
              ],
            ),
            SizedBox(height: 5.h,),
            Text(product.partName, style: AppTextStyle.textBodyStyle(fontFamily: 'GoogleSans', fontWeight: FontWeight.bold),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatToRupiah(product.unitPriceNet), style: AppTextStyle.textBodyStyle(color: AppColor.doneColor),),
                Text(formatToRupiah(product.unitPrice), style: AppTextStyle.textCaptionStyle(color: AppColor.dangerColor, decoration: TextDecoration.lineThrough),)
              ],
            ),
            SizedBox(height: 5.h,),
            SizedBox(
              width: double.maxFinite,
              child: AppTextButton(onPressed: (){
                if (!controller.isAddingProductToTrx.value) {
                  controller.addProductToTrx(product);
                  SmartDialog.show(builder: (_){
                    return AppDialog(
                      content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Menambahkan", style: AppTextStyle.textSubtitleStyle(),),
                        SizedBox(height: 10.h,),
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
                                color: product.isPacket? AppColor.dangerColor.withAlpha(200) : product.isFixQty? AppColor.secondaryColor.withAlpha(200) : AppColor.blackColor.withAlpha(200),
                              ),
                              child: Icon(product.isPacket? Icons.all_inbox: product.isFixQty? Icons.face_retouching_natural : Icons.shopping_bag, size: 15, color: AppColor.whiteColor,),
                            )
                          ],
                        ),
                        SizedBox(height: 5.h,),
                        Text(product.partName, style: AppTextStyle.textBodyStyle(fontFamily: 'GoogleSans', fontWeight: FontWeight.bold),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5.w,
                          children: [
                            Text(formatToRupiah(product.unitPriceNet), style: AppTextStyle.textBodyStyle(color: AppColor.doneColor),),
                            Text(formatToRupiah(product.unitPrice), style: AppTextStyle.textCaptionStyle(color: AppColor.dangerColor, decoration: TextDecoration.lineThrough),)
                          ],  
                        ),]
                    ));
                  });
                  Future.delayed(Duration(seconds: 2), () {
                    SmartDialog.dismiss();
                  });
                }
              }, child: Text("Tambah Pesanan", style: AppTextStyle.textBodyStyle(),)))
          ]
        )
      );
}

Widget transaction(
    {required PosController controller,
    required Function(String) onTerapisClicked,
    required VoidCallback onCheckoutClicked,
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
                    "Transaksi",
                    style: AppTextStyle.textSubtitleStyle(
                      color: AppColor.whiteColor,
                    ),
                  ),
                  Spacer(),
                  AppTextButton(
                    onPressed: () {},
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
            Container(
              color: AppColor.whiteColor,
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 10.w,
              ),
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 5.h,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
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
                                      child: Text(currentTrxDetail.partName),
                                    ),
                                    Expanded(
                                      child: AppTextButton(
                                        onPressed: () => onTerapisClicked(
                                            currentTrxDetail.rowId),
                                        borderColor: AppColor.grey300,
                                        foregroundColor: AppColor.blackColor,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              currentTrxDetail.employeeName1 ??
                                                  "Terapis",
                                              style:
                                                  AppTextStyle.textBodyStyle(),
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
                                      onPressed: () {
                                        controller.deleteProductFromTrx(
                                            currentTrxDetail.rowId);
                                      },
                                      icon: controller
                                              .isDeletingProductFromTrx.value
                                          ? SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                color: AppColor.whiteColor,
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
                                            TextEditingController(),
                                        labelText: "Note",
                                      ),
                                    ),
                                    Expanded(
                                      child: posTextField(
                                          context: context,
                                          textEditingController:
                                              TextEditingController()
                                                ..text = currentTrxDetail
                                                    .nettoVal
                                                    .toString(),
                                          labelText: "Harga",
                                          isReadOnly:
                                              currentTrxDetail.isFixPrice),
                                    ),
                                    Expanded(
                                      child: posTextField(
                                        context: context,
                                        textEditingController:
                                            TextEditingController(),
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
                        onPressed: () {
                          SmartDialog.show(builder: (_){
                            return AppDialog(
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                spacing: 5.h,
                                children: [
                                  Text("Member", style: AppTextStyle.textSubtitleStyle(),),
                                  AppTextField(
                                    context: context,
                                    hintText: "Cari Member",
                                    onChanged: (_){},
                                    autofocus: true,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(child: AppTextButton(
                                        foregroundColor: AppColor.blackColor,
                                        onPressed: () {
                                        },
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Ujang Bahrun",
                                          style: AppTextStyle.textBodyStyle(),
                                        ),
                                        shape: BeveledRectangleBorder(
                                          side: BorderSide(color: AppColor.grey100)
                                        ),
                                      )),
                                      AppIconButton(
                                        onPressed: (){},
                                        shape: RoundedRectangleBorder(),
                                        backgroundColor: AppColor.primaryColor,
                                        icon: Icon(Icons.edit, color: AppColor.whiteColor,))
                                    ]
                                  ),
                                  Row(
                                    children: [
                                      Expanded(child: AppTextButton(
                                        foregroundColor: AppColor.blackColor,
                                        onPressed: () {
                                        },
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Ifah Barkoh",
                                          style: AppTextStyle.textBodyStyle(),
                                        ),
                                        shape: BeveledRectangleBorder(
                                          side: BorderSide(color: AppColor.grey100)
                                        ),
                                      )),
                                      AppIconButton(
                                        onPressed: (){},
                                        shape: RoundedRectangleBorder(),
                                        backgroundColor: AppColor.primaryColor,
                                        icon: Icon(Icons.edit, color: AppColor.whiteColor,))
                                    ]
                                  ),
                                  Row(
                                    children: [
                                      Expanded(child: AppTextButton(
                                        foregroundColor: AppColor.blackColor,
                                        onPressed: () {
                                        },
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Mahalini",
                                          style: AppTextStyle.textBodyStyle(),
                                        ),
                                        shape: BeveledRectangleBorder(
                                          side: BorderSide(color: AppColor.grey100)
                                        ),
                                      )),
                                      AppIconButton(
                                        onPressed: (){},
                                        shape: RoundedRectangleBorder(),
                                        backgroundColor: AppColor.primaryColor,
                                        icon: Icon(Icons.edit, color: AppColor.whiteColor,))
                                    ]
                                  ),
                                  Row(
                                    children: [
                                      Expanded(child: AppTextButton(
                                        foregroundColor: AppColor.blackColor,
                                        onPressed: () {
                                        },
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Ferdi Irawan",
                                          style: AppTextStyle.textBodyStyle(),
                                        ),
                                        shape: BeveledRectangleBorder(
                                          side: BorderSide(color: AppColor.grey100)
                                        ),
                                      )),
                                      AppIconButton(
                                        onPressed: (){},
                                        shape: RoundedRectangleBorder(),
                                        backgroundColor: AppColor.primaryColor,
                                        icon: Icon(Icons.edit, color: AppColor.whiteColor,))
                                    ]
                                  ),
                                  SizedBox(height: 5.h),
                                  Text("Tambah/Edit Member", style: AppTextStyle.textSubtitleStyle(),),
                                  AppTextField(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                    context: context, labelText: "Nama Customer*",),
                                  AppTextField(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                    context: context, labelText: "Nomor Handphone/Telp",),
                                  AppTextField(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                    context: context, labelText: "Keterangan",),
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: AppElevatedButton(
                                      backgroundColor: AppColor.primaryColor,
                                      foregroundColor: AppColor.whiteColor,
                                      onPressed: (){}, 
                                      text: Text("Simpan")
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                        },
                        text: "Member",
                      ),
                      posAppButton(
                        onPressed: () {
                          SmartDialog.show(builder: (_){
                            return AppDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 15.h,
                                children: [
                                  Text("Tamu", style: AppTextStyle.textSubtitleStyle(),),
                                  AppTextField(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                    context: context, labelText: "Nama Customer*",),
                                  AppTextField(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                    context: context, labelText: "Nomor Handphone/Telp",),
                                  AppTextField(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                    context: context, labelText: "Keterangan",),
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: AppElevatedButton(
                                      backgroundColor: AppColor.primaryColor,
                                      foregroundColor: AppColor.whiteColor,
                                      onPressed: (){}, 
                                      text: Text("Simpan")
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                        },
                        text: "Tamu",
                      ),
                      posAppButton(
                        onPressed: () {},
                        text: "Diskon",
                      ),
                      posAppButton(text: "Batal", onPressed: () {})
                    ],
                  ),
                  IntrinsicHeight(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  Icon(Icons.event_seat,
                                      color: AppColor.primaryColor),
                                  Text("Antrian",
                                      style: AppTextStyle.textBodyStyle())
                                ],
                              ),
                            ),
                            AppTextButton(
                              foregroundColor: AppColor.primaryColor,
                              onPressed: () {
                                controller.printNota().then((url) => {
                                      print(url)
                                      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AppPDFViewer(pdfUrl: url)));
                                    });
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
                        ),
                      ),
                      AppElevatedButton(
                        size: AppElevatedButtonSize.big,
                        backgroundColor: AppColor.primaryColor,
                        foregroundColor: AppColor.whiteColor,
                        onPressed: onCheckoutClicked,
                        text: Row(
                          spacing: 5.w,
                          children: [
                            Icon(Icons.payment_outlined,
                                color: AppColor.whiteColor),
                            Text("Checkout",
                                style: AppTextStyle.textSubtitleStyle())
                          ],
                        ),
                      ),
                    ],
                  )),
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