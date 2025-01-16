import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_screen.dart';
import 'package:xhalona_pos/views/home/fragment/finance/finance_screen.dart';
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

  Widget masterButton(VoidCallback onPressed, String label, IconData icon) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.secondaryColor, // Background color
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
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                Expanded(child: menuScreen(controller.selectedMenuName.value)),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Obx(
              () => Column(mainAxisSize: MainAxisSize.min, children: [
                controller.selectedMenuName.value.toLowerCase() == "master"
                    ? !controller.isOpenMaster.value
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              color: Colors.yellow,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Scrollbar(
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    SizedBox(width: screenWidth * 0.02),
                                    masterButton(
                                      () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MasterProductScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      "Master Produk",
                                      Icons.shopping_bag,
                                    ),
                                    SizedBox(
                                        width: screenWidth *
                                            0.02), // Responsive spacing
                                    masterButton(
                                      () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MasterKaryawanScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      "Master Karyawan",
                                      Icons.account_circle,
                                    ),
                                    SizedBox(width: screenWidth * 0.02),
                                    masterButton(
                                      () {},
                                      "Master Coa",
                                      Icons.account_balance,
                                    ),
                                    SizedBox(width: screenWidth * 0.02),
                                    masterButton(
                                      () {},
                                      "Master Pengguna",
                                      Icons.person,
                                    ),
                                    SizedBox(width: screenWidth * 0.02),
                                    masterButton(
                                      () {},
                                      "Master Terapis",
                                      Icons.healing,
                                    ),
                                  ],
                                ),
                              ),
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
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                        menuItem.dataSubMenu.map((subMenu) {
                                      return menuComponent(subMenu.subMenuDesc);
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
                  ])),
            ),
          );
        }
      }),
    );
  }
}
