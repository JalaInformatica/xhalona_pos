import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_screen.dart';
import 'package:xhalona_pos/views/authentication/login/login_screen.dart';
import 'package:xhalona_pos/repositories/product/product_repository.dart';
import 'package:xhalona_pos/views/home/fragment/dashboard/dashboard_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/coa/master_coa_screen.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/monitor/monitor_screen.dart';
import 'package:xhalona_pos/views/home/fragment/transaction/transaction_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/add_edit_product.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/finance/lap_finance_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/bahan/bahan_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/paket/paket_controller.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/penjualan/lap_penjualan_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/master_karyawan_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/pengguna/master_pengguna_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/rekening/master_rekening_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/m_all/master_mAll_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/pekerjaan/master_pekerjaan_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/paket/master_paket_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/bahan/master_bahan_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/kategori/master_kategori_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/supplier/supplier_kustomer_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/supplier/master_kustomer_supplier_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/varian/varian_group/master_varian_group_screen.dart';

// ignore: must_be_immutable
class MasterProductScreen extends StatelessWidget {
  MasterProductScreen({super.key});

  final ProductController controller = Get.put(ProductController());
  final BahanController controllerBahan = Get.put(BahanController());
  final PaketController controllerPaket = Get.put(PaketController());
  ProductRepository _productRepository = ProductRepository();

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

  Widget checkboxItem(String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        Text(
          title,
          style: AppTextStyle.textBodyStyle(),
        ),
      ],
    );
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
            "Master Product",
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
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 47,
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Scrollbar(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        mButton(() {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => MasterVarianGroupScreen(),
                            ),
                            (route) => false,
                          );
                        }, "Master Varian", Icons.layers,
                            170), // Ikon untuk varian
                        SizedBox(width: screenWidth * 0.02),
                        mButton(() {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => MasterKategoriScreen(),
                            ),
                            (route) => false,
                          );
                        }, "Master Kategori", Icons.category,
                            170), // Ikon kategori

                        SizedBox(width: screenWidth * 0.02),
                        mButton(() {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => MasterMasAllScreen(),
                            ),
                            (route) => false,
                          );
                        }, "Master All", Icons.apps,
                            170), // Ikon untuk semua item
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              mButton(() {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AddEditProduct()),
                    (route) => false);
              }, "Add Product", Icons.add, double.infinity),
              SizedBox(
                height: 5.h,
              ),
              Obx(
                () => Row(
                  children: [
                    checkboxItem("Jasa", controller.isJasa.value,
                        (_) => controller.updateFilterJasa()),
                    checkboxItem("Stock", controller.isStock.value,
                        (_) => controller.updateFilterStock()),
                    checkboxItem("Paket", controller.isPaket.value,
                        (_) => controller.updateFilterPaket()),
                    checkboxItem("Promo", controller.isPromo.value,
                        (_) => controller.updateFilterPromo()),
                    checkboxItem("Bahan", controller.isBahan.value,
                        (_) => controller.updateFilterBahan()),
                  ],
                ),
              ),
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
                      AppTableTitle(value: "ID"),
                      AppTableTitle(value: "Image"),
                      AppTableTitle(value: "Produk"),
                      AppTableTitle(value: "Kategori"),
                      AppTableTitle(value: "Ket."),
                      AppTableTitle(value: "Satuan"),
                      AppTableTitle(value: "Qty"),
                      AppTableTitle(value: "Harga"),
                      AppTableTitle(value: "Disc %"),
                      AppTableTitle(value: "Disc (Rp)"),
                      AppTableTitle(value: "Tetap"),
                      AppTableTitle(value: "Terjual Fee %"),
                      AppTableTitle(value: "Fee (Rp)"),
                      AppTableTitle(value: "Ubah Harga"),
                      AppTableTitle(value: "Free"),
                      AppTableTitle(value: "Aksi"),
                      AppTableTitle(value: ""),
                    ],
                    data:
                        List.generate(controller.productHeader.length, (int i) {
                      var product = controller.productHeader[i];
                      return [
                        AppTableCell(
                          value: product.partId,
                          index: i,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                            value: product.mainImage,
                            index: i,
                            isModalBahan:
                                product.isFixQty == true ? true : false,
                            isModalPaket:
                                product.isPacket == true ? true : false,
                            onEdit: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => AddEditProduct(
                                            product: product,
                                          )),
                                  (route) => false);
                            },
                            onDelete: () async {
                              await messageHapus(
                                  product.partId, product.partName);
                            },
                            onPaket: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => MasterPaketScreen(),
                                ),
                                (route) => false,
                              );
                              controllerPaket.filterPartId.value =
                                  product.partId;
                              controllerPaket.fetchProducts();
                            },
                            onBahan: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => MasterBahanScreen(),
                                ),
                                (route) => false,
                              );
                              controllerBahan.filterPartId.value =
                                  product.partId;
                              controllerBahan.fetchProducts();
                            },
                            showOptionsOnTap: true,
                            imageUrl:
                                'https://dreadnought.core-erp.com/XHALONA/${product.mainImage}'),
                        AppTableCell(
                          value: product.partName,
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: product.analisaId,
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: product.ketAnalisa,
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: product.unit1,
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: '${product.qtyPerUnit1}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: '${product.unitPriceNet}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: '${product.discountPct}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: '${product.discountVal}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: '${product.unitPrice}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: '${product.employeeFeePct}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value: '${product.employeeFeeVal}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          value:
                              '${product.isFixPrice == true ? 'Iya' : 'Tidak'}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                        ),
                        AppTableCell(
                          value: '${product.isFree == true ? 'Iya' : 'Tidak'}',
                          index: i,
                          isModalBahan: product.isFixQty == true ? true : false,
                          isModalPaket: product.isPacket == true ? true : false,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          showOptionsOnTap: true,
                        ),
                        AppTableCell(
                          index: i,
                          onEdit: () {
                            goTo(context, product);
                          },
                          onDelete: () async {
                            await messageHapus(
                                product.partId, product.partName);
                          },
                          showOptionsOnTap: true,
                          value: "", // Ganti dengan URL gambar jika ada
                          isEdit: true,
                          isDelete: true,
                        ),
                        AppTableCell(
                          index: i,
                          isPaket: product.isFixQty == true ? true : false,
                          isBahan: product.isPacket == true ? true : false,
                          onPaket: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterPaketScreen(),
                              ),
                              (route) => false,
                            );
                            controllerPaket.filterPartId.value = product.partId;
                            controllerPaket.fetchProducts();
                          },
                          onBahan: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MasterBahanScreen(),
                              ),
                              (route) => false,
                            );
                            controllerBahan.filterPartId.value = product.partId;
                            controllerBahan.fetchProducts();
                          },
                          value: "",
                        )
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

  Future<dynamic> goTo(BuildContext context, ProductDAO product) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => AddEditProduct(product: product)),
        (route) => false);
  }

  Future<dynamic> messageHapus(String partId, String partName) {
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
            "Apakah Anda yakin ingin menghapus data '$partName'?",
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
                String result =
                    await _productRepository.deleteProduct(partId: partId);

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
}
