import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:xhalona_pos/views/authentication/login/login_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/coa/master_coa_screen.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/monitor/monitor_screen.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/finance/lap_finance_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/master_product_screen.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/penjualan/lap_penjualan_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/master_karyawan_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/pengguna/master_pengguna_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/rekening/master_rekening_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/pekerjaan/master_pekerjaan_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/supplier/supplier_kustomer_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/supplier/master_kustomer_supplier_screen.dart';

class AppBottombar extends StatefulWidget {
  const AppBottombar({super.key});

  @override
  State<AppBottombar> createState() => _AppBottombarState();
}

class _AppBottombarState extends State<AppBottombar> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

final HomeController controllerHome = Get.put(HomeController());
final KustomerController controllerKus = Get.put(KustomerController());

void navigateToMenu(String menuName, BuildContext context) {
  switch (menuName.toLowerCase()) {
    case "pos":
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      break;
    case "dashboard":
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      break;
    case "transaksi":
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      break;
    case "finance":
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      break;
    case "profil":
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
      break;
    default:
      // Tidak melakukan apa-apa jika menu tidak dikenali
      break;
  }
}

// Komponen Menu
Widget menuComponent(String menuName, BuildContext context) {
  menuName = menuName.toLowerCase();
  String iconPath = "assets/images/menu/";
  Color iconColor = menuName != controllerHome.selectedMenuName.value
      ? AppColor.grey500
      : AppColor.primaryColor;

  switch (menuName) {
    case "pos":
      iconPath += "cashier_machine_cash_register_pos_icon_225108.png";
      break;
    case "dashboard":
      iconPath += "view_dashboard_outline_icon_139087.png";
      break;
    case "transaksi":
      iconPath += "bag_buy_cart_market_shop_shopping_tote_icon_123191.png";
      break;
    case "finance":
      iconPath +=
          "business_cash_coin_dollar_finance_money_payment_icon_123244.png";
      break;
    case "master":
      iconPath += "product_information_management_icon_149893.png";
      break;
    case "laporan":
      iconPath +=
          "report_document_finance_business_analysis_analytics_chart_icon_188615.png";
      break;
    case "profil":
      iconPath += "avatar_male_man_people_person_profile_user_icon_123199.png";
      break;
  }

  return Obx(() => GestureDetector(
      onTap: () {
        controllerHome.selectedMenuName.value = menuName;
        navigateToMenu(menuName, context); // Navigasi sesuai menu yang dipilih
      },
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.whiteColor,
                    border: menuName != controllerHome.selectedMenuName.value
                        ? null
                        : Border.all(color: AppColor.primaryColor)),
                child: Image.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  color: iconColor,
                )),
            Text(
              menuName != "pos"
                  ? menuName[0].toUpperCase() + menuName.substring(1)
                  : menuName.toUpperCase(),
              style: AppTextStyle.textCaptionStyle(
                  color: menuName != controllerHome.selectedMenuName.value
                      ? AppColor.blackColor
                      : AppColor.primaryColor,
                  fontWeight: menuName != controllerHome.selectedMenuName.value
                      ? FontWeight.normal
                      : FontWeight.bold),
            )
          ]))));
}

Widget mButton(VoidCallback onTap, String label, IconData icon, double? width) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(label, style: AppTextStyle.textTitleStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}

Widget buildFloatingActionButton(BuildContext context, screenWidth) {
  return Obx(
    () => Column(mainAxisSize: MainAxisSize.min, children: [
      controllerHome.selectedMenuName.value.toLowerCase() == "master"
          ? !controllerHome.isOpenMaster.value
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 47,
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Scrollbar(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(width: screenWidth * 0.02),
                          mButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterProductScreen(),
                              ),
                              (route) => false,
                            );
                          }, "Master Produk", Icons.shopping_bag, 170),
                          SizedBox(
                              width: screenWidth * 0.02), // Responsive spacing
                          mButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterKaryawanScreen(),
                              ),
                              (route) => false,
                            );
                          }, "Master Karyawan", Icons.account_circle, 170),
                          SizedBox(width: screenWidth * 0.02),
                          mButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterCoaScreen(),
                              ),
                              (route) => false,
                            );
                          }, "Master Coa", Icons.account_balance, 170),
                          SizedBox(width: screenWidth * 0.02),
                          mButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPenggunaScreen(),
                              ),
                              (route) => false,
                            );
                          }, "Master Pengguna", Icons.person, 170),
                          SizedBox(width: screenWidth * 0.02),
                          mButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPekerjaanScreen(),
                              ),
                              (route) => false,
                            );
                          }, "Master Pekerjaan", Icons.work, 170),
                          SizedBox(width: screenWidth * 0.02),
                          mButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterRekeningScreen(),
                              ),
                              (route) => false,
                            );
                          }, "Master Rekening", Icons.account_balance_wallet,
                              170),
                          SizedBox(width: screenWidth * 0.02),
                          mButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) =>
                                    MasterKustomerScreen(islabel: "Kustomer"),
                              ),
                              (route) => false,
                            );
                            controllerKus.isSuplier.value = "0";
                            controllerKus.fetchProducts();
                          }, "Master Kustomer", Icons.people, 170),
                          SizedBox(width: screenWidth * 0.02),
                          mButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) =>
                                    MasterKustomerScreen(islabel: "Supplier"),
                              ),
                              (route) => false,
                            );
                            controllerKus.isSuplier.value = "1";
                            controllerKus.fetchProducts();
                          }, "Master Supplier", Icons.store, 170),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink()
          : SizedBox.shrink(),
      controllerHome.selectedMenuName.value.toLowerCase() == "laporan"
          ? !controllerHome.isOpenLaporan.value
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 47,
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Scrollbar(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(width: screenWidth * 0.02),
                          mButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LapPenjualanScreen(),
                              ),
                              (route) => false,
                            );
                          }, "Lap. Penjualan", Icons.graphic_eq_sharp, 170),
                          SizedBox(width: screenWidth * 0.02),
                          mButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MonitorScreen(),
                              ),
                              (route) => false,
                            );
                          }, "Monitor Penjualan", Icons.monitor, 170),
                          SizedBox(width: screenWidth * 0.02),
                          mButton(() {}, "Lap. Stock", Icons.inventory, 170),
                          SizedBox(width: screenWidth * 0.02),
                          mButton(() {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LapFinanceScreen(),
                              ),
                              (route) => false,
                            );
                          }, "Lap. Finance", Icons.monetization_on, 170),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink()
          : SizedBox.shrink(),
    ]),
  );
}

Widget buildBottomNavigationBar(BuildContext context) {
  return Obx(
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
                    ...controllerHome.menuData.map((menuItem) {
                      if (menuItem.menuId == "NONMENU") {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: menuItem.dataSubMenu.map((subMenu) {
                            return menuComponent(subMenu.subMenuDesc, context);
                          }).toList(),
                        );
                      }
                      return menuComponent(menuItem.menuDesc, context);
                    }),
                    menuComponent("profil", context)
                  ],
                ),
              ],
            ),
          ),
        ])),
  );
}
