import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_screen.dart';
import 'package:xhalona_pos/views/authentication/login/login_screen.dart';
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
      if (controller.selectedMenuName.value == 'laporan_penjualan' ||
          controller.selectedMenuName.value == 'laporan_finansial' ||
          controller.selectedMenuName.value == 'laporan_monitor_penjualan')
        showLaporanSubMenu = true;

      if (controller.selectedMenuName.value == 'master_product' ||
          controller.selectedMenuName.value == 'master_karyawan' ||
          controller.selectedMenuName.value == 'master_coa' ||
          controller.selectedMenuName.value == 'master_pengguna' ||
          controller.selectedMenuName.value == 'master_pekerjaan' ||
          controller.selectedMenuName.value == 'master_rekening' ||
          controller.selectedMenuName.value == 'master_customer' ||
          controller.selectedMenuName.value == 'master_supplier')
        showMasterSubMenu = true;
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
                      "Hi, ${controller.profileData.value.userName} ",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                Divider()
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

  Widget _menuTile({
    required String menuIndex,
    required String icon,
    required String text,
    required Function() onTap,
    IconData? trailingIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5),
      child: Material(
        color: controller.selectedMenuName.value != menuIndex
            ? Colors.transparent
            : AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              iconColor: Colors.white,
              leading: Image.asset(
                icon,
                width: 24,
                height: 24,
                color: Colors.white,
              ),
              title: Text(
                text,
                style: AppTextStyle.textSubtitleStyle(color: Colors.white),
              ),
              trailing: trailingIcon != null
                  ? Icon(trailingIcon, color: Colors.white)
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _subMenuTile({
    required String menuIndex,
    required String text,
    required Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5),
      child: Material(
        color: controller.selectedMenuName.value != menuIndex
            ? Colors.transparent
            : AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  text,
                  style: AppTextStyle.textSubtitleStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigateFromOtherWidget(BuildContext context, Widget? newScreen) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
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
                menuIndex: 'pos',
                onTap: () {
                  controller.selectedMenuName.value = 'pos';
                  controller.subMenuName.value = "";
                  navigateFromOtherWidget(context, PosScreen());
                }),
            _menuTile(
              text: "Dashboard",
              icon: "assets/images/menu/view_dashboard_outline_icon_139087.png",
              menuIndex: 'dashboard',
              onTap: () {
                controller.selectedMenuName.value = 'dashboard';
                controller.subMenuName.value = "";
                navigateFromOtherWidget(context, DashboardScreen());
              },
            ),
            _menuTile(
              icon:
                  "assets/images/menu/bag_buy_cart_market_shop_shopping_tote_icon_123191.png",
              text: "Transaksi",
              menuIndex: 'transaksi',
              onTap: () {
                controller.selectedMenuName.value = 'transaksi';
                controller.subMenuName.value = "";
                navigateFromOtherWidget(context, DashboardScreen());
              },
            ),
            _menuTile(
              icon:
                  "assets/images/menu/business_cash_coin_dollar_finance_money_payment_icon_123244.png",
              text: "Finance",
              menuIndex: 'finance',
              onTap: () {
                controller.selectedMenuName.value = 'finance';
                controller.subMenuName.value = "";
                navigateFromOtherWidget(context, DashboardScreen());
              },
            ),
            _menuTile(
              icon:
                  "assets/images/menu/avatar_male_man_people_person_profile_user_icon_123199.png",
              text: "Profil",
              menuIndex: 'profil',
              onTap: () {
                controller.selectedMenuName.value = 'profil';
                controller.subMenuName.value = "";
                navigateFromOtherWidget(context, DashboardScreen());
              },
            ),
            _menuTile(
                icon:
                    "assets/images/menu/product_information_management_icon_149893.png",
                text: "Master",
                menuIndex: '',
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
                  menuIndex: 'master_product',
                  onTap: () {
                    controller.selectedMenuName.value = 'master_product';
                    controller.subMenuName.value = "Produk";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Master Karyawan",
                  menuIndex: 'master_karyawan',
                  onTap: () {
                    controller.selectedMenuName.value = 'master_karyawan';
                    controller.subMenuName.value = "Karyawan";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Master COA",
                  menuIndex: 'master_coa',
                  onTap: () {
                    controller.selectedMenuName.value = 'master_coa';
                    controller.subMenuName.value = "COA";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Master Pengguna",
                  menuIndex: 'master_pengguna',
                  onTap: () {
                    controller.selectedMenuName.value = 'master_pengguna';
                    controller.subMenuName.value = "Pengguna";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Master Pekerjaan",
                  menuIndex: 'master_pekerjaan',
                  onTap: () {
                    controller.selectedMenuName.value = 'master_pekerjaan';
                    controller.subMenuName.value = "Pekerjaan";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Master Rekening",
                  menuIndex: 'master_rekening',
                  onTap: () {
                    controller.selectedMenuName.value = 'master_rekening';
                    controller.subMenuName.value = "Rekening";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Master Kustomer",
                  menuIndex: 'master_customer',
                  onTap: () {
                    controller.selectedMenuName.value = 'master_customer';
                    controller.subMenuName.value = "Customer";
                    controllerKus.isSuplier.value = "0";
                    controllerKus.fetchProducts();
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Master Supplier",
                  menuIndex: 'master_supplier',
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
              menuIndex: '',
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
                  menuIndex: 'laporan_penjualan',
                  onTap: () {
                    controller.selectedMenuName.value = 'laporan_penjualan';
                    controller.subMenuName.value = "Laporan Penjualan";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Laporan Finansial",
                  menuIndex: 'laporan_finansial',
                  onTap: () {
                    controller.selectedMenuName.value = 'laporan_finansial';
                    controller.subMenuName.value = "Laporan Finansial";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Monitor Penjualan",
                  menuIndex: 'laporan_monitor_penjualan',
                  onTap: () {
                    controller.selectedMenuName.value =
                        'laporan_monitor_penjualan';
                    controller.subMenuName.value = "Monitor Penjualan";
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
              _subMenuTile(
                  text: "Laporan Stock",
                  menuIndex: '',
                  onTap: () {
                    controller.selectedMenuName.value = '';
                    navigateFromOtherWidget(context, DashboardScreen());
                  }),
            ],
          ],
        ),
        if (!showLaporanSubMenu && !showMasterSubMenu)
          SizedBox(
            height: 120,
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: masterButton(() {
            controller.logout();
            Get.reset();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false);
          }, 'Logout', Icons.logout),
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
