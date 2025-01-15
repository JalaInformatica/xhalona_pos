import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xhalona_pos/models/dao/user.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_button.dart';
import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:xhalona_pos/models/dao/structure.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:xhalona_pos/repositories/user/user_repository.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_screen.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_screen.dart';
import 'package:xhalona_pos/repositories/employee/employee_repository.dart';
import 'package:xhalona_pos/views/home/fragment/finance/finance_screen.dart';
import 'package:xhalona_pos/repositories/structure/structure_repository.dart';
import 'package:xhalona_pos/views/home/fragment/dashboard/dashboard_screen.dart';
import 'package:xhalona_pos/views/home/fragment/transaction/transaction_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/master_product_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/master_karyawan_screen.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  Widget menuScreen(String menuName) {
    switch (menuName.toLowerCase()) {
      case "pos":
        return PosScreen();
      case "dashboard":
        return DashboardScreen();
      case "transaksi":
        return TransactionScreen();
      case "finance":
        return FinanceScreen();
      default:
        return TransactionScreen();
    }
  }

  Widget menuComponent(String menuName) {
    menuName = menuName.toLowerCase();
    String iconPath = "assets/images/menu/";
    late Color iconColor;
    switch (menuName) {
      case "pos":
        iconPath += "cashier.png";
        iconColor = menuName != controller.selectedMenuName.value
            ? Colors.green.shade100
            : AppColor.whiteColor;
        break;
      case "dashboard":
        iconPath += "report_data.png";
        iconColor = menuName != controller.selectedMenuName.value
            ? Colors.blue.shade100
            : AppColor.whiteColor;
        break;
      case "transaksi":
        iconPath += "shopping_bag.png";
        iconColor = menuName != controller.selectedMenuName.value
            ? Colors.orange.shade100
            : AppColor.whiteColor;
        break;
      case "finance":
        iconPath += "coin_dollar.png";
        iconColor = menuName != controller.selectedMenuName.value
            ? Colors.orange.shade100
            : AppColor.whiteColor;
        break;
      case "master":
        iconPath += "documentation.png";
        iconColor = menuName != controller.selectedMenuName.value
            ? Colors.blueGrey.shade100
            : AppColor.whiteColor;
        break;
      case "laporan":
        iconPath += "task_document.png";
        iconColor = menuName != controller.selectedMenuName.value
            ? Colors.blue.shade100
            : AppColor.whiteColor;
        break;
    }
    return Obx(() => GestureDetector(
        onTap: () {
          controller.selectedMenuName.value = menuName;
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                padding: EdgeInsets.only(top: 5, left: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: iconColor,
                    border: menuName == controller.selectedMenuName.value
                        ? Border(
                            top: BorderSide(
                                width: 2, color: AppColor.secondaryColor),
                            left: BorderSide(
                                width: 2, color: AppColor.secondaryColor))
                        : null),
                child: Image.asset(
                  iconPath,
                  width: 28,
                  height: 28,
                ),
              ),
              Text(
                menuName[0].toUpperCase() + menuName.substring(1),
                style: AppTextStyle.textCaptionStyle(
                    color: menuName != controller.selectedMenuName.value
                        ? AppColor.blackColor
                        : AppColor.primaryColor,
                    fontWeight: menuName != controller.selectedMenuName.value
                        ? FontWeight.normal
                        : FontWeight.bold),
              )
            ]))));
  }

  Widget profileInfo() {
    return Obx(() => GestureDetector(
        onTap: () {},
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.whiteColor,
                ),
                child: Icon(
                  Icons.person,
                  size: 28,
                ),
              ),
              Text(
                controller.profileData.value.userName,
                style: AppTextStyle.textCaptionStyle(
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.normal,
                ),
              )
            ]))));
  }

  Widget masterButton(Function() menu, String title, Widget icon) {
    return ElevatedButton(
        onPressed: menu,
        style: TextButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(
              width: 5.w,
            ),
            Text(
              title,
              style: AppTextStyle.textSubtitleStyle(color: AppColor.whiteColor),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        if (controller.isMenuLoading.value) {
          return Scaffold(
              backgroundColor: AppColor.whiteColor,
              body: Center(child: CircularProgressIndicator()));
        } else {
          return Scaffold(
              backgroundColor: AppColor.whiteColor,
              body: Column(
                children: [
                  // profileInfo(),
                  Expanded(child: PosScreen()), // Replace with PosScreen
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    controller.selectedMenuName.value.toLowerCase() == "pos"
                        ? !controller.isOpenTransaksi.value
                            ? ElevatedButton(
                                onPressed: () {
                                  controller.isOpenTransaksi.value = true;
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColor.primaryColor,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.shopping_bag,
                                      color: AppColor.whiteColor,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      "Transaksi",
                                      style: AppTextStyle.textSubtitleStyle(
                                          color: AppColor.whiteColor),
                                    ),
                                  ],
                                ))
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColor.whiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 1,
                                          spreadRadius: 1,
                                          color: AppColor.grey500)
                                    ]),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 10.w),
                                          decoration: BoxDecoration(
                                            color: AppColor.primaryColor,
                                          ),
                                          child: Row(
                                            children: [
                                              Text("Transaksi",
                                                  style: AppTextStyle
                                                      .textSubtitleStyle(
                                                          color: AppColor
                                                              .whiteColor)),
                                              Spacer(),
                                              AppIconButton(
                                                  onPressed: () {},
                                                  foregroundColor:
                                                      AppColor.whiteColor,
                                                  padding: EdgeInsets.zero,
                                                  icon:
                                                      Icon(Icons.shopping_bag))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 10.w),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child:
                                                          Text("Potong Biasa")),
                                                  Expanded(
                                                    child: DropdownSearch<
                                                        EmployeeDAO>(
                                                      selectedItem: null,
                                                      mode: Mode.form,
                                                      onChanged: (EmployeeDAO?
                                                          selectedEmployee) {
                                                        if (selectedEmployee !=
                                                            null) {
                                                          print(
                                                              "Selected Employee: ${selectedEmployee.fullName}");
                                                        }
                                                      },
                                                      items: controller
                                                          .getEmployees,
                                                      decoratorProps:
                                                          DropDownDecoratorProps(
                                                              decoration:
                                                                  InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                      )),
                                                      dropdownBuilder:
                                                          (BuildContext context,
                                                              EmployeeDAO?
                                                                  selectedItem) {
                                                        return Text(
                                                          selectedItem
                                                                  ?.fullName ??
                                                              "Terapis",
                                                          style: AppTextStyle
                                                              .textBodyStyle(),
                                                        );
                                                      },
                                                      itemAsString:
                                                          (EmployeeDAO?
                                                                  employee) =>
                                                              employee
                                                                  ?.fullName ??
                                                              '',
                                                      compareFn: (EmployeeDAO a,
                                                              EmployeeDAO b) =>
                                                          a.empId == b.empId,
                                                      popupProps:
                                                          PopupProps.menu(
                                                        showSearchBox: true,
                                                        searchDelay: Duration(
                                                            milliseconds: 1000),
                                                        constraints:
                                                            BoxConstraints(
                                                                maxHeight: 300),
                                                        itemBuilder: (context,
                                                            item,
                                                            isSelected,
                                                            isFocused) {
                                                          return ListTile(
                                                            title: Text(
                                                                item.fullName),
                                                            selected:
                                                                isSelected,
                                                            tileColor: isFocused
                                                                ? Colors.grey
                                                                    .shade200
                                                                : null,
                                                          );
                                                        },
                                                        searchFieldProps:
                                                            TextFieldProps(
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "Cari Terapis", // Placeholder text in the search box
                                                            border:
                                                                OutlineInputBorder(), // Border for search box
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                    vertical:
                                                                        8.0,
                                                                    horizontal:
                                                                        12.0), // Padding inside the search box
                                                          ),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black), // Customize the text style
                                                          autofocus:
                                                              true, // Make the search field auto-focused
                                                        ),
                                                      ),
                                                      validator: (EmployeeDAO?
                                                              employee) =>
                                                          employee == null
                                                              ? "Please select an employee"
                                                              : null, // Validation for selection
                                                    ),
                                                  ),
                                                  AppIconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons.add)),
                                                  AppIconButton(
                                                      backgroundColor:
                                                          AppColor.dangerColor,
                                                      foregroundColor:
                                                          AppColor.whiteColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      onPressed: () {},
                                                      icon: Icon(Icons.delete))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: AppTextField(
                                                      context: context,
                                                      textEditingController:
                                                          TextEditingController(),
                                                      labelText: "Note",
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.w,
                                                              vertical: 5.h),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Expanded(
                                                      child: AppTextField(
                                                    context: context,
                                                    textEditingController:
                                                        TextEditingController(),
                                                    labelText: "Harga",
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.w,
                                                            vertical: 5.h),
                                                  )),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Expanded(
                                                      child: AppTextField(
                                                    context: context,
                                                    textEditingController:
                                                        TextEditingController(),
                                                    labelText: "Diskon",
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.w,
                                                            vertical: 5.h),
                                                  )),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Wrap(
                                          spacing: 5.w,
                                          direction: Axis.horizontal,
                                          children: [
                                            AppElevatedButton(
                                                backgroundColor:
                                                    AppColor.primaryColor,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w),
                                                onPressed: () {},
                                                text: Text(
                                                  "Transaksi Baru",
                                                  style: AppTextStyle
                                                      .textBodyStyle(
                                                          color: AppColor
                                                              .whiteColor),
                                                )),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColor.primaryColor,
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    padding: EdgeInsets.zero,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))),
                                                onPressed: () {},
                                                child: Text(
                                                  "Member",
                                                  style: AppTextStyle
                                                      .textBodyStyle(
                                                          color: AppColor
                                                              .whiteColor),
                                                )),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColor.primaryColor,
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    padding: EdgeInsets.zero,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))),
                                                onPressed: () {},
                                                child: Text(
                                                  "Tamu",
                                                  style: AppTextStyle
                                                      .textBodyStyle(
                                                          color: AppColor
                                                              .whiteColor),
                                                )),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColor.primaryColor,
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    padding: EdgeInsets.zero,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))),
                                                onPressed: () {},
                                                child: Text(
                                                  "Diskon",
                                                  style: AppTextStyle
                                                      .textBodyStyle(
                                                          color: AppColor
                                                              .whiteColor),
                                                )),
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              controller.isOpenTransaksi.value =
                                                  false;
                                            },
                                            icon: Icon(Icons.arrow_drop_down))
                                      ],
                                    )
                                  ],
                                ),
                              )
                        : SizedBox.shrink(),
                    controller.selectedMenuName.value.toLowerCase() == "master"
                        ? !controller.isOpenMaster.value
                            ? Container(
                                height: 50,
                                width: double.infinity,
                                padding: EdgeInsets.all(5),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    masterButton(() {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MasterProductScreen()),
                                          (route) => false);
                                    },
                                        "Master Produk",
                                        Icon(Icons.shopping_bag,
                                            color: Colors.white)),
                                    SizedBox(width: 5.w),
                                    masterButton(() {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MasterKaryawanScreen()),
                                          (route) => false);
                                    },
                                        "Master Karyawan",
                                        Icon(Icons.account_circle,
                                            color: Colors.white)),
                                    SizedBox(width: 5.w),
                                    masterButton(
                                        () {},
                                        "Master Coa",
                                        Icon(Icons.account_balance,
                                            color: Colors.white)),
                                    SizedBox(width: 5.w),
                                    masterButton(
                                        () {},
                                        "Master Pengguna",
                                        Icon(Icons.shopping_bag,
                                            color: Colors.white)),
                                    SizedBox(width: 5.w),
                                    masterButton(
                                        () {},
                                        "Master Terapis",
                                        Icon(Icons.shopping_bag,
                                            color: Colors.white)),
                                  ],
                                ),
                              )
                            : SizedBox.shrink()
                        : SizedBox.shrink(),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.grey500,
                              blurRadius: 1,
                            )
                          ]),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                            direction: Axis.horizontal,
                            spacing: 10,
                            children: [
                              ...controller.menuData.map((menuItem) {
                                if (menuItem.menuId == "NONMENU") {
                                  return Row(
                                    children:
                                        menuItem.dataSubMenu.map((subMenu) {
                                      return menuComponent(subMenu.subMenuDesc);
                                    }).toList(),
                                  );
                                }
                                return menuComponent(menuItem.menuDesc);
                              }),
                              // profileInfo()
                            ]),
                      ),
                    ),
                  ],
                ),
              ));
        }
      }),
    );
  }
}
