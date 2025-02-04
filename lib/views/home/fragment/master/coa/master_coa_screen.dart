import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/models/dao/coa.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/repositories/coa/coa_repository.dart';
import 'package:xhalona_pos/views/authentication/login/login_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/coa/add_edit_coa.dart';
import 'package:xhalona_pos/views/home/fragment/master/coa/coa_controller.dart';
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

// ignore: must_be_immutable
class MasterCoaScreen extends StatelessWidget {
  MasterCoaScreen({super.key});

  final CoaController controller = Get.put(CoaController());
  CoaRepository _coaRepository = CoaRepository();

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
      case "profil":
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
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
        iconPath +=
            "avatar_male_man_people_person_profile_user_icon_123199.png";
        break;
    }

    return Obx(() => GestureDetector(
        onTap: () {
          controllerHome.selectedMenuName.value = menuName;
          navigateToMenu(
              menuName, context); // Navigasi sesuai menu yang dipilih
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
                    fontWeight:
                        menuName != controllerHome.selectedMenuName.value
                            ? FontWeight.normal
                            : FontWeight.bold),
              )
            ]))));
  }

  Widget mButton(
      VoidCallback onTap, String label, IconData icon, double? width) {
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
            Text(label,
                style: AppTextStyle.textTitleStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Future<dynamic> messageHapus(String acId, String namaRekening) {
    return SmartDialog.show(builder: (context) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          icon: const Icon(
            Icons.info_outlined,
            color: AppColor.primaryColor,
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Konfirmasi",
            style: AppTextStyle.textTitleStyle(color: AppColor.primaryColor),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "Apakah Anda yakin ingin menghapus data '$namaRekening'?",
            maxLines: 2,
            style: AppTextStyle.textSubtitleStyle(),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                SmartDialog.dismiss(result: false);
              },
              child: Text(
                "Tidak",
                style: AppTextStyle.textBodyStyle(color: AppColor.grey500),
              ),
            ),
            TextButton(
              onPressed: () async {
                String result = await _coaRepository.deleteCoa(accId: acId);

                bool isSuccess = result == "1";
                if (isSuccess) {
                  SmartDialog.dismiss(result: false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data gagal dihapus!')),
                  );
                } else {
                  SmartDialog.dismiss(result: false);
                  controller.fetchProducts();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data berhasil dihapus!')),
                  );
                }
              },
              child: Text(
                "Iya",
                style: AppTextStyle.textBodyStyle(color: AppColor.primaryColor),
              ),
            )
          ]);
    });
  }

  Future<dynamic> goTo(BuildContext context, CoaDAO coa) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AddEditCoa(coa: coa)),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false); // Navigasi kembali ke halaman sebelumnya
        return false; // Mencegah navigasi bawaan
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Master Coa",
            style: AppTextStyle.textTitleStyle(),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false); // Jika tidak, gunakan navigator default
            }, // Navigasi kembali ke halaman sebelumnya
          ),
        ),
        backgroundColor: AppColor.whiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              mButton(() {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AddEditCoa()),
                    (route) => false);
              }, "Add Coa", Icons.add, double.infinity),
              SizedBox(
                height: 5.h,
              ),
              Obx(() => Expanded(
                      child: AppTable(
                    onSearch: (filterValue) =>
                        controller.updateFilterValue(filterValue),
                    onChangePageNo: (pageNo) => controller.updatePageNo(pageNo),
                    onChangePageRow: (pageRow) =>
                        controller.updatePageRow(pageRow),
                    pageNo: controller.pageNo.value,
                    pageRow: controller.pageRow.value,
                    titles: [
                      AppTableTitle(value: "Kode "),
                      AppTableTitle(value: "Nama "),
                      AppTableTitle(value: "jenis"),
                      AppTableTitle(value: "D/K"),
                      AppTableTitle(value: "TM"),
                      AppTableTitle(value: "Aksi"),
                    ],
                    data: List.generate(controller.coaHeader.length, (int i) {
                      var coa = controller.coaHeader[i];
                      return [
                        AppTableCell(
                            value: coa.acId,
                            index: i,
                            onEdit: () {
                              goTo(context, coa);
                            },
                            onDelete: () async {
                              await messageHapus(coa.acId, coa.namaRekening);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: coa.namaRekening,
                            index: i,
                            onEdit: () {
                              goTo(context, coa);
                            },
                            onDelete: () async {
                              await messageHapus(coa.acId, coa.namaRekening);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: coa.jenisRek,
                            index: i,
                            onEdit: () {
                              goTo(context, coa);
                            },
                            onDelete: () async {
                              await messageHapus(coa.acId, coa.namaRekening);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: coa.flagDk,
                            index: i,
                            onEdit: () {
                              goTo(context, coa);
                            },
                            onDelete: () async {
                              await messageHapus(coa.acId, coa.namaRekening);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                            value: coa.flagTm!,
                            index: i,
                            onEdit: () {
                              goTo(context, coa);
                            },
                            onDelete: () async {
                              await messageHapus(coa.acId, coa.namaRekening);
                            },
                            showOptionsOnTap: true),
                        AppTableCell(
                          index: i,
                          onDelete: () async {
                            await messageHapus(coa.acId, coa.namaRekening);
                          },
                          value: "", // Ganti dengan URL gambar jika ada
                          isEdit: true,
                          isDelete: true,
                          onEdit: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => AddEditCoa(
                                          coa: coa,
                                        )),
                                (route) => false);
                          },
                        ),
                      ];
                    }),
                    onRefresh: () => controller.fetchProducts(),
                    isRefreshing: controller.isLoading.value,
                  )))
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Obx(
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
                                      builder: (context) =>
                                          MasterProductScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }, "Master Produk", Icons.shopping_bag, 170),
                                SizedBox(
                                    width: screenWidth *
                                        0.02), // Responsive spacing
                                mButton(() {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MasterKaryawanScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }, "Master Karyawan", Icons.account_circle,
                                    170),
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
                                      builder: (context) =>
                                          MasterPenggunaScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }, "Master Pengguna", Icons.person, 170),
                                SizedBox(width: screenWidth * 0.02),
                                mButton(() {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MasterPekerjaanScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }, "Master Pekerjaan", Icons.work, 170),
                                SizedBox(width: screenWidth * 0.02),
                                mButton(() {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MasterRekeningScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }, "Master Rekening",
                                    Icons.account_balance_wallet, 170),
                                SizedBox(width: screenWidth * 0.02),
                                mButton(() {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MasterKustomerScreen(
                                              islabel: "Kustomer"),
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
                                          MasterKustomerScreen(
                                              islabel: "Supplier"),
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
                                      builder: (context) =>
                                          LapPenjualanScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }, "Lap. Penjualan", Icons.graphic_eq_sharp,
                                    170),
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
                                mButton(
                                    () {}, "Lap. Stock", Icons.inventory, 170),
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
                          ...controllerHome.menuData.map((menuItem) {
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
                          menuComponent("profil", context)
                        ],
                      ),
                    ],
                  ),
                ),
              ])),
        ),
      ),
    );
  }
}
