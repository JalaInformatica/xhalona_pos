import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_screen.dart';
import 'package:xhalona_pos/views/home/fragment/dashboard/dashboard_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/supplier/supplier_kustomer_controller.dart';

// ignore_for_file: unnecessary_null_comparison

class NavSideBar extends StatefulWidget {
  const NavSideBar({super.key});

  @override
  State<NavSideBar> createState() => _NavSideBarState();
}

class _NavSideBarState extends State<NavSideBar> {
  String? baseUrl;
  String? currentVersion;
  bool showMasterSubMenu = false;
  bool showLaporanSubMenu = false;
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      baseUrl = prefs.getString('base')!;
      currentVersion = prefs.getString('version');
      showMasterSubMenu = false;
      showLaporanSubMenu = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'POS',
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Text(
                      "Hi, ",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
              ],
            ),
          ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: ListView(
                    children: [
                      buildMenuItems(context),
                    ],
                  ))),
        ],
      ),
    );
  }

  ListTile _menuTile({
    required int menuIndex,
    required String icon,
    required String text,
    required Function() onTap,
    IconData? trailingIcon,
  }) {
    return ListTile(
      tileColor: AppColor.primaryColor,
      iconColor: Colors.white,
      leading: Image.asset(
        icon,
        width: 24,
        height: 24,
        color: Colors.white,
      ),
      title: Text(text,
          style: AppTextStyle.textSubtitleStyle(color: Colors.white)),
      onTap: onTap,
      trailing:
          trailingIcon != null ? Icon(trailingIcon, color: Colors.white) : null,
    );
  }

  Widget _subMenuTile(
      {required int menuIndex,
      required String text,
      required Function() onTap}) {
    return Container(
      width: double.infinity,
      color: AppColor.secondaryColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 60),
        child: ListTile(
            title: Text(text,
                style: AppTextStyle.textSubtitleStyle(color: Colors.white)),
            onTap: onTap),
      ),
    );
  }

  void navigateFromOtherWidget(BuildContext context, Widget? newScreen) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          previousScreen: newScreen ?? HomeScreen().previousScreen,
        ),
      ),
      (route) => false,
    );
  }

  final HomeController controller = Get.put(HomeController());
  final KustomerController controllerKus = Get.put(KustomerController());

  Widget buildMenuItems(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _menuTile(
                icon:
                    "assets/images/menu/cashier_machine_cash_register_pos_icon_225108.png",
                text: "POS",
                menuIndex: 5,
                onTap: () {
                  controller.selectedMenuName.value = 'pos';
                  navigateFromOtherWidget(context, PosScreen());
                }),
            _menuTile(
              text: "Dashboard",
              icon: "assets/images/menu/view_dashboard_outline_icon_139087.png",
              menuIndex: 0,
              onTap: () {
                controller.selectedMenuName.value = 'dashboard';
                navigateFromOtherWidget(context, DashboardScreen());
              },
            ),
            _menuTile(
              icon:
                  "assets/images/menu/bag_buy_cart_market_shop_shopping_tote_icon_123191.png",
              text: "Transaksi",
              menuIndex: 2,
              onTap: () {
                controller.selectedMenuName.value = 'transaksi';
                navigateFromOtherWidget(context, DashboardScreen());
              },
            ),
            _menuTile(
              icon:
                  "assets/images/menu/business_cash_coin_dollar_finance_money_payment_icon_123244.png",
              text: "Finance",
              menuIndex: 1,
              onTap: () {
                controller.selectedMenuName.value = 'finance';
                navigateFromOtherWidget(context, DashboardScreen());
              },
            ),
            _menuTile(
              icon:
                  "assets/images/menu/avatar_male_man_people_person_profile_user_icon_123199.png",
              text: "Profil",
              menuIndex: 4,
              onTap: () {
                controller.selectedMenuName.value = 'profil';
                navigateFromOtherWidget(context, DashboardScreen());
              },
            ),
            _menuTile(
                icon:
                    "assets/images/menu/product_information_management_icon_149893.png",
                text: "Master",
                menuIndex: -1,
                onTap: () {
                  setState(() {
                    showMasterSubMenu = !showMasterSubMenu;
                    showLaporanSubMenu = false;
                  });
                },
                trailingIcon: showMasterSubMenu
                    ? Icons.arrow_drop_up_sharp
                    : Icons.arrow_drop_down_sharp),
            if (showMasterSubMenu) ...[
              _subMenuTile(
                  text: "Master Product",
                  menuIndex: 6,
                  onTap: () {
                    controller.selectedMenuName.value = 'master_product';
                    controller.subMenuName.value = "Produk";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Master Karyawan",
                  menuIndex: 7,
                  onTap: () {
                    controller.selectedMenuName.value = 'master_karyawan';
                    controller.subMenuName.value = "Karyawan";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Master COA",
                  menuIndex: 6,
                  onTap: () {
                    controller.selectedMenuName.value = 'master_coa';
                    controller.subMenuName.value = "COA";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Master Pengguna",
                  menuIndex: 7,
                  onTap: () {
                    controller.selectedMenuName.value = 'master_pengguna';
                    controller.subMenuName.value = "Pengguna";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Master Pekerjaan",
                  menuIndex: 6,
                  onTap: () {
                    controller.selectedMenuName.value = 'master_pekerjaan';
                    controller.subMenuName.value = "Pekerjaan";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Master Rekening",
                  menuIndex: 7,
                  onTap: () {
                    controller.selectedMenuName.value = 'master_rekening';
                    controller.subMenuName.value = "Rekening";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Master Kustomer",
                  menuIndex: 6,
                  onTap: () {
                    controller.selectedMenuName.value = 'master_customer';
                    controller.subMenuName.value = "Customer";
                    controllerKus.isSuplier.value = "0";
                    controllerKus.fetchProducts();
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Master Supplier",
                  menuIndex: 7,
                  onTap: () {
                    controller.selectedMenuName.value = 'master_supplier';
                    controller.subMenuName.value = "Supplier";
                    controllerKus.isSuplier.value = "1";
                    controllerKus.fetchProducts();
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
            ],
            _menuTile(
              icon:
                  "assets/images/menu/report_document_finance_business_analysis_analytics_chart_icon_188615.png",
              menuIndex: -1,
              text: "Laporan",
              onTap: () {
                setState(() {
                  showLaporanSubMenu = !showLaporanSubMenu;
                  showMasterSubMenu = false;
                });
              },
              trailingIcon: showLaporanSubMenu
                  ? Icons.arrow_drop_up_sharp
                  : Icons.arrow_drop_down_sharp,
            ),
            if (showLaporanSubMenu) ...[
              _subMenuTile(
                  text: "Laporan Penjualan",
                  menuIndex: 8,
                  onTap: () {
                    controller.selectedMenuName.value = 'laporan_penjualan';
                    controller.subMenuName.value = "Laporan Penjualan";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Laporan Finansial",
                  menuIndex: 9,
                  onTap: () {
                    controller.selectedMenuName.value = 'laporan_finansial';
                    controller.subMenuName.value = "Laporan Finansial";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Monitor Penjualan",
                  menuIndex: 8,
                  onTap: () {
                    controller.selectedMenuName.value =
                        'laporan_monitor_penjualan';
                    controller.subMenuName.value = "Monitor Penjualan";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Laporan Stock",
                  menuIndex: 9,
                  onTap: () {
                    controller.selectedMenuName.value = '';
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
            ],
          ],
        ),
        if (!showLaporanSubMenu && !showMasterSubMenu)
          SizedBox(
            height: 130,
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: masterButton(() {}, 'Logout', Icons.logout),
        ),
        Divider(),
        Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              "© POS Xhalon ${currentVersion} | All Rights Reserved",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              ),
            )),
      ],
    );
  }
}
