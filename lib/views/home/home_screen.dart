import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/master_kustomer_screen.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/nav_sidebar.dart';
import 'fragment/laporan/monitor/monitor_screen.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_screen.dart';
import 'package:xhalona_pos/views/authentication/login/login_screen.dart';
import 'package:xhalona_pos/views/home/fragment/profile/profile_screen.dart';
import 'package:xhalona_pos/views/home/fragment/finance/finance_screen.dart';
import 'package:xhalona_pos/views/home/fragment/profile/settings_screen.dart';
import 'package:xhalona_pos/views/home/fragment/profile/change_password.dart';
import 'package:xhalona_pos/views/home/fragment/dashboard/dashboard_screen.dart';
import 'package:xhalona_pos/views/home/fragment/profile/profile_page_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/coa/master_coa_screen.dart';
import 'package:xhalona_pos/views/home/fragment/transaction/transaction_screen.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/finance/lap_finance_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/master_product_screen.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/penjualan/lap_penjualan_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/pengguna/master_pengguna_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/rekening/master_rekening_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/master_karyawan_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/pekerjaan/master_pekerjaan_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/supplier/master_supplier_screen.dart';
// ignore_for_file: use_build_context_synchronously

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  Widget? previousScreen;
  HomeScreen({this.previousScreen});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget? currentScreen;
  Widget menuScreen(String menuName) {
    Widget screen;

    switch (menuName.toLowerCase()) {
      case "pos":
        controller.subMenuName.value = "";
        screen = PosScreen();
        break;
      case "dashboard":
        controller.subMenuName.value = "";
        screen = DashboardScreen();
        break;
      case "transaksi":
        controller.subMenuName.value = "";
        screen = TransactionScreen();
        break;
      case "finance":
        controller.subMenuName.value = "";
        screen = FinanceScreen();
        break;
      case "profil":
        controller.subMenuName.value = "";
        screen = ProfilePageScreen();
        break;
      case "master_product":
        controller.subMenuName.value = "Produk";
        screen = MasterProductScreen();
        break;
      case "master_karyawan":
        controller.subMenuName.value = "Karyawan";
        screen = MasterKaryawanScreen();
        break;
      case "master_coa":
        controller.subMenuName.value = "COA";
        screen = MasterCoaScreen();
        break;
      case "master_pengguna":
        controller.subMenuName.value = "Pengguna";
        screen = MasterPenggunaScreen();
        break;
      case "master_pekerjaan":
        controller.subMenuName.value = "Pekerjaan";
        screen = MasterPekerjaanScreen();
        break;
      case "master_rekening":
        controller.subMenuName.value = "Rekening";
        screen = MasterRekeningScreen();
        break;
      case "master_customer":
        controller.subMenuName.value = "Customer";
        screen = MasterKustomerScreen();
        break;
      case "master_supplier":
        controller.subMenuName.value = "Supplier";
        screen = MasterSupplierScreen();
        break;
      case "laporan_penjualan":
        controller.subMenuName.value = "Laporan Penjualan";
        screen = LapPenjualanScreen();
        break;
      case "laporan_monitor_penjualan":
        controller.subMenuName.value = "Monitor Penjualan";
        screen = MonitorScreen();
        break;
      // case "laporan_stock":
      // screen = MonitorScreen();
      // break;
      case "laporan_finansial":
        controller.subMenuName.value = "Laporan Finansial";
        screen = LapFinanceScreen();
        break;
      default:
        return TransactionScreen();
    }

    if (screen != widget.previousScreen && screen != null) {
      widget.previousScreen = screen;
    } // Simpan halaman terakhir sebelum berpindah
    return screen;
  }

  void navigateToScreen(Widget? newScreen) {
    if (newScreen != null) {
      setState(() {
        widget.previousScreen = newScreen;
        currentScreen = newScreen;
      });
    } else if (widget.previousScreen != null) {
      setState(() {
        currentScreen = widget.previousScreen;
      });
    }
  }

  Widget menuComponent(String menuName, BuildContext context) {
    menuName = menuName.toLowerCase();
    String iconPath = "assets/images/menu/";
    Color iconColor = !controller.selectedMenuName.value.contains(menuName)
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
        iconPath +=
            "avatar_male_man_people_person_profile_user_icon_123199.png";
        break;
    }
    return Obx(() => GestureDetector(
        onTap: () {
          if (menuName != "laporan" && menuName != "master") {
            controller.selectedMenuName.value = menuName;
          } else if (menuName == "master") {
            SmartDialog.show(builder: (context) {
              return AppDialog(
                content: Column(
                  spacing: 10.h,
                  children: [
                    subMenuButton(
                      value: "master_product",
                      label: "Produk",
                      icon: Icons.shopping_bag,
                    ),
                    subMenuButton(
                      value: "master_karyawan",
                      label: "Karyawan",
                      icon: Icons.account_circle,
                    ),
                    subMenuButton(
                      value: "master_coa",
                      label: "COA",
                      icon: Icons.account_balance,
                    ),
                    subMenuButton(
                      value: "master_pengguna",
                      label: "Pengguna",
                      icon: Icons.person,
                    ),
                    subMenuButton(
                      value: "master_pekerjaan",
                      label: "Pekerjaan",
                      icon: Icons.work,
                    ),
                    subMenuButton(
                      value: "master_rekening",
                      label: "Rekening",
                      icon: Icons.account_balance_wallet,
                    ),
                    subMenuButton(
                      value: "master_customer",
                      label: "Kustomer",
                      icon: Icons.people,
                    ),
                    subMenuButton(
                      value: "master_supplier",
                      label: "Supplier",
                      icon: Icons.store,
                    ),
                  ],
                ),
              );
            });
          } else if (menuName == "laporan") {
            SmartDialog.show(builder: (context) {
              return AppDialog(
                content: Column(
                  spacing: 10.h,
                  children: [
                    subMenuButton(
                      value: "laporan_penjualan",
                      label: "Laporan Penjualan",
                      icon: Icons.graphic_eq_sharp,
                    ),
                    subMenuButton(
                      value: "laporan_monitor_penjualan",
                      label: "Monitor Penjualan",
                      icon: Icons.monitor,
                    ),
                    subMenuButton(
                      label: "Laporan Stock",
                      value: "laporan_stock",
                      icon: Icons.inventory,
                    ),
                    subMenuButton(
                      value: "laporan_finansial",
                      label: "Laporan Finance",
                      icon: Icons.monetization_on,
                    ),
                  ],
                ),
              );
            });
          }
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
                      border:
                          !controller.selectedMenuName.value.contains(menuName)
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
                    color: !controller.selectedMenuName.value.contains(menuName)
                        ? AppColor.blackColor
                        : AppColor.primaryColor,
                    fontWeight:
                        !controller.selectedMenuName.value.contains(menuName)
                            ? FontWeight.normal
                            : FontWeight.bold),
              )
            ]))));
  }

  Widget profileInfo(
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return Obx(() => Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10.w),
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
          ),
          child: Row(
            children: [
              AppIconButton(
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
                icon: Icon(Icons.menu),
                foregroundColor: AppColor.whiteColor,
              ),
              Text(
                controller.subMenuName.value,
                style:
                    AppTextStyle.textSubtitleStyle(color: AppColor.whiteColor),
              ),
              Spacer(),
              AppIconButton(
                foregroundColor: AppColor.whiteColor,
                onPressed: () {
                  controller.selectedMenuName.value = "transaksi";
                },
                icon: Badge.count(
                  textStyle: AppTextStyle.textCaptionStyle(
                      fontWeight: FontWeight.bold),
                  textColor: AppColor.blackColor,
                  backgroundColor: AppColor.warningColor,
                  count: controller.todayTrx.value,
                  child: Icon(Icons.shopping_bag),
                ),
              ),
              AppIconButton(
                foregroundColor: AppColor.whiteColor,
                onPressed: () {},
                icon: Icon(Icons.notifications),
              ),
              GestureDetector(
                onTap: () {
                  showMenu(
                    color: Colors.white,
                    context: context,
                    position: RelativeRect.fromLTRB(100, 100, 0, 0),
                    items: [
                      PopupMenuItem(
                        value: "change",
                        child: Text("Ganti Password"),
                      ),
                      PopupMenuItem(
                        value: "settings",
                        child: Text("Settings"),
                      ),
                      PopupMenuItem(
                        value: "logout",
                        child: Text("Logout"),
                      ),
                    ],
                  ).then((value) {
                    if (value == "logout") {
                      controller.logout();
                      Get.reset();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false);
                    } else if (value == "settings") {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => SettingScreen()),
                          (route) => false);
                    } else if (value == "change") {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => EditPassword()),
                          (route) => false);
                    }
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.profileData.value.companyId,
                      style: AppTextStyle.textBodyStyle(
                        color: AppColor.whiteColor,
                      ),
                    ),
                    Text(
                      controller.profileData.value.userName,
                      style: AppTextStyle.textCaptionStyle(
                        color: AppColor.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget subMenuButton(
      {required String value, required String label, required IconData icon}) {
    return AppElevatedButton(
      onPressed: () {
        controller.selectedMenuName.value = value;
        SmartDialog.dismiss();
      },
      backgroundColor: controller.selectedMenuName.value != value
          ? AppColor.whiteColor
          : AppColor.secondaryColor,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      child: Row(
        children: [
          Icon(
            icon,
            color: controller.selectedMenuName.value != value
                ? AppColor.primaryColor
                : AppColor.whiteColor,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(label,
              style: AppTextStyle.textSubtitleStyle(
                fontWeight: FontWeight.normal,
                color: controller.selectedMenuName.value != value
                    ? AppColor.primaryColor
                    : AppColor.whiteColor,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() =>
        Scaffold(
            key: _scaffoldKey,
            drawer: NavSideBar(),
            backgroundColor: AppColor.whiteColor,
            body: Column(
              children: [
                profileInfo(context, _scaffoldKey),
                Expanded(child: menuScreen(controller.selectedMenuName.value)),
              ],
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
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 10.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...controller.menuData.map((menuItem) {
                          if (menuItem.menuId == "NONMENU") {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: menuItem.dataSubMenu.map((subMenu) {
                                return menuComponent(
                                    subMenu.subMenuDesc, context);
                              }).toList(),
                            );
                          }
                          return menuComponent(menuItem.menuDesc, context);
                        }),
                        if(controller.menuData.isNotEmpty)
                        menuComponent("profil", context)
                      ],
                    ),
                  ),
              ),
            ),
          )
      ),
    );
  }
}
