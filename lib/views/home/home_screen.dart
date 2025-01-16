import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xhalona_pos/models/dao/user.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:xhalona_pos/models/dao/structure.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
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
                  Expanded(
                      child: menuScreen(controller.selectedMenuName.value)),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Obx(
                () => Column(mainAxisSize: MainAxisSize.min, children: [
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
            
                ]),
              ),
        bottomNavigationBar: Obx(
                () => Container(
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.grey500,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, 
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.center,
                                runAlignment: WrapAlignment.center,
                                direction: Axis.horizontal,
                                spacing: 10,
                                children: [
                                  ...controller.menuData.map((menuItem) {
                                    if (menuItem.menuId == "NONMENU") {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children:
                                            menuItem.dataSubMenu.map((subMenu) {
                                          return menuComponent(
                                              subMenu.subMenuDesc);
                                        }).toList(),
                                      );
                                    }
                                    return menuComponent(menuItem.menuDesc);
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                  ])
                ),
              ),      
        );
        }
      }),
    );
  }
}

